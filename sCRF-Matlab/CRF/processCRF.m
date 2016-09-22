clear;
addpath('../common/');
format long;
load('../data/synDataFD2000Source');
% initialize learning parameters;
% stochastic gradient learning method;
numData = size(dataList,2);
numF = size(dataList{1,1}.eFeature,1);
%lambda = zeros(numF,1);
lambda = [1;1];
%lambda = [0.660477576347048;1.193622961262537];
rate = 1e-3;
decay = 1;
regulator = 1/sqrt(numData);
i=0;
while true
    i=i+1;
    %decay = 1/(sqrt(i));
    randIndex = randperm(numData);
    gradient = zeros(numF,1);
    % stochastic gradient method
    for n = 1:numData
        index = randIndex(n);
        data = dataList{1,index};
        eFeature = data.eFeature;
        rFeature = crf_getRFeature(data,lambda);
        diffEF = eFeature-rFeature;
        %stochastic descend method
        %lambda = lambda+rate*decay*diffEF;
        gradient = gradient + diffEF;     
    end
    display(i);
%     %get log likelihood
%     logLikelihoodOld = crf_getLogLikelihoodold(dataList,lambda);
%     display(logLikelihoodOld);
%     % batch descend method
    lambda = lambda+rate*decay*gradient;
    
    display(lambda);
    display(gradient);
    % avgError = mean(abs(gradient));
    % display(avgError);
    %save('synResultCRF','lambda','gradient');
end
