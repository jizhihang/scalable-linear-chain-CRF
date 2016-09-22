function logLoss = crf_getLogLoss(testFile,lambda)
load(testFile);
numData = size(dataList,2);
logLoss = -crf_getLLD(dataList,lambda)/numData;
