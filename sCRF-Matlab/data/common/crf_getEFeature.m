function eFeature = crf_getEFeature(xList,yList)
T = size(yList,2);
for t = 1:T
    if(t == 1)
        yp=NaN;
    else
        yp = yList{1,t-1};
    end
    yc = yList{1,t};
    fVector = crf_getFeature(yp,yc,cardY,xList,t);
    if(t==1)
        eFeature = fVector;
    else
        eFeature = eFeature+fVector;
    end
end
end
