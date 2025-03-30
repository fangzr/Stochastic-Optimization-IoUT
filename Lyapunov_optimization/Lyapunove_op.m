%Lyapunov 优化的主函数
function result = Lyapunove_op(pre_data,model)
L_length = length(pre_data.xx_c);%求路径分段数
xx_c = pre_data.xx_c;
yy_c = pre_data.yy_c;

global Q_seq;%IoUT node的存储队列
global L_seq;%AUV的存储队列
global f_seq;%AUV的计算资源分配
global cap_seq;%每个节点传输资源分频

Q_seq = zeros(model.SN_num,L_length);%节点队列
L_seq = zeros(model.SN_num,L_length);%AUV队列
f_seq = zeros(model.SN_num,L_length);%AUV计算分频
cap_seq = zeros(model.SN_num,L_length);%信道容量序列
g_seq = zeros(model.SN_num,L_length);%计算处理队列
b_seq = zeros(model.SN_num,L_length);%发送数据队列
E_T_seq = zeros(model.SN_num,L_length);%IoUT Node传输能耗
E_C_seq = zeros(model.SN_num,L_length);%AUV计算能耗
EE_N = zeros(model.SN_num,L_length);
dx_c=diff(xx_c);
dy_c=diff(yy_c);
L_div_c = sqrt(dx_c.^2+dy_c.^2);
%每段路径的速度方向
V_auv_d = [dx_c;dy_c]./L_div_c;V_auv_d = V_auv_d';
V_auv = model.V_auv.*V_auv_d; 
%每段路程时间，路径段数为model.n-1
T_div = L_div_c / model.V_auv;



%% 优化问题
%初始化队列初值
Q_seq(:,1) = T_div(1) * model.bitrate;
L_seq(:,1) = T_div(1) * model.bitrate;
w1 = pre_data.w(1);
w2 = pre_data.w(2);
V = model.V;
eta = model.eta;
B = model.B;
k = model.k;
rho = model.rho;
H_A = model.depth-model.AUV_h;%AUV深度

temp1 = V * w2 * k *rho;

for i=1:L_length-1
   gamma = SNR_gamma(xx_c(i),yy_c(i),model);
   for j=1:model.SN_num   
       %优化传输功率
       SNR_gamma_n = db_2_normal(gamma(1,j));
       temp1 = 2 * 3.14 * ((0.67*10^(-18))) * B * H_A /(eta * SNR_gamma_n) * T_div(1,i);
       alpha1 = w1 * V * temp1;
       alpha2 = (L_seq(j,i)-Q_seq(j,i)) * T_div(1,i);
       if w1>0
%            cap_seq(j,i)=min(B*log2(max(-1 * alpha2 * B / (alpha1*log(2)),1)),model.cap_max);
             cap_seq(j,i)=max(min(B*log2(max(-1 * alpha2 * B / (alpha1*log(2)),1)),model.cap_max),model.cap_min);
       else 
           cap_seq(j,i)=model.cap_max;
       end
       %优化计算资源
       temp1 = L_seq(j,i);
       temp2 = rho * V * w2 * model.k;
       if w2>0
           f_seq(j,i) = min(sqrt(temp1/(3 * temp2)),model.fa_max);
       else
           f_seq(j,i) = model.fa_max;
       end
       g_seq(j,i) = f_seq(j,i) * T_div(1,i) /rho; 
       b_seq(j,i) = cap_seq(j,i) * T_div(1,i);
       %队列更新
       Q_seq(j,i+1) = max(Q_seq(j,i)-cap_seq(j,i)*T_div(1,i),0)+model.bitrate*T_div(1,i);%单个节点内存储更新
       L_seq(j,i+1)  = max(L_seq(j,i)- g_seq(j,i),0) + b_seq(j,i);
       %通信+计算能耗
       E_T_seq(j,i) = 2 * 3.14 * ((0.67*10^(-18))) * B * H_A /(eta * SNR_gamma_n) * (2^(cap_seq(j,i)/B)-1) * T_div(1,i);
       E_C_seq(j,i) = model.k * (f_seq(j,i))^3 * T_div(1,i);
      
   end   
end

%% 能量效率bit/J
%只考虑节点的能量效率
E_T_sum_op = sum(sum(E_T_seq));
EE_N = sum(sum(b_seq))/E_T_sum_op;
%只考虑AUV的能量效率
E_A_sum_op = sum(sum(E_C_seq));
EE_A = sum(sum(b_seq))/(pre_data.E_P + E_A_sum_op);
%考虑总的能量效率
EE_T = sum(sum(b_seq))/(E_A_sum_op + E_T_sum_op + pre_data.E_P);

%% 网络拥塞程度
Q_sum = mean(mean(Q_seq));
L_sum = mean(mean(L_seq));
L_T_sum = Q_sum+L_sum;

result.Q_seq = Q_seq;
result.L_seq = L_seq;
result.f_seq = f_seq;
result.b_seq = b_seq;
result.dx_c = dx_c;
result.dy_c = dy_c;
result.L_div_c=L_div_c;
result.V_auv_d = V_auv_d;
result.V_auv =V_auv ;
result.T_div = T_div;
result.L_length = L_length;
result.E_T_sum_op = E_T_sum_op;
result.E_A_sum_op = pre_data.E_P + E_A_sum_op;
result.EE_N = EE_N;
result.EE_A = EE_A;
result.EE_T = EE_T;
result.Q_sum = Q_sum;
result.L_sum = L_sum;
result.L_T_sum = L_T_sum;

% Plot_fig_Q_L(result);%绘制LQ vs time slot曲线



end