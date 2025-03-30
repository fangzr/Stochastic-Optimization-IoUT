
function sol2=ParseSolution(sol1,model)
%全局变量记录迭代值
global iteration_num;
 %起点、终点、障碍物坐标
    xs=model.xs;
    ys=model.ys;
    xt=model.xt;
    yt=model.yt;
    xvor=model.xvor;
    yvor=model.yvor;
    rvor=model.rvor;
 %soll是第i个粒子坐标
    x=[xs:(model.xmax/(model.pdem+2)):xt];x(1,end)=xt;
    temp_get = ceil(model.n/model.pdem);
    temp_n = 1:temp_get:length(sol1.y);
    y=sol1.y(1,temp_n);

    %粒子的轨迹
    XS=[xs:(model.xmax/(model.pdem+2)):xt];XS(1,end)=xt;
    YS=[ys y yt];
    %正弦插值
    if (iteration_num< (model.nPop+1))
        k=numel(XS);%计算出XS矩阵的元素总数
        TS=linspace(0,1,k);%0-1之中k点行矢量

    %% 求粒子轨迹长度
        tt=linspace(0,1,model.n+2);
        xx=spline(TS,XS,tt);%非均匀分布的样本点对正弦曲线插值,TS、XS向量点，tt是范围
        yy=spline(TS,YS,tt);
    else
        xx =[xs sol1.x xt];yy = [ys sol1.y yt];
    end
    dx=diff(xx);
    dy=diff(yy);
    %每段路径的长度
    L_div = sqrt(dx.^2+dy.^2);
    L = sum(L_div);%计算总路径距离
    %根据距离插值，每个slot一个坐标
    [xx_change,yy_change] = SlotDataChange(model,xx,yy);
    n_c = length(xx_change);
    dx_c=diff(xx_change);
    dy_c=diff(yy_change);
    L_div_c = sqrt(dx_c.^2+dy_c.^2);
    L_c = sum(L_div_c);
    
%% 求AUV的运动能耗
%每段路径的速度方向
    V_auv_d = [dx_c;dy_c]./L_div_c;V_auv_d = V_auv_d';
    V_auv = model.V_auv.*V_auv_d; 
    %假设AUV绝对速度恒定，则相对速度计算可得：
    V_auv_re = zeros(n_c-1,2);V_auv_R = zeros(n_c-1,1);
    for i = 1:n_c-1
        tempxx = ceil(xx_change./10);tempxx(find(tempxx<1))=1;tempxx(find(tempxx>model.m))=model.m;
        tempyy = ceil(yy_change./10);tempyy(find(tempyy<1))=1;tempyy(find(tempyy>model.n))=model.n;
        temp_x = V_auv(i,1) - model.currentx(tempxx(i),tempyy(i));
        temp_y = V_auv(i,2) - model.currenty(tempxx(i),tempyy(i));
        V_auv_re(i,:) = [temp_x temp_y];
        V_auv_R(i,1) = sqrt(V_auv_re(i,1)^2 + V_auv_re(i,2)^2);
    end
    %每段路程时间，路径段数为model.n-1
   T_consum = L_div_c ./ model.V_auv;
   %阻力计算
   F_d = 0.5 * model.rho * model.Cd * model.A .* (V_auv_R).^2;
   %推进功率计算，单位是焦耳
   E_auv_f = 1/model.eff * (F_d' .* T_consum);
   E_auv_f_sum = sum(E_auv_f);
    
%% 求SN和AUV之间通信耗能+AUV计算能耗
P_node_tr = zeros(n_c-1,1);
P_auv_c = zeros(n_c-1,1);
    for i = 1:n_c-1
        gamma = SNR_gamma(xx_change(i),yy_change(i),model);
        [P_node_tr(i,1),P_auv_c(i,1)] = Channel_P_IoUT(model.bitrate,model,gamma);
    end
E_node_tr = P_node_tr' .* T_consum;
E_node_tr_sum = (sum(E_node_tr));

E_auv_c = P_auv_c' .* T_consum;
E_auv_c_sum = (sum(E_auv_c));


%% 求AUV和旋涡的距离造成的路径惩罚
nobs = numel(model.xvor); % Number of vortex
Violation = 0;
for k=1:nobs
   d = sqrt((xx_change-model.xvor(k)).^2+(yy_change-model.yvor(k)).^2); 
   v = max(1-d./(10*model.rvor(k)),0);
   Violation=Violation+mean(v);%用来判断距离旋涡多远，轨迹在障碍中就是违背了规则
end

sol2.xx=xx;
sol2.yy=yy;
sol2.xx_c=xx_change;
sol2.yy_c=yy_change;
sol2.XS=XS;
sol2.YS=YS;
sol2.V_auv = V_auv_d;

% Violation=0
% 
% sol2.energy_sum = L;
% sol2.Violation = Violation;
% sol2.IsFeasible=(Violation==0);%是否撞到障碍

sol2.energy_sum = model.w1 * E_node_tr_sum + model.w2 * (E_auv_f_sum + E_auv_c_sum);
sol2.Violation = Violation;
sol2.IsFeasible=(Violation==0);%是否撞到障碍

sol2.L = L;%总的航迹长度
sol2.E_T = E_node_tr_sum;%总的节点通信能耗
sol2.E_P = E_auv_f_sum;%总的AUV运动能耗
sol2.E_C = E_auv_c_sum;%总的AUV计算能耗
sol2.EE_N_pre = model.SN_num * model.bitrate * sum(T_consum) / E_node_tr_sum;%原轨迹的节点能量效率
sol2.EE_A_pre = model.SN_num * model.bitrate * sum(T_consum) / (E_auv_f_sum+E_auv_c_sum);%原轨迹的AUV能量效率
sol2.EE_T_pre = model.SN_num * model.bitrate * sum(T_consum) / (E_node_tr_sum + E_auv_f_sum+E_auv_c_sum);%总能量效率
sol2.pso_dem = model.pdem;%粒子维度
sol2.w = [model.w1 model.w2];
sol2.vorbeta = model.vorbeta;
sol2.T_consum = T_consum;   
sol2.L_div_c =  L_div_c;   
sol2.test = E_node_tr;
end
