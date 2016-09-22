function logLoss = crf_getRLogLoss(testFile,lambda)
load(testFile);
numData = size(dataList,2);
logLoss = -crf_getRLLD(dataList,lambda)/numData;
