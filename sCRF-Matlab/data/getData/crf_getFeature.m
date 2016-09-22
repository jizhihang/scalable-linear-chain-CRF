function fVector = crf_getFeature(yp,yc,xList,t)
xt = xList{1,t};
%f1 = str2double(xt)+str2double(yc);
if(t==1)
    f1 = 0;
else
    f1 = str2double(yp)*str2double(yc);
end
f2 = str2double(yc)*str2double(xt);
fVector = [f1;f2];
end
