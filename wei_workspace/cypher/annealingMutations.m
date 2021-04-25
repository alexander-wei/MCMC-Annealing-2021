

% first generate sample S and starting guess G

% G = 1:26;

S_ = strToArray(S);

% annealing schedule Z

ITS_ = [5000]';
LAM_ = [.1]';

BB = zeros(sum(ITS_),1);

current = 1;

for i = 1:length(ITS_)
    ITS = ITS_(i);
    LAM = LAM_(i);
    for j = 1:ITS
        [G, L] = mutatePair(LAM,G,S_);
        % arrayToStr(decode(S_,G))
        BB(current) = 1-L;
    
        current = current+1;
    end
end

figure(1)
plot(BB)

arrayToStr(decode(S_,G))
