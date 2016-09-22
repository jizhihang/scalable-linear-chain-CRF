function [y1,y2] = getY(xList,pt,Y)
x1 = xList{1,1};
x2 = xList{1,2};
if(strcmp(x1,'1') && strcmp(x2,'1'))
    p = pt(1,:);
elseif(strcmp(x1,'1') && strcmp(x2,'2'))
    p = pt(2,:);
elseif(strcmp(x1,'2') && strcmp(x2,'1'))
    p = pt(3,:);
else
    p = pt(4,:);
end

ys = randsample(1:4,1,true,p);
if(ys == 1)
    y1 = Y{1,1};y2 = Y{1,1};
elseif(ys == 2)
    y1 = Y{1,1};y2 = Y{1,2};
elseif(ys == 3)
    y1 = Y{1,2};y2 = Y{1,1};
else
    y1 = Y{1,2};y2 = Y{1,2};
end

end
