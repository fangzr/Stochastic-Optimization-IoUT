function [xx,yy] = SlotDataChange(model,xx,yy)
% j=1;i=1;
% while (j<(length(xx)) && (i<model.n+2))
%     temp = fix(model.xmax/(model.n+2));
%    if L_div(i)> 2 * temp
%        N = fix(L_div(i)/temp)-1;%需要填充的点个数
%        Xt = linspace(xx(j),xx(j+1),N+2);
%        Yt = interp1([xx(j) xx(j+1)],[yy(j) yy(j+1)],Xt);
%        xx = [xx(1:j) Xt(2:end-1) xx(j+1:end)];
%        yy = [yy(1:j) Yt(2:end-1) yy(j+1:end)];       
%        if sqrt((xx(j)-xx(j+1))^2+(yy(j)-yy(j+1))^2)>15
%            tt=1;
%        end
%        i = i+1;
%        j = j + N +1;
%    else 
%        j = j+1;
%        i = i + 1;
%    end
% end

x_temp = [model.xs:0.1:model.xt];%分辨率0.25
y_temp = interp1(xx,yy,x_temp);
L_temp = zeros(1,length(x_temp)-1);
%计算分段长度
for i=1:length(x_temp)-1
    L_temp(i) = sqrt((x_temp(i)-x_temp(i+1))^2+(y_temp(i)-y_temp(i+1))^2); 
end
%分别找到每段的端点
L_temp_div = 0;
xx_out = [];
yy_out = [];
cnt=1;
for i=1:length(x_temp)-1
    L_temp_div = L_temp(i)+ L_temp_div;
    if L_temp_div >10
        xx_out(cnt)=x_temp(i);
        yy_out(cnt)=y_temp(i);
        cnt = cnt +1;
        L_temp_div=0;
    end
end
xx = [model.xs xx_out model.xt];
yy = [model.ys yy_out model.yt];

