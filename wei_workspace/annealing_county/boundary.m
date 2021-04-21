

function b = boundary(region)
    % return boundary of region containing (x,y)
    [m, n] = size(region);
    b = 0;
    for i=1:m
        for j=1:n-1
            X = region(i,j);
            if i ~= m && region(i+1,j) ~= X, b = b+1; end
            if region(i,j+1) ~= X, b = b+1; end
        end
    end
end