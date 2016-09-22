function fCellMatr = crf_getFCellMatr(xList,Y,t)
cardY = size(Y,2);
fCellMatr = cell(cardY,cardY);
for i = 1:cardY
    if(t==1)
        yp = NaN;
    else
        yp = Y{1,i};
    end
    for j = 1:cardY
        yc = Y{1,j};
        fVector = crf_getFeature(yp,yc,cardY,xList,t);
        fCellMatr{i,j} = fVector;
    end
end
end
