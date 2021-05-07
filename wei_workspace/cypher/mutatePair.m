

% mutate

% L is the likelihood (x^2 of theprevious)
function [C, L, newT] = mutatePair(lam, C, s, L, prevT)

    global keyRank; global keyScores;
    
    scores = keyScores / sum(keyScores);
    
    % indices to swap
    I = [];
    count = 0;
    
    while count < 2
    %I = [];
    I = logical(false(26,1));
    for i = 1:26
        z = rand();
        if z < scores(i)
            %count = count + 1;
            %I(count) = i;
            I(i) = true;
        end
    end
    count = sum(I);
    end
    
    %R = 0; r = 0;
    
    % R -> r
    R = 0; r = 0;
    while R == r
        
    % number of assignments to swap, M < 13 thru -> N
    %M = ceil(rand() * 13);
    %N = ceil(rand() * 26 - M);
    
    % swap the N worst keys
    %R = randsample(keyRank(26-N+1:26), N);
    R = find(I); % logical array to index vector
    r = randsample(R,count);
    end
%     while R == r
%     r = ceil(rand()*26);
%     R = ceil(rand()*26);
%     end
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
         dfreqAnal(R, r, prevT);
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