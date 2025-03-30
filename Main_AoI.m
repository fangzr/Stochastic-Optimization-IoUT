%% 计算信息采集系统AoI

clc;
clear;
close all;
addpath Ocean_Environment PSO Acoustic_communication Lyapunov_optimization Data image;
% %% MEN
% load('Lyapunov_MEN_bitrate.mat');%加载不同比特率的MEA仿真数据
% % AoI仿真参数
% model.T3 = 100;% part III 耗时（s）
% model.W = 450;%M=10, lambda=1/60 part IV耗时（s）
% model.A_max = 680;
% % 仿真
% V_seq = [1e7 3e7 1e8 3e8 1e9 3e9 1e10 3e10 1e11];
% bitrate_num = [1 3 6 10];% a=19kbps 20kbps 22.4kbps
% data = zeros(8,length(V_seq));
% AoI_value = zeros(3,length(V_seq));%行：不同比特率数据；列：不同V
% datarate_seq = [1.9:0.05:2.4];
% 
% for j=1:length(bitrate_num)
%     for i=1:length(V_seq)
%         model.V = V_seq(i);
%         model.bitrate = datarate_seq(bitrate_num(j)) * 10 * 1024;
%         finaltemp(j,i) = Lyapunove_op(result(bitrate_num(j)),model);
%         AoI_value(j,i) = AoI(finaltemp(j,i),model);
%     end
% end
% Plot_fig_AoI_V(AoI_value,V_seq);

% %% MTSE
% load('Lyapunov_MTSE_bitrate.mat');%加载不同比特率的MEA仿真数据
% % AoI仿真参数
% model.T3 = 100;% part III 耗时（s）
% model.W = 450;%M=10, lambda=1/60 part IV耗时（s）
% model.A_max = 680;
% % 仿真
% V_seq = [1e7 3e7 1e8 3e8 1e9 3e9 1e10 3e10 1e11];
% bitrate_num = [1 3 6 10];% a=19kbps 20kbps 22.4kbps
% data = zeros(8,length(V_seq));
% AoI_value = zeros(3,length(V_seq));%行：不同比特率数据；列：不同V
% datarate_seq = [1.9:0.05:2.4];
% 
% for j=1:length(bitrate_num)
%     for i=1:length(V_seq)
%         model.V = V_seq(i);
%         model.bitrate = datarate_seq(bitrate_num(j)) * 10 * 1024;
%         finaltemp(j,i) = Lyapunove_op(result(bitrate_num(j)),model);
%         AoI_value(j,i) = AoI(finaltemp(j,i),model);
%     end
% end
% Plot_fig_AoI_V(AoI_value,V_seq);

% %% MEA
% load('Lyapunov_MEA_bitrate.mat');%加载不同比特率的MEA仿真数据
% % AoI仿真参数
% model.T3 = 100;% part III 耗时（s）
% model.W = 450;%M=10, lambda=1/60 part IV耗时（s）
% model.A_max = 680;
% % 仿真
% V_seq = [1e7 3e7 1e8 3e8 1e9 3e9 1e10 3e10 1e11];
% bitrate_num = [1 3 6 10];% a=19kbps 20kbps 22.4kbps
% data = zeros(8,length(V_seq));
% AoI_value = zeros(3,length(V_seq));%行：不同比特率数据；列：不同V
% datarate_seq = [1.9:0.05:2.4];
% 
% for j=1:length(bitrate_num)
%     for i=1:length(V_seq)
%         model.V = V_seq(i);
%         model.bitrate = datarate_seq(bitrate_num(j)) * 10 * 1024;
%         finaltemp(j,i) = Lyapunove_op(result(bitrate_num(j)),model);
%         AoI_value(j,i) = AoI(finaltemp(j,i),model);
%     end
% end
% Plot_fig_AoI_V(AoI_value,V_seq);

%% TSP
load('Lyapunov_MTSE_bitrate.mat');%加载不同比特率的MEA仿真数据
% AoI仿真参数
model.T3 = 100;% part III 耗时（s）
model.W = 450;%M=10, lambda=1/60 part IV耗时（s）
model.A_max = 680;
% 仿真
V_seq = [1e7 3e7 1e8 3e8 1e9 3e9 1e10 3e10 1e11];
bitrate_num = [1 3 6 10];% a=19kbps 20kbps 22.4kbps
data = zeros(8,length(V_seq));
AoI_value = zeros(3,length(V_seq));%行：不同比特率数据；列：不同V
datarate_seq = [1.9:0.05:2.4];

for j=1:length(bitrate_num)
    for i=1:length(V_seq)
        model.V = V_seq(i);
        model.bitrate = datarate_seq(bitrate_num(j)) * 10 * 1024; 
        finaltemp(j,i) = Lyapunove_op(greedy(bitrate_num(j)),model);
        AoI_value(j,i) = AoI(finaltemp(j,i),model);
    end
end
Plot_fig_AoI_V(AoI_value,V_seq);