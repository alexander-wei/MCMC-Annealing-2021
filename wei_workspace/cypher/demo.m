
% demo
clear;
sampleEncode();
% first generate sample S and starting guess G
disp("Ciphertext:");
disp(S);
disp(newline + "Press any key to continue...");
pause;

% Dictionary
s = fileread("TreatiseHumanNature.txt"); % works for sorrel text
s = regexprep(lower(s),"[^a-z]","");

annealingMutations(S,1, s)
disp("Stage I completed.");
disp(newline + "Press any key to continue...");
pause
annealingMutations(S,2, s)