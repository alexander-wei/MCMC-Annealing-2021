
% produce the digram frequencies table by only the necc. updates
function [dl, newT] = dfreqAnal(swap, swapped, prevT)
    % pass the previous cipher's prevT and swap rows/cols
    % ---- these are first order transition frequencies (digrams)
    % pass the swap vector (a,b,...,z)
    
    global properFREQ;
    
    ratio = 0;
    
    newT = prevT;
    newT(swap,:) = prevT(swapped,:);
    
    temp = newT(:,swapped);
    newT(:,swap) = temp;
    
    % across the rows (a,b,...,z)
    for K = swap
    ratio = ratio ...
        + ...
        sum(newT(K,:) .* (2 .* properFREQ(K,:) - newT(K,:)) ...
            ./ properFREQ(K,:) ...
        - prevT(K,:) .* (2 .* properFREQ(K,:) - prevT(K,:)) ...% ...
            ./ properFREQ(K,:), 'all');
    end
    
    % down the columns
    %I = [1:min(a,b)-1, min(a,b)+1: max(a,b)-1, max(a,b)+1: 26]; % avoid doublecounts
    I = 1:26;
    I(swap) = []; % don't double count
    
    for K = swap
    ratio = ratio ...
        + ...
        sum(newT(I,K) .* (2 .*  properFREQ(I,K) - newT(I,K)) ...
             ./ properFREQ(I,K) ...
        - prevT(I,K) .* (2 .*  properFREQ(I,K) - prevT(I,K)) ...
            ./ properFREQ(I,K), 'all');
    end
    
    if isnan(ratio)
        pause
    end
        
    dl = -ratio;
    % this is OLDLIKELIHOOD - NEWLIKELIHOOD
    %           score            score
    
end

