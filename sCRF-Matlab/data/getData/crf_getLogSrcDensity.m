function logSrcDensity = crf_getLogSrcDensity(xList)
x1 = xList{1,1};
x2 = xList{1,2};
if(strcmp(x1,'1'))
    pX1 = 0.3;
else
    pX1 = 0.7;
end
if(strcmp(x2,'1'))
    pX2 = 0.3;
else
    pX2 = 0.7;
end
srcDensity = pX1*pX2;
logSrcDensity = log(srcDensity);
end
