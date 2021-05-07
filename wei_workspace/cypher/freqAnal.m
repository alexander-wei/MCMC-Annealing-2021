

% return likelihood given empirical frequencies (English)

 	
% 12,000 	E 	2,500 	F
% 9,000 	T 	2,000 	W, Y
% 8,000 	A, I, N, O, S 	1,700 	G, P

% 6,400 	H 	1,600 	B
% 6,200 	R 	1,200 	V
% 4,400 	D 	800 	K

% 4,000 	L 	500 	Q
% 3,400 	U 	400 	J, X
% 3,000 	C, M 	200 	Z

% https://www3.nd.edu/~busiforc/handouts/cryptography/letterfrequencies.html

%compare cipher C to D by frequency

% how likely is C
function l = freqAnal(s,C)

    global properFREQ; global keyScores; global keyRank;
    
    sC = decode(s,C);
    
    % digram table for decoded sample
    TsC = digramFreq(arrayToStr(sC));
    
    ratio = 0;
%     
%     TT = zeros(26,2);
%     TT(:,1) = 1:26;
%     
%     T = tabulate(sC);
%     TT(T(:,1),2) = T(:,3)/100; % percent points
    
    N = length(s);
    
    % score matrix
    score_ = zeros(26);
    
    for i = 1:26
        % ignore neglible transitions
        trans_ = 1:26;% ...
        %    & TsC(i,:) > 0;
        %trans_ = 1:26;
        
        aToB = (TsC(i,trans_) - properFREQ(i,trans_)) .^2 ... % ...
            ./ properFREQ(i,trans_);
        score_(i,:) = aToB;        
        
        ratio = ratio + sum(aToB);
    end
    
    for i = 1:26
        I = 1:26; I(i) = [];
        keyScores(i) = sqrt(sum(score_(:,i)) + sum(score_(I,i)));   
        % reduce extremes
    end
    
    [foo, keyRank] = sort(keyScores);
    
        
    l = ratio;% / length(s) / 0.1128; % .1128 = maxFREQ
end



