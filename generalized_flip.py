# Required for pretty printing of grids
import os
import numpy as np
from simple_flip import locate_random_element, check_connectivity, check_bounds, is_on_boundary, count_boundary_edges, is_horizontal_split, pretty_print_grid, linear_temp_generator


def perform_generalized_flip(grid, zeros, ones, assignment):
    k = len(zeros)
    last_one = None
    last_zero = None
    for i in range(k):
        z = zeros[i]
        o = ones[i]
        if assignment[i] == 1:
            last_one = z
        if assignment[i+k] == 0:
            last_zero = o
        grid[z[0], z[1]] = assignment[i]
        grid[o[0], o[1]] = assignment[k+i]
    return last_zero, last_one

def accept_reject_generalized_flip(grid, lam, rng, k):
    zeros, ones, assignment = propose_generalized_flip(grid, rng, k)
    change_boundary = calc_generalized_change_boundary(grid, zeros, ones, assignment)
    if change_boundary <= 0 or rng.random() < lam ** change_boundary:
        perform_generalized_flip(grid, zeros, ones, assignment)
        return True
    return False

def undo_generalized_flip(grid, zeros, ones):
    k = len(zeros)
    for i in range(k):
        z = zeros[i]
        o = ones[i]
        grid[z[0], z[1]] = 0
        grid[o[0], o[1]] = 1

def propose_generalized_flip(grid, rng, k):
    proposal = None
    while (proposal is None):
        zeros = {}
        ones = {}
        zeros_list = []
        ones_list = []
        zeros_added = 0
        while zeros_added < k:
            loc_zero = tuple(locate_random_element(grid, 0, rng))
            if loc_zero not in zeros:
                zeros[loc_zero] = True
                zeros_list.append(loc_zero)
                zeros_added += 1
        ones_added = 0
        while ones_added < k:
            loc_one = tuple(locate_random_element(grid, 1, rng))
            if loc_one not in ones:
                ones[loc_one] = True
                ones_list.append(loc_one)
                ones_added += 1
        assignment = np.hstack((np.zeros(k, dtype=np.int32), np.ones(k, dtype=np.int32)))
        rng.shuffle(assignment)
        last_zero, last_one = perform_generalized_flip(grid, zeros_list, ones_list, assignment)
        if last_zero is not None and check_connectivity(grid, rng, last_zero, last_one):
            proposal = zeros_list, ones_list, assignment
        undo_generalized_flip(grid, zeros_list, ones_list)
    return proposal

def calc_generalized_change_boundary(grid, zeros, ones, assignment):
    N = len(grid)
    k = len(zeros)
    delta_boundary_districts = 0
    delta_boundary_edges = 0

    # Collect changed locations and their (rook-connected) neighbors
    changed_locations = {}
    changed_locations_list = []
    
    for i in range(k):
        if assignment[i] == 1:
            candidate = zeros[i]
            x = candidate[0]
            y = candidate[1]
            if (x, y) not in changed_locations:
                changed_locations_list.append(candidate)
                changed_locations[(x, y)] = True
            for increment in (-1, 1):
                if check_bounds(x+increment, N):
                    if (x+increment, y) not in changed_locations:
                        changed_locations_list.append([x+increment, y])
                        changed_locations[(x+increment, y)] = True
                if check_bounds(y+increment, N):
                    if (x, y+increment) not in changed_locations:
                        changed_locations_list.append([x, y+increment])
                        changed_locations[(x, y+increment)] = True
        if assignment[i+k] == 0:
            candidate = ones[i]
            x = candidate[0]
            y = candidate[1]
            if (x, y) not in changed_locations:
                changed_locations_list.append(candidate)
                changed_locations[(x, y)] = True
            for increment in (-1, 1):
                if check_bounds(x+increment, N):
                    if (x+increment, y) not in changed_locations:
                        changed_locations_list.append([x+increment, y])
                        changed_locations[(x+increment, y)] = True
                if check_bounds(y+increment, N):
                    if (x, y+increment) not in changed_locations:
                        changed_locations_list.append([x, y+increment])
                        changed_locations[(x, y+increment)] = True

    for loc in changed_locations_list:
        delta_boundary_districts -= is_on_boundary(grid, loc)
        delta_boundary_edges -= count_boundary_edges(grid, loc)

    perform_generalized_flip(grid, zeros, ones, assignment)
    for loc in changed_locations_list:
        delta_boundary_districts += is_on_boundary(grid, loc)
        delta_boundary_edges += count_boundary_edges(grid, loc)
    
    undo_generalized_flip(grid, zeros, ones)

    # Experimented with several weightings here -- this was the most successful
    return delta_boundary_edges / 4 + delta_boundary_districts

def generalized_anneal(grid, temp_fun, goal_fun, rng, max_iters, k, objective=True):
    successful = False
    for i in range(max_iters):
        if i % 1000 == 0:
            print("Progress Check! i =", i)
            pretty_print_grid(grid)
        temp = temp_fun(i)
        res = accept_reject_generalized_flip(grid, temp, rng, k)
        # Don't check when temp = 1, you will never be meeting the goal in the pure mixing phase
        # Don't check when not accepted, as this will never achieve the goal
        if(objective and res and temp < 1 and goal_fun(grid)):
            print("Objective Achieved!")
            pretty_print_grid(grid)
            successful = True
            break
    if not successful:
        print("Annealing was Unsuccessful.  Printing grid now")
        pretty_print_grid(grid)
    return successful

# Flips in ~8000 its
def generalized_ten_flip_run():
    rng = np.random.default_rng(0)
    N = 10
    row = np.hstack((np.ones(N//2, dtype=np.int32), np.zeros(N//2, dtype=np.int32)))
    grid = np.tile(row, (N, 1))
    generalized_anneal(grid, linear_temp_generator(10000), is_horizontal_split, rng, 10000, 5)

# Some interesting exploration happens here around 10000-13000
# Because you have to "take the good with the bad" you get a more interesting texture
# Flips completely around 16000
def generalized_sixteen_flip_run():
    rng = np.random.default_rng(2)
    N = 16
    row = np.hstack((np.ones(N//2, dtype=np.int32), np.zeros(N//2, dtype=np.int32)))
    grid = np.tile(row, (N, 1))
    generalized_anneal(grid, linear_temp_generator(20000), is_horizontal_split, rng, 20000, 5)

# Significantly less efficient than corresponding regular flip chain -- was not able to get a good experiment
def generalized_twentyfour_flip_run(seed, period):
    rng = np.random.default_rng(seed)
    N = 24
    row = np.hstack((np.ones(N//2, dtype=np.int32), np.zeros(N//2, dtype=np.int32)))
    grid = np.tile(row, (N, 1))
    generalized_anneal(grid, long_mix_short_cool_temp_generator(period), is_horizontal_split, rng, period, 5)

# These two aren't too useful in practice, just experiments
def very_short_mix_long_cool_temp_generator(period):
    return lambda t: 1 if t % period < period / 10 else 1 - (t % period - period / 10) / (2 * period / 5) if t % period < period / 2 else 0

def long_mix_short_cool_temp_generator(period):
    return lambda t: 1 if t % period < period / 2 else 1 - (t % period - period / 2) / (period / 4) if t % period < 3 * period / 4 else 0

def main():
    os.system("")
    generalized_ten_flip_run()
    # generalized_sixteen_flip_run()
    # generalized_twentyfour_flip_run(5, 20000)
    # generalized_twentyfour_flip_run(6, 28000)
    # generalized_twentyfour_flip_run(7, 40000)

if __name__ == "__main__":
    main()