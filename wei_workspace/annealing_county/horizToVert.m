
% 4x4 worked for me: horizontal to vertical split
% checking for top eight to be all zero
% 5x5 works
% 6x6 as well
% might automate this in a future upload

% and now 

M = 6; N = 6;

% check the region defined by CHKR_X x CHKR_Y
CHKR_X = 1:N; CHKR_Y = 1:3;

succ = 0;

tic

while ~succ
    succ = horizToVertSim(M,N,CHKR_X,CHKR_Y);
    pause(.5);
end
toc

function T = horizToVertSim(M,N,CHKR_X,CHKR_Y)
T= 0;
grid_ = ones(M, N);
grid_(1:M,CHKR_Y) = zeros(M,length(CHKR_Y));

% annealing schedule THESE WORK FOR 4x4
%ITS_ = [1000, 50000, 30000, 1000]';
%LAM_ = [  .5,   .05,  .03, .01]';


% the following worked after ~ 1min of sim for 5x5
%ITS_ = [30000, 20000, 20000, 10000]';

ITS_ = [40000, 40000, 20000, 20000, 40000, 30000, 20000,...
    40000, 30000, 20000, 40000, 30000, 20000]';
LAM_ = [  1,   .8,  .4, .05, .8, .4, .05, .8, .4, .05,...
    .8, .4, .05]';

% this is an improvement, just ~30sec
% LAM_ = [  1,   .8,  .4, .05]'; <-----
% ~30 s. LAM_ = [  1,   .5,  .05, .02]';
% LAM_ = [  1,   .05,  .02, .01]';
S = zeros(length(ITS_), 2);

% ITs_1 | ITs_2 | ...
% LAM_1 | LAM_2 | ...
S(:,1) = ITS_;
S(:,2) = LAM_;

[m,foo] = size(S);

% plot boundaries
B = zeros(sum(S(:,1)),1);

current = 1;
for i=1:m
    ITS = S(i,1);
    for j=1:ITS
        grid_ = flip_two(grid_,S(i,2));
        
        BB = boundary(grid_);
        if BB == N
            if sum(grid_(CHKR_Y,CHKR_X), 'all') == 0 ...
                    || sum(grid_(CHKR_Y,CHKR_X), 'all')...
                        == length(CHKR_Y) * length(CHKR_X)
                grid_
                pause
                T = 1; return;
            end
        end
        
        B(current) = boundary(grid_);
        
        current = current+1;
    end
end

grid_

figure(1)
plot(B)
end