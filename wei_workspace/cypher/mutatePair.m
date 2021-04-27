

% mutate

% L is the likelihood (x^2 of theprevious)
function [C, L, newT] = mutatePair(lam, C, s, L, prevT)
    R = 0; r = 0;
    while R == r
    r = ceil(rand()*26);
    R = ceil(rand()*26);
    end
    % cipher(R) swap with cipher(r)
    
    D = C;
    u = C(r);
    D(r) = C(R);
    D(R) = u;
    
    % relative likelier-hood of D w.r.t C
    %lD = freqAnal(s, D);
    %disp("compare")
    %lD - L
    % dfreqAnal(s,C,swap, prevT)
    % C is thrownaway argument, TODO
    [DIFFERENCE, newT] = ...
         dfreqAnal(s,1:26, [R,r], prevT);
    % DIFFERENCE
    % disp("###")
    
    % L = freqAnal(s, C);
    % log(ld/L) worked
    %l = lD - L
   % lD
    % >> worked overnight>>
    testlam = power(lam,tanh(DIFFERENCE)+1);
    %testlam = power(lam,tanh((-DIFFERENCE))+1);%log(lD/L));
    
    % testlam = power(lam,tanh(* DIFFERENCE)+1);
    
    % could normalize for a proper distribution, TODO
    % compute the set of possible likelierhoods by all 
    % mutations of cipher, and take their sum
    
    % nonetheless this stays proportional    
    
    % test lam, z
    z = rand();
    %disp("####");
    
    if z < testlam, C = D; L = L + DIFFERENCE;
    else, newT = prevT; end
    % newT = prevT; % todo remove
end