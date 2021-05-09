
% mutate a cipherkey

% this was originally done by swapping a pair of assignments at a time
% but we now do a cipher key-shuffle of all letters

% L is the likelihood (x^2 of the previous cipherkey)
function [C, L, newT] = mutatePair(lam, C, L, prevT)

    global keyScores;
    
    scores = keyScores / sum(keyScores);
    
    % indices to swap
    I = [];
    count = 0;
    
    % reassign at least one pair of letters,
    % sample these according to Keyrank
    while count < 2
    I = logical(false(26,1));
    for i = 1:26
        z = rand();
        if z < scores(i)
            I(i) = true;
        end
    end
    count = sum(I);
    end
       
    % R -> r
    R = 0; r = 0;
    while R == r
    
    % swap the N worst keys
    % R = randsample(keyRank(26-N+1:26), N);
    
    % better yet do this by logical-type indexing
    R = find(I); % logical array to index vector
    r = randsample(R,count);
    end
    
    %     while R == r
    %     r = ceil(rand()*26);
    %     R = ceil(rand()*26);
    %     end
    %              [ cipher(R) swap with cipher(r) ]
    
    % the above pair swap is generalized below for cipher assignments
    % of arbitrary length.
    D = C;
    u = C(r);
    D(r) = C(R);
    D(R) = u;
    
    % relative likelier-hood of D w.r.t C
    % could be done by explicit computation with each cipherkey proposal:
    % lD = freqAnal(s, D);
    % lD - L
    % 
    % better to do only gradient/update informed likelihood
    
    [DIFFERENCE, newT] = ...
         dfreqAnal(R, r, prevT);
    
    testlam = power(lam,tanh(DIFFERENCE)+1);
    
    z = rand();
    
    % accept the new cipherkey and pass along the new likelihood/score
    if z < testlam, C = D; L = L + DIFFERENCE;
    else, newT = prevT; end
end