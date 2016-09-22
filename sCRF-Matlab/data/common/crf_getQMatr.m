function QMatr = crf_getQMatr(rFCellMatrList)
T = size(rFCellMatrList,2);
fCellMatr = rFCellMatrList{1,1};
numF = size(fCellMatr{1,1},1);
cardY = size(fCellMatr,1);
QMatr = cell(numF,T);
for t = 1:T
    fCellMatr = rFCellMatrList{1,t};
    for f = 1:numF
        qm = zeros(cardY,cardY);
        for i = 1:cardY
            for j = 1:cardY
                fVector = fCellMatr{i,j};
                feature = fVector(f);
                qm(i,j)=feature;
            end
        end
        QMatr{f,t} = qm;
    end
end