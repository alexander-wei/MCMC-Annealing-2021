

% a flip of consecutive assignments

% Db the change in boundary
function [g, Db] = flip_two(region, lam)

g = region;

[m,n] = size(region);


goodswap = false;

while ~goodswap

% vertical or horizontal
vert = floor(rand() * 2);

DX = 0; DY = 0;
if vert, DY = 1; else, DX = 1; end

% choose two block region
X = ceil(rand() * (n - DX));
Y = ceil(rand() * (m - DY));

subreg = region(Y:Y+DY, X:X+DX);

testlam = rand();

if 1 % todo remove this stub, lamb testing done AFTER swap
    temp = subreg(1,1);
    if vert
        subreg(1,1) = subreg(2,1);
        subreg(2,1) = temp;
    else
        subreg(1,1) = subreg(1,2);
        subreg(1,2) = temp;
    end
end

if vert && subreg(1,1) ~= subreg(2,1) ...
        || ~vert && subreg(1,1) ~= subreg(1,2)
    goodswap = true;
end

end

% temp assignment before checking lambda and passing
region(Y:Y+DY,X:X+DX) = subreg;

% check below ratio: <region> is swapped, <g> is original
% simple difference is a whole lot better, think in terms
% of scaling this as the region grows on a whole

CHKY = max(Y-2,1): min(Y+DY+2,m);
CHKX = max(X-2,1): min(X+DY+2,n);

RR = boundary(region(CHKY,CHKX)) - boundary(g(CHKY,CHKX));
% region(CHKY,CHKX)
% g(CHKY,CHKX)
RR_ = -6:1:6;

%if abs(RR) == 6, disp(region); pause,end
%power(lam, RR + 6);
% OR just accept any improvement
Db = 0;
if testlam < power(lam, (RR + 6)/12) ...
        / sum(power(lam,(RR_ + 6)/12))%power(lam,RR)  
    g(Y:Y+DY,X:X+DX) = subreg;
    Db = RR;
end



