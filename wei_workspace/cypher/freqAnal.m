

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

% how much more likely is C than D
function l = freqAnal(s,C,D)

    FREQ = zeros(26,1);
    FREQ([5,6,20,23,25]) = [12000, 2500, 9000, 2000, 2000];
    FREQ([1,9,14,15,19]) = [8000,8000,8000,8000,8000];
    FREQ([7,16]) = [1700, 1700];
    FREQ([8,2,18,22,4,11]) = ...
        [6400, 1600, 6200, 1200, 4400, 800];
    FREQ([12,17,21,10,24,3,13,26]) = ...
        [4000, 500, 3400, 400, 400, 3000, 3000, 200];

    FREQ = FREQ ./ sum(FREQ);
    %l = FREQ
    
    sC = decode(s,C); sD = decode(s,D);
    
    ratio = 1;
    
    for i = 1:length(s)
        ratio = ratio + FREQ(sC(i)) - FREQ(sD(i));
    end
        
    l = ratio;
end



