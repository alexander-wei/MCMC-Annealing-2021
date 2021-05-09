
% return likelihood (chi^2) given empirical frequencies in <properFREQ>

% EXPLICIT computation of the entire frequencies table
% for gradient/update informed proposals, use dfreqAnal

% how likely is C w.r.t. <properFREQ>
function l = freqAnal(s,C)
    global properFREQ; global keyScores;
    
    sC = decode(s,C);
    
    % digram table for decoded sample
    TsC = digramFreq(arrayToStr(sC));
    
    ratio = 0;
    N = length(s);
    
    % score matrix
    score_ = zeros(26);
    
    for i = 1:26
        trans_ = 1:26;
        
        aToB = (TsC(i,trans_) - properFREQ(i,trans_)) .^2 ... % ...
            ./ properFREQ(i,trans_);
        score_(i,:) = aToB;        
        
        ratio = ratio + sum(aToB);
    end
    
    for i = 1:26
        I = 1:26; I(i) = [];
        keyScores(i) = sqrt(sum(score_(:,i)) + sum(score_(I,i)));   
        % reduce extremes by ranking w.r.t. the square root
    end    
    
    l = ratio;
end



