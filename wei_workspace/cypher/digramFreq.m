

% digram frequency table

function T = digramFreq(s)
    N = strlength(s);
    
    N = N - mod(N,2);
    S = char(s);
    T = zeros(26);
    for i = 1:N/2-1
        % A to A+1
        A = 2 * (i-1) + 1;
        a = strToArray(S(A:A+1));
        T(a(1),a(2)) = T(a(1),a(2)) + 1;
        a = strToArray(S(A+1:A+2));
        T(a(1),a(2)) = T(a(1),a(2)) + 1;
        %T(i) = S(A:A+1);
    end
    for i = 1:26
        if sum(T(i,:)) > 0, T(i,:) = T(i,:) ./ sum(T(i,:)); end
    end
end