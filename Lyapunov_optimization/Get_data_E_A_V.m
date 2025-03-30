function [pre,op] = Get_data_E_A_V(result,final)
len = size(final,2);
pre = zeros(1,len);
op = zeros(1,len);
%%EE_N_bitrate
% for i=1:len
%     result(1,i)=data(i).EE_N;
%     pre(1,i)=data(i).EE_N_pre;
% end

%%risky index
% for i=1:len
%     result(1,i)=data(i).Violation;
%     pre(1,i)=0;
% end

%% EE_A_bitrate

for i=1:len
    pre(1,i)=result.E_P+result.E_C;
    op(1,i)=final(i).E_A_sum_op;
end