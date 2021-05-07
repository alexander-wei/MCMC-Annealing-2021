

C = cypher();

%s = fileread("sampletext.txt");
s = fileread("sampleCiphertexts/yellowwoodsorrel.txt");
s = regexprep(lower(s),"[^a-z]","");
%encode(s,C)
S = arrayToStr(encode(strToArray(s),C));

fid = fopen('cipheredSampleText.txt','wt');
fprintf(fid, S);
fclose(fid);