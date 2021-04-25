
% determine mixing time by comparing starts on opposite ends
% vertical and horizontal

N = 8;  M = N;

CHKR_X = 1:N; CHKR_Y = 1:4;

MAXITS = 40000;

% grid_h starts horizontally split
grid_h = ones(M, N);
grid_h(1:M,CHKR_Y) = zeros(M,length(CHKR_Y));


grid_v = ones(M, N);
grid_v(CHKR_Y, 1:M) = zeros(length(CHKR_Y), M);


% track difference in boundary
% want it to go to zero for stationary
B_ = zeros(MAXITS,2);
B = zeros(MAXITS,1);

for i = 1:MAXITS
    grid_h = flip_two(grid_h,1);
    grid_v = flip_two(grid_v,1);
    
    B_(i,1) = abs(boundary(grid_h));
    B_(i,2) = abs(boundary(grid_v));
    B(i) = abs(max(B_(1:i,1)) - max(B_(1:i,2)));
end
figure(1);
plot(B);