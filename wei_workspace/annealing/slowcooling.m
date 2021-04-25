function V = slowcooling(I)
    V = .1 - .099 * (I ./ length(I));
end