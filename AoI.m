%% 计算信息采集AoI
function AoI_value = AoI(final_data,model)

% N_total =
% sum(sum(final_data.b_seq(:,2:end)));%由于可能算出来的传输速率太大，以至于队列没这么多数据上传，因此应该使用a(t)计算

N=size(final_data.b_seq,1);%行，不同节点
M=size(final_data.T_div,2);%列，时隙
T_k = size(final_data.T_div,2);%总时隙数
T_sum = sum(final_data.T_div);%总运动耗时
a_sum = 0;
temp_Aki = 0;
for i=1:N
    for j=1:M
        %判断是否数据能够上传H-AUV，不被丢弃
        temp_sum_bki = 0;
        if (j)<= T_k
            for k=(j):T_k
                temp_sum_bki = temp_sum_bki + final_data.b_seq(i,k);%累加从时隙j开始到最终时刻的H-AUV搜集到的数据量
            end
        end
        if (temp_sum_bki > final_data.Q_seq(i,j))   
            AoI_1 = sum(final_data.T_div(j+1:end));
            temp = model.T3 + model.W + AoI_1;
            A_ki(i,j) = min(temp,model.A_max);
            a_sum = a_sum + model.bitrate * final_data.T_div(j);
        else
            A_ki(i,j) = 0;
        end
        temp_Aki = temp_Aki + model.bitrate * final_data.T_div(j) * A_ki(i,j);
    end
end

% AoI_value = temp_Aki / N_total;
AoI_value = temp_Aki / a_sum;



