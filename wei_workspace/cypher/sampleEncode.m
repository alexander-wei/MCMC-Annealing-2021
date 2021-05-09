
% generate a random cipher
C = cypher();

s = fileread("sampleCiphertexts/yellowwoodsorrel.txt");
% all lowercase, no special characters
s = regexprep(lower(s),"[^a-z]","");

S = arrayToStr(encode(strToArray(s),C));

% fid = fopen('cipheredSampleText.txt','wt');
% fprintf(fid, S);
% fclose(fid);