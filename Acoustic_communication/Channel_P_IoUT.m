%给定发射功率P_T，带宽B，SNR_gamma，求信道容量
function [P_tr_sum,P_auv_c] = Channel_P_IoUT(cap,model,SNR_gamma)
B = model.B;
eta = model.eta;
H_A = model.depth-model.AUV_h;
P_tr = zeros(model.SN_num,1);P_c = zeros(model.SN_num,1);
for i=1:model.SN_num
    SNR_gamma_n = db_2_normal(SNR_gamma(1,i));
    P_tr(i,1) = 2 * 3.14 * ((0.67*10^(-18))) * B * H_A /(eta * SNR_gamma_n) * (2^(cap/B)-1);
    P_c(i,1) = model.k * (model.rho * cap / 1)^3 * 1;
end
P_tr_sum = sum(P_tr);
P_auv_c = sum(P_c);