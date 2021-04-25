
% 4x4 worked for me: horizontal to vertical split
% checking for top eight to be all zero
% 5x5 works
% 6x6 as well
% 7x7 too

% might automate this in a future upload

% and now 

M = 10; N = 10;

% check the region defined by CHKR_X x CHKR_Y
global CHKR_Y;
CHKR_X = 1:N; CHKR_Y = 1:5;

succ = 0;

tic
count = 0;

% init starting grid

grid_ = initgrid(M,N);

[succ, grid_] = horizToVertSim(grid_,CHKR_X,CHKR_Y,1);
while ~succ
    [succ, grid_] = horizToVertSim(grid_,CHKR_X,CHKR_Y,0);
    pause(.05);
    count = count+ 1;
end


disp("this took " + count + " iterations")


function V = slowcooling(I)
    V = .1 - .099 * (I ./ length(I));
end

function G = initgrid(M,N)
    global CHKR_Y;
    G = ones(M, N);
    G(1:M,CHKR_Y) = zeros(M,length(CHKR_Y));
end


function [T, grid_] = horizToVertSim(grid_,CHKR_X,CHKR_Y, forceCLEAR)
T= 0;

[M, N] = size(grid_);

% annealing schedule THESE WORK FOR 4x4
%ITS_ = [1000, 50000, 30000, 1000]';
%LAM_ = [  .5,   .05,  .03, .01]';


% the following worked after ~ 1min of sim for 5x5
%ITS_ = [30000, 20000, 20000, 10000]';

%II = repmat([33000, 33000, 33000],1,3);

tmix = ceil(2 * log(factorial(M*N)/(factorial(M)*factorial(N))));
%ceil(2*M*N * (M*N - 1) * log(M*N*(M*N-1)));

Z = ceil(M*N*log(M*N));
II = repmat([1], 1, Z*tmix);
%LL = repmat([.8,.5,.2],1,3);
LL = [slowcooling(1:tmix*Z), .001];

restart = floor(rand()* M * N);
if restart < 1 || forceCLEAR
    grid_ = initgrid(M,N);
    II = tmix*Z; LL = [1,.001];
elseif restart >  1 + floor(rand()* M*N/4)
    II = 0; LL = [1,.001];
end

ITS_ = [II, 5*tmix*Z];
LAM_ = [LL];

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
                toc;
                pause
                T = 1; return;
            end
        end
        
        B(current) = boundary(grid_);
        
        current = current+1;
    end
end

grid_

%figure(1)
set(0, 'CurrentFigure', 1);
plot(B)
end