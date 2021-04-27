
%sampleEncode();
% first generate sample S and starting guess G

%G = 1:26;

S_ = strToArray(S);

% annealing schedule Z


%s = fileread("TalksWith.txt");
s = fileread("TreatiseHumanNature.txt");
s = regexprep(lower(s),"[^a-z]","");

global properFREQ;
properFREQ = digramFreq(s);

% marginal distribution of indiv. letters
I = 1:26;
global properFREQm;
properFREQm = sum(properFREQ(:,I))./sum(sum(properFREQ(:,I)));

properFREQ(properFREQ < .01) = .01;
%properFREQ(properFREQ < 0.1) = 0;

% best (<Cipher>, score)

% stage I initialize best cipher tracking
%G = cypher();
%bestC = G;
%bestS = freqAnal(S_,G);

while 1
    
% Stage II reset: 
G = bestC;
 
% Stage II Schedule
ITS_ = [0, repmat([1],1,0),500, 2000]'; %1000 -> 10000
LAM_ = [1, slowcoolings(1:0), bumpcooling(1:500),.01]';

% Stage I Schedule -- transposition shuffle mixing time
%ITS_ = [170, repmat([1],1,200), 500]';
%LAM_ = [1, slowcoolings(1:200), .01]';


% [.000001, .0000001, .0000001]
BB = zeros(sum(ITS_),1);

current = 1;

% initialize
L = freqAnal(S_,G);

prevT = digramFreq(arrayToStr(decode(strToArray(S),G)));

for i = 1:length(ITS_)
    
    ITS = ITS_(i);
    LAM = LAM_(i);
    for j = 1:ITS
        if mod(j,50) == 0
            prevT = digramFreq(arrayToStr(decode(S_,G)));
            L = freqAnal(S_,G);
        end
        [G, L, prevT] = mutatePair(LAM,G,S_, L, prevT);
        
        if L < bestS, bestS = L; bestC = G; end
        % arrayToStr(decode(S_,G))
        BB(current) = L;
%         if contains(arrayToStr(decode(S_,G)),"the") ...
%                 && contains(arrayToStr(decode(S_,G)),"and") ...
%                 && contains(arrayToStr(decode(S_,G)),"have") ...
%                 && contains(arrayToStr(decode(S_,G)),"with")
            %arrayToStr(decode(S_,G))
            %pause
        %end
        current = current+1;
    end
end

%figure(1)
plot(BB)
ss = arrayToStr(decode(S_,G))
currentScore = freqAnal(decode(S_,G),1:26)
disp("vs best")

arrayToStr(decode(S_,bestC))
bestS


disp("---")
if strncmp(ss, "with",4)
    %pause
end
pause(.01);
end



function V = slowcoolings(I)
    %V = 1 - .99 * (I ./ length(I));
    V = exp(I ./ length(I) * log(0.01));
end


function V = bumpcooling(I)
    % V = .05 - .04 * (I ./ length(I));
    % ^^ worked for the first sample
     V = .05 - .04 * (I ./ length(I));
    %V = exp(I ./ length(I) * log(0.01));
end