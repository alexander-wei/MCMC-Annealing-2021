% dfreqAnal


function [dl, newT] = dfreqAnal(s,C,swap, prevT)
    % pass the previous cipher's prevT and swap rows/cols
    % pass the swap vector (a,b)
    a = swap(1); b = swap(2);
    
    global properFREQ; global properFREQm;
    
    % sC = decode(s,C);
    
    % digram table for decoded sample
    %TsC = digramFreq(arrayToStr(sC));
    
    ratio = 0;
    newT = prevT;
    temp = prevT(a,:);
    newT(a,:) = prevT(b,:);
    newT(b,:) = temp;
    
    temp = newT(:,a);
    newT(:,a) = newT(:,b);
    newT(:,b) = temp;
%     
%     TT = zeros(26,2);
%     TT(:,1) = 1:26;
%     
%     T = tabulate(sC);
%     TT(T(:,1),2) = T(:,3)/100; % percent points
    
% the rows of a, b
    for K = [a,b]
    trans_ = properFREQ(K,:) > 0; %...
        % & newT(K,:) > 0 & prevT(K,:) > 0; wasn't cleaning the digram
        % tables
    ratio = ratio ...
        + ...
        sum(newT(K,:) .* (2 .* properFREQ(K,:) - newT(K,:)) ...
            ./ properFREQ(K,:) ...
        - prevT(K,:) .* (2 .* properFREQ(K,:) - prevT(K,:)) ...% ...
            ./ properFREQ(K,:));
    end
    
    % the columns
    I = [1:min(a,b)-1, min(a,b)+1: max(a,b)-1, max(a,b)+1: 26]; % avoid doublecounts
    for K = [a,b]
    trans_ = properFREQ(I,K) > 0; %...
         %& newT(I,K) > 0 & prevT(I,K) > 0;
    ratio = ratio ...
        + ...
        sum(newT(I,K) .* (2 .*  properFREQ(I,K) - newT(I,K)) ...
             ./ properFREQ(I,K) ...
        - prevT(I,K) .* (2 .*  properFREQ(I,K) - prevT(I,K)) ...
            ./ properFREQ(I,K));
    end
    
    if isnan(ratio)
        pause
    end
   
        
    dl = -ratio;% / length(s) / 0.1128; % .1128 = maxFREQ
    % this is OLDLIKELIHOOD - NEWLIKELIHOOD
    
end

