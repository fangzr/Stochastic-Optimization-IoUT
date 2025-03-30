clear
clc
close all
%初始化数据,注意这里的x，y和fig里面的xy是反的
 V_X = 71.*[2.4 5 0.5 1 3 4 2 5]';
 V_Y = 21.*[7.6 3 1 9 3 7 13 12]';
 Delta_V = 4.*[2 2 2 2 2 2 2 2]';
 Gamma_V = 40.*[4 3 4 3 3 3 3 4]';
% M=10;
m = 40;%x坐标上界=m*t
n = 30;%y坐标上界=n*t
t = 10;
% V_X = m .* rand(M,1,'double');
% V_Y = n .* rand(M,1,'double');
% Delta_V = 0.1 .* m .* rand(M,1,'double');
% Gamma_V = 10 .* rand(M,1,'double');

[xx,yy,uu,vv] = Lamb_vortices(V_X,V_Y,Delta_V,Gamma_V,m,n,t);
%绘制短线彩色图（长短相同）
xmin=min(min(min(xx)));xmax=max(max(max(xx)));
ymin=min(min(min(yy)));ymax=max(max(max(yy)));
V2=sqrt(uu.^2+vv.^2);%计算速度


%绘制变量颜色条
N_color=32;
P=V2;%指定变量为V2
%P_max=max(P,[],'all');P_min=min(P,[],'all');
P_max=max(max(max(P)));P_min=min(min(min(P)));

Num = numel(xx);

num_streamline=20;%每条流线上的点数量
V2_max=max(max(max(V2)));
dt=3.0*min([xx(1,2)-xx(1,1),yy(2,1)-yy(1,1)])/V2_max/num_streamline;

for k=1:Num
    startx=xx(k);starty=yy(k);
    sl_i=stream2_RK2(xx,yy,uu,vv,startx,starty,dt,num_streamline); 
    sl_sum{k}=sl_i;
end

mcp=colormap(parula(N_color));
[~,~,P_color] = histcounts(P(:),linspace(P_min,P_max,N_color));
mlw=linspace(0.5,2,N_color);

figure(1)
hold on
xlim([xmin,xmax])
ylim([ymin,ymax])
xlabel('x (m)');
ylabel('y (m)');
xy_ratio = get(gca, 'DataAspectRatio');
xy_ratio = xy_ratio(1:2);
xy_lim = axis;

for k=1:Num
    plot(sl_sum{k}(:,1),sl_sum{k}(:,2),'color',mcp(P_color(k),:),'linewidth',mlw(P_color(k)))
    if size(sl_sum{k},1)<=1
        continue
    end
    %绘制箭头
    arrow_direction=sl_sum{k}(end,:)-sl_sum{k}(end-1,:);
    plot_arrow(xy_lim,xy_ratio,sl_sum{k}(end,:),mcp(P_color(k),:),0.5*mlw(P_color(k)),arrow_direction)
end
hold off
caxis([P_min,P_max])
c = colorbar;
c.Label.String = 'Ocean current velocity (m/s)';



function streamline_i=stream2_RK2(x,y,u,v,startx,starty,dt,N)
streamline_i=zeros(N,2);
streamline_i(1,:)=[startx,starty];
x_old=startx;y_old=starty;
F_u = griddedInterpolant(x',y',u','linear');
F_v = griddedInterpolant(x',y',v','linear');
for k=2:N
    %利用改进欧拉法（或者叫2阶Runge-Kutta,预估校正）
    %interp2太慢，放弃
%     u_K1=interp2(x,y,u,x_old,y_old,'linear')*dt;
%     v_K1=interp2(x,y,v,x_old,y_old,'linear')*dt;
    u_K1 = F_u(x_old,y_old)*dt;
    v_K1 = F_v(x_old,y_old)*dt;
%     u_K2=interp2(x,y,u,x_old+0.5*u_K1,y_old+0.5*v_K1,'linear')*dt;
%     v_K2=interp2(x,y,v,x_old+0.5*u_K1,y_old+0.5*v_K1,'linear')*dt;
    u_K2 = F_u(x_old+0.5*u_K1,y_old+0.5*v_K1)*dt;
    v_K2 = F_v(x_old+0.5*u_K1,y_old+0.5*v_K1)*dt;
    x_new=x_old+0.5*(u_K1+u_K2);
    y_new=y_old+0.5*(v_K1+v_K2);
    %保存
    streamline_i(k,:)=[x_new,y_new];
    x_old=x_new;y_old=y_new;
    if isnan(x_new) || isnan(y_new)
        streamline_i(k+1:end,:)=[];
        break
    end
end
end

function plot_arrow(xy_lim,xy_ratio,xy_arrow,arrow_color,arrow_width,arrow_direction)
%初始化箭头形状（归一化的形状）
arrow_0=[0,0;-1,0.5;-1,-0.5];
%对方向进行归一化
a_dn=arrow_direction(:)./xy_ratio(:);
a_dn=a_dn/sqrt(sum(a_dn.^2));
d=(xy_lim(4)-xy_lim(3)+xy_lim(2)-xy_lim(1))/2;
%箭头对窗口缩放
arrow_1=arrow_0*arrow_width*0.03*d;
%箭头旋转
arrow_2=arrow_1*[a_dn(1),a_dn(2);-a_dn(2),a_dn(1)];
%箭头变形
xy_ratio_n=xy_ratio/sqrt(sum(xy_ratio.^2));%对比例尺归一化
arrow_3=arrow_2.*xy_ratio_n+xy_arrow;
fill(arrow_3(:,1),arrow_3(:,2),arrow_color,'EdgeColor','none');
end