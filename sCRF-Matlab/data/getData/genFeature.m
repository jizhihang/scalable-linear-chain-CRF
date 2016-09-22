clear;
% load data dataList and range of y's Y
addpath('../common/');
load('synData2000Source');
numData = size(dataList,2);
dataListF = cell(1,numData);
for n = 1:numData
    data = dataList{1,n};
    xList = data.xList;
    yList = data.yList;
    T = size(yList,2);
    eFeature = crf_getEFeature(xList,yList);
    rFCellMatrList = crf_getRFCellMatrList(xList,T,Y);
    QMatr = crf_getQMatr(rFCellMatrList);
    data.eFeature = eFeature;
    data.rFCellMatrList = rFCellMatrList;
    data.QMatr = QMatr;
    dataListF{1,n} = data;
end
dataList = dataListF;
save('synDataF2000Source','dataList');
