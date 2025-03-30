%% 计算具有单位传输功率和单位带宽的信号的标称信噪比gamma
% fc单位是kHz，l是km
function [gamma] = SNR_gamma(x_auv,y_auv,model)
k=1.5;
fc = model.fc;
a_f = (0.11*(fc^2)/(1+fc^2)+44*(fc^2)/(4100+(fc^2))+2.75*10^(-4)*(fc^2)+0.003);%单位dB
a_f_n = db_2_normal(a_f);

%噪声系数
s=0.5;%船只扰动系数
w=0;%假设海风速度1m/s
N_t = db_2_normal(17-30*log10(fc));
N_s = db_2_normal(40+20*(s-0.5)+26*log10(fc)-60*log10(fc+0.03));
N_w = db_2_normal(50+7.5*sqrt(w)+20*log10(fc)-40*log10(fc+0.4));
N_th = db_2_normal(-15+20*log10(fc));
N_sum=N_t + N_s + N_w + N_th;

%信道衰减系数下界
gamma_n = zeros(1,model.SN_num);
gamma = zeros(1,model.SN_num);
for i=1:model.SN_num
	
l_LoS = sqrt((x_auv-model.SN_X(1,i))^2+(y_auv-model.SN_Y(1,i))^2+(model.SN_h-model.AUV_h)^2) * 1e-3;%LoS距离
l_b = sqrt((x_auv-model.SN_X(1,i))^2+(y_auv-model.SN_Y(1,i))^2+(model.SN_h+model.AUV_h)^2)* 1e-3;%海底反射最近距离
l_s = sqrt((x_auv-model.SN_X(1,i))^2+(y_auv-model.SN_Y(1,i))^2+(model.depth-model.SN_h-model.AUV_h)^2)* 1e-3;%海面反射最近距离

%LoS
A_f_n_LoS = (l_LoS^k) * (a_f_n^l_LoS);
%海底反射
A_f_n_b = (l_b^k) * (a_f_n^l_b);
%海面反射
A_f_n_s = (l_s^k) * (a_f_n^l_s);

%考虑多径
gamma_n(i) = 1/(N_sum) * (1/sqrt(A_f_n_LoS) - model.alpha * 1/sqrt(A_f_n_b) - model.beta * 1/sqrt(A_f_n_s))^2;
%不考虑多径
% gamma_n(i) = 1/(N_sum) * (1/sqrt(A_f_n_LoS))^2;
gamma(i) = 10*log10(gamma_n(i))-44.78;

end
