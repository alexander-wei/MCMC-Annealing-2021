
% arguments
% S: encoded ciphertext
% stage: 1 or 2 for a two-stage annealing process
% dict: string of proper english for basis of cipherkey comparisons
function annealingMutations(S, stage, dict)

S_ = strToArray(S);

global properFREQ; global keyScores;
global bestC; global bestS;

properFREQ = digramFreq(dict);

keyScores = zeros(26,1);

% irreducibility criterion
properFREQ(properFREQ < .01) = .01;

% annealing with respect to the
% best pair (<Cipher>, score)

% stage I initialize best cipher tracking
if stage == 1
    G = cypher();
    bestC = G;
    bestS = freqAnal(S_,G);
end

while 1
% hard coded stopping points for demo purpose
if stage == 1 && bestS < 60, return; end

% schedule selection
if stage == 1
    % Stage I Schedule -- transposition shuffle mixing time
    ITS_ = [170, repmat([1],1,200), 500]';
    LAM_ = [1, slowcoolings(1:200), .01]';
elseif stage == 2
    % Stage II reseed:
    G = bestC;
    
    % Stage II Schedule
    ITS_ = [500, 2000]'; %1000 -> 10000
    LAM_ = [bumpcooling(1:500),.01]';
end

BB = zeros(sum(ITS_),1);

current = 1;

% initialize with frequencies-comparison table
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
        [G, L, prevT] = mutatePair(LAM,G, L, prevT);
        
        if L < bestS, bestS = L; bestC = G; freqAnal(S_,G); end

        BB(current) = L;

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

pause(.01);
end
end

function V = slowcoolings(I)
    % exponential decay for a slow cooling
    V = exp(I ./ length(I) * log(0.01));
end


function V = bumpcooling(I)
    % small bumps in the near-deterministic optimization Stage II
    % nudge assignments into place
    V = .05 - .04 * (I ./ length(I));
end