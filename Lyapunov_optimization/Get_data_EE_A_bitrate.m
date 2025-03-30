function [pre,op] = Get_data_EE_A_bitrate(result,final)
len = size(result,2);
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
    pre(1,i)=result(i).EE_A_pre;
    op(1,i)=final(i).EE_A;
end