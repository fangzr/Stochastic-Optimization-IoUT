function sol1=CreateRandomSolution(model)

    n=model.n;
    
    xmin=model.xmin;
    xmax=model.xmax;
    
    ymin=model.ymin;
    ymax=model.ymax;

    sol1.x=[xmin:(xmax)/n :xmax];%产生xmin~xmax之间的[1,n]等间距向量
%   sol1.y=unifrnd(ymin,ymax,1,n);%产生ymin~ymax之间的[1,n]随机元素的向量
    sol1.y=randperm(ymax,n);
    
end