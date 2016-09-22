function logLL = crf_getLLD(dataList,lambda)
numData = size(dataList,2);
logLL = 0;
for n = 1:numData
    data = dataList{1,n};
    eFeature = data.eFeature;
    rFCellMatrList = data.rFCellMatrList;
    cardY = size(rFCellMatrList{1,1},1);
    T = size(rFCellMatrList,2);
    mList = getMList(rFCellMatrList,cardY,T,lambda);
    alphaTList = getAlphaTList(mList,cardY,T); 
    logZ = crf_getLogSum(alphaTList{1,T});
    logLL = logLL+lambda'*eFeature-logZ;
end
end

function mList = getMList(rFCellMatrList,cardY,T,lambda)
% generate M matrices
mList = cell(1,T);
for t = 1:T
    fCellMatr = rFCellMatrList{1,t};
    m = zeros(cardY,cardY);
    for i = 1:cardY
        for j = 1:cardY
            m(i,j)=lambda'*fCellMatr{i,j};
        end
    end
    mList{1,t}=m;
end
end

function alphaTList = getAlphaTList(mList,cardY,T)
% get alpha vector transpose list forward
alphaTList = cell(1,T);
alphaT = zeros(1,cardY);
alphaT(1,1)=1;
m = mList{1,1};
alphaT = alphaT*m;
alphaTList{1,1} = alphaT;
for t = 2:T
    m = mList{1,t};
    alphaT = getAlphaT(alphaT,m);
    %alphaT = alphaT*m;
    alphaTList{1,t} = alphaT;
end
end

function alphaT = getAlphaT(alphaT,m)
cardY = size(m,1);
inm = repmat(alphaT,cardY,1)'+m;
alphaT = zeros(1,cardY);
for j = 1:cardY
    alphaT(1,j) = crf_getLogSum(inm(:,j));
end
end

function logSum = crf_getLogSum(logVector)
maxTerm = max(logVector);
logVector = logVector-maxTerm;
logSum = log(sum(exp(logVector)))+maxTerm;
end
