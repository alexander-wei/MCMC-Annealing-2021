function V = slowcooling(I,i)
    %V = 1 - .999 * (I ./ length(I));
    %V = .02 - .019 * (I ./ length(I));
    if i == 1
        V = exp(log(.001) .* I ./ length(I));
    else
        V = .005 - .004 .* I ./ length(I);
    end
end