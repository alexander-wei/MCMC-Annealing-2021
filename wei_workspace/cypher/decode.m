
%  decode ciphertext <v> by cipher C
function V = decode(v,C)
I = 1:26;

invC(C) = I;

V = zeros(length(v),1);

    for i = 1:length(v)
        V(i) = invC(v(i));
    end

end

