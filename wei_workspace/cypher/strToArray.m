

function V = strToArray(s)
    s = char(s);
    V = zeros(length(s),1);
    for i = 1:length(s)
        V(i) = s(i) - 'a' + 1;
    end
end