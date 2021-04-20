

%  annealing districts
% recombine two


grid_ = ones(5,5);
grid_(1:5,1:2) = zeros(5,2);
%floor(rand(5) * 2);
sum(grid_(:))
for i = 1:100
    grid_ = swap(grid_)
    pause
end
swap(grid_)
sum(grid_(:))

function f = swap(region)
    [m, n] = size(region);
    entries = region(:);
    
    resample_ = randsample(entries(:), length(entries), false);
    resample = zeros(m,n);
    for i = 1:m
        resample(i,:) = resample_(1+(i-1)*n:i*n);
    end
    f = resample;
end

function b = connected(region)
    for R = 0:1
        
    end

end

function c = count(region,v) % nubmer of dots in a region
    % if these sum to the exact number of dots then we
    % know they're connected
    
    [m,n] = size(region);
    [w,a,s,d] = zeros(1,4);
    % bordering
    
    M = 0;
    
    for i=1:m
        for j=1:n
            if region(i,j) == v
                M = M+1;
            end
        end
    end
    
    c = M;

end