function rFeature = crf_getRFeature(data,lambda)
rFCellMatrList = data.rFCellMatrList;
QMatr = data.QMatr;

cardY = size(QMatr,2);
T = size(QMatr,1);
numF = size(QMatr{1,1,1},1);

%cardY = size(rFCellMatrList{1,1},1);
%numF = size(QMatr,1);
%T = size(QMatr,2);

mList = getMList(rFCellMatrList,cardY,T,lambda);
alphaTList = getAlphaTList(mList,cardY,T);
betaList = getBetaList(mList,cardY,T);
logZ = crf_getLogSum(alphaTList{1,T});


rFeature = sparse(numF,1);
for t = 1:T
    m = mList{1,t};
    beta = betaList{1,t};
    %qm = QMatr(t,:,:);
    if(t==1)
        alphaT = alphaTList{1,1};
        inv = exp(alphaT'+beta-logZ);
        for c = 1:cardY
            rFeature = rFeature + inv(c)*QMatr{1,1,c};
        end
    else
        
         alphaT = alphaTList{1,t-1};
         inm = repmat(alphaT,cardY,1)'+m+repmat(beta,1,cardY)';
         inm = exp(inm-logZ);
         %qm = QMatr(t,:,:);
         for ci = 1:cardY
             for cj = 1:cardY
                 rFeature = rFeature+inm(ci,cj)*QMatr{t,ci,cj};
             end
         end
    end
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

function betaList = getBetaList(mList,cardY,T)
% get beta vector list backward
betaList = cell(1,T);
beta = zeros(cardY,1);
betaList{1,T} = beta;
for t = T-1:-1:1
%     m = mList{1,t+1};
%     beta = m*beta;
%     betaList{1,t}=beta;
    m = mList{1,t+1};
    beta = getBeta(beta,m);
    betaList{1,t}=beta;
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

function beta = getBeta(beta,m)
cardY = size(m,1);
inm = repmat(beta,1,cardY)'+m;
beta = zeros(cardY,1);
for i = 1:cardY
    beta(i,1) = crf_getLogSum(inm(i,:)');
end
end

function logSum = crf_getLogSum(logVector)
maxTerm = max(logVector);
logVector = logVector-maxTerm;
logSum = log(sum(exp(logVector)))+maxTerm;
end
