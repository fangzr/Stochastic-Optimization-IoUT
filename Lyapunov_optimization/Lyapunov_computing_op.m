%最优计算资源优化解决
function Lyapunov_computing_op(result)
global L_seq;%AUV的存储队列
global f_seq;%AUV的计算资源分配


w2 = model.w2;V = model.V;k = model.k;rho = model.rho;

temp1 = V * w2 * k *rho;
for i=1:result.L_length-1
     for j=1:model.SN_num   
        temp2 = L_seq(j,i);
        f_seq(j,i) = sqrt(temp1/(3 * temp2));
     end
end
