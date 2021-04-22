

% a flip of consecutive assignments

function g = flip_two(region, lam)

g = region;

[m,n] = size(region);

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

% temp assignment before checking lambda and passing
region(Y:Y+DY,X:X+DX) = subreg;

% check below ratio: <region> is swapped, <g> is original
% simple difference is a whole lot better, think in terms
% of scaling this as the region grows on a whole
RR = boundary(region) - boundary(g);

if testlam < power(lam,RR)  
    g(Y:Y+DY,X:X+DX) = subreg;
end



