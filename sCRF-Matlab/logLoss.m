clear;
addpath('common/');
format long;
load('data/synDataFD2000Target');
numData = size(dataList,2);
lambdaCRF = [0.357068277277497;1.494529241071135];
logLossCRF = -crf_getLLD(dataList,lambdaCRF)/numData;
display(logLossCRF);