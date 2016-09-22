clear;

X = {'1','2'};
Y = {'0.5','1'};
lam1 = 1;
lam2 = 1;

pt = zeros(4,4);

for i = 1:2
    x1 = str2double(X(1,i));
    for j = 1:2
        x2 = str2double(X(1,j));
        for k = 1:2
            y1 = str2double(Y(1,k));
            for l = 1:2
                y2 = str2double(Y(1,l));
                pt((i-1)*2+j,(k-1)*2+l) = exp(lam2*(x1*y1)+lam1*(y1*y2)+lam2*(x2*y2));
            end
        end
    end
end

Z = sum(pt,2);

pt = [pt(1,:)/Z(1);pt(2,:)/Z(2);pt(3,:)/Z(3);pt(4,:)/Z(4)];

numSourceData = 2000;
dataList = cell(1,numSourceData);
for n = 1:numSourceData
    % for source data
    x1 = randsample({'1','2'},1,true,[0.3 0.7]);
    x2 = randsample({'1','2'},1,true,[0.3 0.7]);
    %display([x1 x2]);
    xList = {x1{1,1},x2{1,1}};
    [y1,y2] = getY(xList,pt,Y);
    yList = {y1,y2};
    data.xList = xList;
    data.yList = yList;
    dataList{1,n} = data;
end

save('synData2000Source','dataList','Y');

% numTargetData = 200;
% dataList = cell(1,numTargetData);
% for n = 1:numTargetData
%     % for target data
%     x1 = randsample({'1','2'},1,true,[0.7 0.3]);
%     x2 = randsample({'1','2'},1,true,[0.7 0.3]);
%     %display([x1 x2]);
%     xList = {x1{1,1},x2{1,1}};
%     [y1,y2] = getY(xList,pt,Y);
%     yList = {y1,y2};
%     data.xList = xList;
%     data.yList = yList;
%     dataList{1,n} = data;
% end
% 
% save('synData200Target','dataList','Y');






