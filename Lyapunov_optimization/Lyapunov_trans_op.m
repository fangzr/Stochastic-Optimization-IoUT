
function Lyapunov_trans_op(result)
global Q_seq;%IoUT node的存储队列
global L_seq;%AUV的存储队列
global f_seq;%AUV的计算资源分配
global cap_seq;%每个节点传输资源分频

%每段长度
L_temp = fix(model.xmax/(model.n+2));
T_div = L_temp/model.V_auv;
%初始化队列初值
Q_seq(:,1) = T_div * model.bitrate;
L_seq(:,1) = T_div * model.bitrate;
w1 = model.w1;V = model.V;eta = model.eta;
B = model.B;
H_A = model.depth-model.AUV_h;%AUV深度

for i=1:result.L_length-1
   gamma = SNR_gamma(result.xx_c(i),result.yy_c(i),model);
   for j=1:model.SN_num   
       SNR_gamma_n = db_2_normal(SNR_gamma(1,i));
       temp1 = 2 * 3.14 * ((0.67*10^(-18))) * B * H_A /(eta * SNR_gamma_n) * result.T_div(1,i);
       alpha1 = w1 * V * temp1;
       alpha2 = (L_seq(j,i)-Q_seq(j,i)) * result.T_div(1,i);
       if alpha2 < 0
           temp2 = B * log2(-1 * alpha2 * B / (alpha1 * log(2)));
           cap_seq(j,i) = max(temp2,0);
       else
           cap_seq(j,i) = 0;
       end
   end
end
end