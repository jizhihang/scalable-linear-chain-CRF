function logSum = crf_getLogSum(logVector)
maxTerm = max(logVector);
logVector = logVector-maxTerm;
logSum = log(sum(exp(logVector)))+maxTerm;
end