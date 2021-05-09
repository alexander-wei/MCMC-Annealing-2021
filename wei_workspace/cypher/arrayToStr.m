
function s = arrayToStr(V)
    s = "";
    for i = 1:length(V)
        s = s + char(V(i) + 'a' - 1);
    end
end