function logTrgDensity = crf_getLogTrgDensity(xList)
x1 = xList{1,1};
x2 = xList{1,2};
if(strcmp(x1,'1'))
    pX1 = 0.7;
else
    pX1 = 0.3;
end
if(strcmp(x2,'1'))
    pX2 = 0.7;
else
    pX2 = 0.3;
end
trgDensity = pX1*pX2;
logTrgDensity = log(trgDensity);
end
