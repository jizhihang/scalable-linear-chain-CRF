function rFCellMatrList = crf_getRFCellMatrList(xList,T,Y)
rFCellMatrList = cell(1,T);
for t = 1:T
    fCellMatr = crf_getFCellMatr(xList,Y,t);
    rFCellMatrList{1,t} = fCellMatr;
end
end