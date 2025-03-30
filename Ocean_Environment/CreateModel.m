%%海洋环境+传感器位置建模

function model=CreateModel(sl_sum)


sl_sum = cell(1,1200);
%初始化数据,注意这里的x，y和fig里面的xy是反的
V_X = 71.*[2.4 5 0.5 1 3 4 2 5]';
V_Y = 21.*[7.6 3 1 9 3 7 13 12]';
Delta_V = 4.*[2 2 2 2 2 2 2 2]';
Gamma_V = 40.*[4 3 4 3 3 3 3 4]';
%传感器位置
SN_X = [50:50:250];
SN_Y = 360*ones(1,length(SN_X));

% M=10;
m = 40;%x坐标上界=m*t
n = 30;%y坐标上界=n*t
t = 10;

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

for k_out=1:Num
    startx=xx(k_out);starty=yy(k_out);
    sl_i=stream2_RK2(xx,yy,uu,vv,startx,starty,dt,num_streamline); 
    sl_sum{k_out}=sl_i;
end

mcp=colormap(parula(N_color));
[~,~,P_color] = histcounts(P(:),linspace(P_min,P_max,N_color));
mlw=linspace(0.5,2,N_color);

figure
hold on
xlim([xmin,xmax])
ylim([ymin,ymax])
xlabel('x (m)');
ylabel('y (m)');
xy_ratio = get(gca, 'DataAspectRatio');
xy_ratio = xy_ratio(1:2);
xy_lim = axis;

for k_out=1:Num
    plot(sl_sum{k_out}(:,1),sl_sum{k_out}(:,2),'color',mcp(P_color(k_out),:),'linewidth',mlw(P_color(k_out)))
    if size(sl_sum{k_out},1)<=1
        continue
    end
    %绘制箭头
    arrow_direction=sl_sum{k_out}(end,:)-sl_sum{k_out}(end-1,:);
    plot_arrow(xy_lim,xy_ratio,sl_sum{k_out}(end,:),mcp(P_color(k_out),:),0.5*mlw(P_color(k_out)),arrow_direction)
end
hold off
caxis([P_min,P_max])
c = colorbar;
c.Label.String = 'Ocean current velocity (m/s)';






%出发点
model.xs = 10;model.ys = 175;
%目的地
model.xt = 300;model.yt = 175;
%湍流涡旋坐标、半径、强度
model.xvor = V_X;
model.yvor = V_Y;
model.rvor = Delta_V;%半径
model.svor = Gamma_V;%强度
%湍流场速度矢量
model.currentx = uu;
model.currenty = vv;
model.curx = xx;
model.cury = yy;
%SN坐标
model.SN_X = SN_X;
model.SN_Y = SN_Y;
%SN个数
model.SN_num = length(SN_X);

model.SN_rate = 1;%1 s^-1 传感器采样速率
model.SN_L = 1024;
model.SN_h = 10; %传感器高度
model.AUV_h = 20;%AUV高度

%粒子维度
%环境区域参数
model.xmin=xmin;
model.xmax=n * t;
model.ymin=ymin;
model.ymax=m * t;
model.pdem = 5;%粒子维度
model.n = 28;%横轴分段
model.m = 40;%纵轴分段
%通信参数
model.fc = 30;%换能器25kHz
model.B = 1e3;%1KHz带宽
model.eta = 0.2;%声电转换效率
%AUV绝对速度
model.V_auv = 5 * 1.852E3 / 3600;%5节
%AUV运动相关参数
model.Cd = 0.117;%阻力系数
model.A = 0.0314;%运动方向投影面积
model.rho = 1020;%海水密度1020kg/m3
model.eff = 0.8;%电力转马达效率
model.depth = 100;%水深
%AUV计算性能参数
model.k = 1e-28;% effective switched capability
model.rho = 1e3;% process density
%传感器节点传输速率
model.bitrate = 20 * 1024;
%nlos传输参数
model.alpha = 0;
% model.beta = 0.97;
model.beta = 0;
%目标函数权重系数
model.w1 = 0.9;%节点能耗
model.w2 = 0.1;%AUV能耗
model.vorbeta =6e4;%避免旋涡系数，对照是4e4
%判断是不是特殊路径
%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
model.iter = 0;
model.nPop = 500;%粒子数
% model.nPop = 1;%粒子数
%Lyapunov优化的系数
model.V = 1e7;
%最大传输速率
model.cap_max = 1.2 * model.bitrate;
%最小传输速率
model.cap_min = 0.9 * model.bitrate;
%最大计算资源分配
model.fa_max = 1024 * 1024 * 1024;
%不同方法的参数
model.X_in = [1 0 1e3;
              1 0 1e2;
              1 0 5e2;
              0.5 0.5 1e2;
              0.5 0.5 5e2;
              0.5 0.5 1e3;
              0 1 1e2;
              0 1 5e2;
              0 1 1e3];
end