
% 4x4 worked for me: horizontal to vertical split
% checking for top eight to be all zero
% 5x5 works
% 6x6 as well
% 7x7 too

% might automate this in a future upload

% and now 

M = 4; N = 4;

% check the region defined by CHKR_X x CHKR_Y
global CHKR_Y;
CHKR_X = 1:N; CHKR_Y = 1:2;

succ = 0;

tic
count = 0;

% init starting grid

grid_ = initgrid(M,N);

bd= boundary(grid_);

[succ, grid_,bd, bestB, bestG] = ...
    horizToVertSim(grid_,CHKR_X,CHKR_Y,1,bd);
bd
pause
%bestBd = bd;
while ~succ
    if bestB == M, bestB = bd; bestG = grid_; end %avoid getting stuck
    [succ, grid_,bd, bestB, bestG] = ...
        horizToVertSim(bestG,CHKR_X,CHKR_Y,0,bestB);
    
    bd
    pause(.05);
    pause
    count = count+ 1;
end


disp("this took " + count + " iterations")
