

% mutate

function [C, L] = mutatePair(lam, C, s)
    r = ceil(rand()*26);
    R = ceil(rand()*26);
    % cipher(R) swap with cipher(r)
    
    D = C;
    u = C(r);
    D(r) = C(R);
    D(R) = u;
    
    % relative likelier-hood of D w.r.t C
    lD = freqAnal(s, D);
    L = freqAnal(s, C);
    
    l = lD - L;
    
    testlam = power(lam,-log(1-l^26));
    % could normalize for a proper distribution, TODO
    % compute the set of possible likelierhoods by all 
    % mutations of cipher, and take their sum
    
    % nonetheless this stays proportional    
    
    % test lam, z
    z = rand();
    
    if z < testlam, C = D; L = lD; end
end