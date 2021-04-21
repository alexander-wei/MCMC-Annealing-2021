
% 4x4 worked for me: horizontal to vertical split
% checking for top eight to be all zero

M = 4; N = 4;

% check the region defined by CHKR_X x CHKR_Y
CHKR_X = 1:N; CHKR_Y = 1:2;

succ = 0;

while ~succ
    succ = horizToVertSim(M,N,CHKR_X,CHKR_Y);
    pause(.5);
end

function T = horizToVertSim(M,N,CHKR_X,CHKR_Y)
T= 0;
grid_ = ones(M, N);
grid_(1:M,1:2) = zeros(M,2);

% annealing schedule
ITS_ = [1000, 50000, 30000, 1000]';
LAM_ = [  .5,   .05,  .03, .01]';
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
        if BB == 4
            if sum(grid_(CHKR_Y,CHKR_X), 'all') == 0 ...
                    || sum(grid_(CHKR_Y,CHKR_X), 'all') == 0
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