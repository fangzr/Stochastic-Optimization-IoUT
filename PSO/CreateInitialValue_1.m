function sol1=CreateInitialValue_1(i,model,nPop)

    n=model.n;
    
    xmin=model.xmin;
    xmax=model.xmax;
    
    ymin=model.ymin;
    ymax=model.ymax;

    sol1.x=[xmin:(xmax)/n :xmax];%产生xmin~xmax之间的[1,n]等间距向量
%     sol1.y=unifrnd(ymin,ymax,1,n);%产生ymin~ymax之间的[1,n]随机元素的向量
    norm = (xmax-xmin)/(randi(3)*3.14/2);
    norm3 = (ymax - model.ys)/(nPop/2);
    norm4 = -1 * (model.ys - ymin)/(nPop/2);
%     if(i<(nPop/2))
%         sol1.y=i * norm2 * sin(sol1.x/norm)+model.ys;
%     else
%         sol1.y=-1 * (i-nPop/2) * norm3  * sin(sol1.x/norm)+model.ys;
%     end
if (round(rand(1,1)*1))==1
    if(i<(nPop/2))
        sol1.y=-1 * (i) * norm4  * sin(sol1.x/(norm))+model.ys;
    else
        sol1.y=1 * (i-nPop/2) * norm3  * sin(sol1.x/norm)+model.ys;
    end
else
    sol1.y=randperm(ymax,n);
end

    if ((sol1.y<10) | (sol1.y>400))
        printf("error");
    end
end