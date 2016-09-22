clear;
addpath('../common/');
format long;
trainFile = '../data/NLPSmallTrainFD';
testFile = '../data/NLPSmallTargetAFD';
resultFile = 'smallResultCRF.mat';
load(trainFile);
% initialize learning parameters;
% dataList = dataList(1:2);
numData = size(dataList,2);
numF = size(dataList{1,1}.eFeature,1);
if exist(resultFile,'file')
    load(resultFile);
    bestLambda = lambda;
    bestGradient = gradient;
    minAvgError = avgError;
else
    preAvgError = 1e20;
    minAvgError = 1e20;
    lambda = zeros(numF,1);
    %lambda = sparse(numF,1);
    %GM = sparse(numF,1);
    rate = 1e-2;
    decay = 1;
    regulator = 1/sqrt(numData);
    i = 0;
end

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
        %rFeature = crf_getRFeature_cpp(data.QMatr, data.rFCellMatrList, lambda);
        diffEF = eFeature-rFeature;
        %GM = GM + diffEF.^2;
        % stochastic descend method
%         if(i<=100)
             %lambda = lambda+rate*decay*GM.^(-1/2).*diffEF;
             lambda = lambda+rate*decay*diffEF;
%         end
        gradient = gradient + diffEF;     
    end
 %   GM = GM + gradient.^2;
    avgLambda = mean(abs(lambda));
    avgError = mean(abs(gradient));
%     if(avgError < minAvgError)
%         bestLambda = lambda;
%         bestGradient = gradient;
%         minAvgError = avgError;      
%     end
    if(mod(i,20)==1)
%         if(avgError>minAvgError)
%             rate = rate*0.9;
%             lambda = bestLambda;
%             gradient = bestGradient;
%             avgError = minAvgError;
%         end
        logLikelihood = crf_getLLD(dataList,lambda);
        testLogLoss = crf_getLogLoss(testFile,lambda);
        display(logLikelihood);
        display(testLogLoss);
        save('NLPResultCRF','i','rate','decay','lambda','gradient','avgError','regulator');
    end
    display(['Run:' num2str(i) ' avgLambda:' num2str(avgLambda,10)...
        ' avgError:' num2str(avgError,10)]);
       % ' avgGM:' num2str(mean(abs(GM)),10)]);
%   % batch descend method
    %if(i>100)
        %lambda = lambda+rate*decay*GM.^(-1/2).*gradient-regulator;
%        lambda = lambda+rate*decay*gradient-regulator;
    %end
end
