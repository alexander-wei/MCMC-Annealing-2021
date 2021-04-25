

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
elseif restart >  1 + floor(rand()* M)
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