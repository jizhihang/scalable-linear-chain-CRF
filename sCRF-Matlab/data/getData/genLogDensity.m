clear;
load('synDataF2000Source');
numData = size(dataList,2);
dataListFD = cell(1,numData);
for n=1:numData
    data = dataList{1,n};
    xList = data.xList;
    logSrcDensity = crf_getLogSrcDensity(xList);
    logTrgDensity = crf_getLogTarDensity(xList);
    data.logSrcDensity = logSrcDensity;
    data.logTrgDensity = logTrgDensity;
    dataListFD{1,n} = data;
end
dataList = dataListFD;
save('synDataFD2000Source','dataList');
