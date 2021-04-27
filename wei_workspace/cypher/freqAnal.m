

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

    global properFREQ; global properFREQm;

%     FREQ = zeros(26,1);
%     FREQ([5,6,20,23,25]) = [12000, 2500, 9000, 2000, 2000];
%     FREQ([1,9,14,15,19]) = [8000,8000,8000,8000,8000];
%     FREQ([7,16]) = [1700, 1700];
%     FREQ([8,2,18,22,4,11]) = ...
%         [6400, 1600, 6200, 1200, 4400, 800];
%     FREQ([12,17,21,10,24,3,13,26]) = ...
%         [4000, 500, 3400, 400, 400, 3000, 3000, 200];
% 
%     FREQ = FREQ ./ sum(FREQ);
    %l = FREQ
    
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
    
    for i = 1:26
        % ignore neglible transitions, take only those > 0
        trans_ = properFREQ(i,:) > 0;% ...
        %    & TsC(i,:) > 0;
        %trans_ = 1:26;
        
        aToB = (TsC(i,trans_) - properFREQ(i,trans_)) .^2 ... % ...
            ./ properFREQ(i,trans_);
        ratio = ratio + sum(aToB);
    end
        
    l = ratio;% / length(s) / 0.1128; % .1128 = maxFREQ
end



