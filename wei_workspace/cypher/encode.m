
% encode plaintext <v> via cipher C

function V = encode(v,C)

V = zeros(length(v),1);

    for i = 1:length(v)
        V(i) = C(v(i));
    end

end

