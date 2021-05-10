import numpy as np
import os

# Constants for printing graphs to terminal
CREDBG    = '\33[41m'
CBLUEBG   = '\33[44m'
CEND  = '\033[0m'

# Ensure that a grid location is in bounds
def check_bounds(val, N):
    return val > -1 and val < N    

# Returns number of units in component -- used to check district connectivity
def count_component_size(grid, stack, component_id):
    N = len(grid)
    marks = np.zeros(grid.shape, dtype=np.int32)
    elems = 0
    while len(stack) > 0:
        v = stack.pop()
        x = v[0]
        y = v[1]
        marks[x, y] = 1
        elems +=+ 1
        for increment in (-1, 1):
            if check_bounds(x+increment, N) and marks[x+increment, y] == 0 and grid[x+increment, y] == component_id:
                stack.append((x+increment, y))
                marks[x+increment, y] = 1
            if check_bounds(y+increment, N) and marks[x, y+increment] == 0  and grid[x, y+increment] == component_id:
                stack.append((x, y+increment))
                marks[x, y+increment] = 1
    return elems

# Further experiment: modify to locate an element on the boundary for faster feasible proposals
def locate_random_element(grid, component_id, rng):
    N = len(grid)
    loc = rng.integers(N, size=2)
    while(grid[loc[0], loc[1]] != component_id):
        loc = rng.integers(N, size=2)
    return loc

# Give proposed sources for the DFS so that we can stop unproductive searches early.
def check_connectivity(grid, rng, loc_zero, loc_one):
    N = len(grid)
    return count_component_size(grid, [loc_zero], 0) == N * N / 2 and count_component_size(grid, [loc_one], 1) == N * N / 2

def propose_flip(grid, rng):
    proposal = [[-1, -1], [-1, -1]]
    while(proposal[0][0] == -1):
        loc_zero = locate_random_element(grid, 0, rng)
        loc_one = locate_random_element(grid, 1, rng)
        grid[loc_zero[0], loc_zero[1]] = 1
        grid[loc_one[0], loc_one[1]] = 0
        if(check_connectivity(grid, rng, loc_one, loc_zero)):
            proposal = [loc_zero, loc_one]
        grid[loc_zero[0], loc_zero[1]] = 0
        grid[loc_one[0], loc_one[1]] = 1
    return proposal

def is_on_boundary(grid, location):
    N = len(grid)
    x = location[0]
    y = location[1]
    component_id = grid[x, y]
    for increment in (-1, 1):
        if check_bounds(x+increment, N) and grid[x+increment, y] != component_id:
            return 1
        if check_bounds(y+increment, N) and grid[x, y+increment] != component_id:
            return 1
    return 0

def count_boundary_edges(grid, location):
    N = len(grid)
    x = location[0]
    y = location[1]
    component_id = grid[x, y]
    edges = 0
    for increment in (-1, 1):
        if check_bounds(x+increment, N) and grid[x+increment, y] != component_id:
            edges += 1
        if check_bounds(y+increment, N) and grid[x, y+increment] != component_id:
            edges += 1
    return edges

# Change in number of boundary edges
def calc_change_boundary(grid, proposed_flip):
    N = len(grid)
    loc_zero = proposed_flip[0]
    loc_one = proposed_flip[1]

    delta_boundary_districts = 0
    delta_boundary_edges = 0
    for loc in (loc_zero, loc_one):
        delta_boundary_edges -= count_boundary_edges(grid, loc)
        x = loc[0]
        y = loc[1]
        for increment in (-1, 1):
            if check_bounds(x+increment, N):
                delta_boundary_districts -= is_on_boundary(grid, [x+increment, y])
            if check_bounds(y+increment, N):
                delta_boundary_districts -= is_on_boundary(grid, [x, y+increment])
        delta_boundary_districts -= is_on_boundary(grid, [x, y])

    grid[loc_zero[0], loc_zero[1]] = 1
    grid[loc_one[0], loc_one[1]] = 0

    for loc in (loc_zero, loc_one):
        delta_boundary_edges += count_boundary_edges(grid, loc)
        x = loc[0]
        y = loc[1]
        for increment in (-1, 1):
            if check_bounds(x+increment, N):
                delta_boundary_districts += is_on_boundary(grid, [x+increment, y])
            if check_bounds(y+increment, N):
                delta_boundary_districts += is_on_boundary(grid, [x, y+increment])
        delta_boundary_districts += is_on_boundary(grid, [x, y])
    
    grid[loc_zero[0], loc_zero[1]] = 0
    grid[loc_one[0], loc_one[1]] = 1

    # Normalize so that these are on roughly similar scales.  Constant found through experimentation
    return delta_boundary_edges / 4 + delta_boundary_districts

def perform_flip(grid, lam, rng):
    proposal = propose_flip(grid, rng)
    change_boundary = calc_change_boundary(grid, proposal)
    if change_boundary <= 0 or rng.random() < lam ** change_boundary:
        loc_zero = proposal[0]
        loc_one = proposal[1]
        grid[loc_zero[0], loc_zero[1]] = 1
        grid[loc_one[0], loc_one[1]] = 0
        return True
    return False

def anneal(grid, temp_fun, goal_fun, rng, max_iters):
    successful = False
    for i in range(max_iters):
        if i % 1000 == 0:
            print("Progress Check! i =", i)
            pretty_print_grid(grid)
        temp = temp_fun(i)
        res = perform_flip(grid, temp, rng)
        # Don't check when temp = 1, you will never be meeting the goal in the pure mixing phase
        # Don't check when not accepted, as this will never achieve the goal
        if(res and temp < 1 and goal_fun(grid)):
            print("Objective Achieved!")
            pretty_print_grid(grid)
            successful = True
            break
    if not successful:
        print("Annealing was Unsuccessful.  Printing grid now")
        pretty_print_grid(grid)
    return successful

# If the middle row is totally correct then we must have a horizontal split
# In practice it's infeasible to expect exactly this.
def is_horizontal_split(grid):
    N = len(grid)
    x = 0
    y = N // 2 - 1
    component_id = grid[y, x]
    while(grid[y, x] == component_id):
        x = x + 1
        if x == N:
            return True
    return False

# Generates linear-type temperature functions, with short periods of pure mixing and pure hill-climb at the beginning and end
def linear_temp_generator(period):
    return lambda t: 1 if t % period < period / 10 else 0 if t % period > 9 * period / 10 else 1 - (t % period - period / 10) / (4 * period / 5)

def steep_linear_temp_generator(period):
    return lambda t: 1 if t % period < period / 5 else 0 if t % period > 4 * period / 5 else 1 - (t % period - period / 5) / (3 * period / 5)

def all_or_nothing_linear_temp_generator(period):
    return lambda t: 1 if t < period / 4 else 0

def pretty_print_grid(grid):
    N = len(grid)
    for i in range(N):
        for j in range(N):
            print((CREDBG if grid[i, j] == 1 else CBLUEBG) + "  " + CEND, end="")
        print("")

# Was able to achieve this flip around 4000 iterations
def six_flip_run():
    rng = np.random.default_rng(0)
    N = 6
    row = np.hstack((np.ones(N//2, dtype=np.int32), np.zeros(N//2, dtype=np.int32)))
    grid = np.tile(row, (N, 1))
    anneal(grid, linear_temp_generator(10000), is_horizontal_split, rng, 100000)

# Was able to achieve this flip around 13000 iterations
def ten_flip_run():
    rng = np.random.default_rng(3)
    N = 10
    row = np.hstack((np.ones(N//2, dtype=np.int32), np.zeros(N//2, dtype=np.int32)))
    grid = np.tile(row, (N, 1))
    anneal(grid, linear_temp_generator(20000), is_horizontal_split, rng, 100000)

# Was able to achieve this flip around 16000 iterations
def sixteen_flip_run():
    rng = np.random.default_rng(3)
    N = 16
    row = np.hstack((np.ones(N//2, dtype=np.int32), np.zeros(N//2, dtype=np.int32)))
    grid = np.tile(row, (N, 1))
    anneal(grid, all_or_nothing_linear_temp_generator(40000), is_horizontal_split, rng, 50000)

# Was able to achieve this flip around 35000 iterations
def twenty_flip_run():
    rng = np.random.default_rng(4)
    N = 20
    row = np.hstack((np.ones(N//2, dtype=np.int32), np.zeros(N//2, dtype=np.int32)))
    grid = np.tile(row, (N, 1))
    anneal(grid, steep_linear_temp_generator(40000), is_horizontal_split, rng, 40000)

# Flip achieved around 390,000 iterations
def thirty_flip_run():
    rng = np.random.default_rng(3)
    N = 30
    row = np.hstack((np.ones(N//2, dtype=np.int32), np.zeros(N//2, dtype=np.int32)))
    grid = np.tile(row, (N, 1))
    anneal(grid, steep_linear_temp_generator(400000), is_horizontal_split, rng, 400000)

# Flip achieved around 877,000 iterations (not perfect but about the best we can hope for)
def forty_flip_run():
    rng = np.random.default_rng(0)
    N = 40
    row = np.hstack((np.ones(N//2, dtype=np.int32), np.zeros(N//2, dtype=np.int32)))
    grid = np.tile(row, (N, 1))
    anneal(grid, steep_linear_temp_generator(1000000), is_horizontal_split, rng, 1000000)

def main():
    os.system("")
    # six_flip_run()
    # ten_flip_run()
    sixteen_flip_run()
    # twenty_flip_run()
    # thirty_flip_run()
    # forty_flip_run()
    
if __name__ == "__main__":
    main()
    
