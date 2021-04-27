

s = fileread("TalksWith.txt");
s = regexprep(lower(s),"[^a-z]","");

properFREQ = digramFreq(s)