clc;
clear;
close all;
addpath Ocean_Environment PSO Acoustic_communication Lyapunov_optimization Data image;

%% 解决优化问题1
%海洋环境+传感器位置建模
model=CreateModel();%构建模型
[model.w1,model.w2,model.vorbeta,model.V] = deal(0.5,0.5,2e3,1e8);%变量赋值
[result,TSP,greedy]=PSO_path_planning(model);
plot_map(result,model);%构建模型

% hold on;
% linewith = 3;
% plot(TSP.xx_c,TSP.yy_c,'-c+','LineWidth',linewith);

%% 解决优化问题2

% final = Lyapunove_op(result,model);
% data_copy = [model.w1 model.w2 model.vorbeta result.E_T (result.E_P+result.E_C) result.Violation result.EE_A_pre ...
% result.EE_N_pre result.EE_T_pre final.EE_A final.EE_N final.EE_T model.V];
% 
% model.V=1e9;
% final2 = Lyapunove_op(TSP,model);
% TSP_data_copy = [TSP.E_T (TSP.E_P+TSP.E_C) TSP.Violation TSP.EE_A_pre ...
% TSP.EE_N_pre TSP.EE_T_pre final2.EE_A final2.EE_N final2.EE_T model.V];

% %%海洋环境+传感器位置建模
% model=CreateModel();%构建模型
% vorbeta_seq = [0: 4e4: 8e4];
% model.w1=0.5;model.w2=0.5;
% for i=1:length(vorbeta_seq)
%     model.vorbeta = vorbeta_seq(i);
%     result(i)=PSO_path_planning(model);
%     plot_map(result(i),model);%构建模型
% end


% % 
% % 图一
% model=CreateModel();%构建模型
% axis square
% hold on;
% 
% linewith = 3;
% load('MEN-1.mat');
% plot(result.xx_c,result.yy_c,'-rs','LineWidth',linewith);%MEN路径
% load('MTES-1.mat');
% plot(result.xx_c,result.yy_c,'-bo','LineWidth',linewith);%METES路径
% load('MEA-1.mat');
% plot(result.xx_c,result.yy_c,'-g^','LineWidth',linewith);%MEA路径
% % load('TSP.mat');
% % plot(TSP.xx_c,TSP.yy_c,'-c+','LineWidth',linewith);%TSP
% load('Greedy.mat');
% plot(greedy.xx_c,greedy.yy_c,'-mx','LineWidth',linewith);%greedy
% sz =40;
% scatter(model.SN_X,model.SN_Y,sz,'o','MarkerEdgeColor',[0 .5 .5],...
%       'MarkerFaceColor',[0 .7 .7],...
%       'LineWidth',5);
% plot(model.xt,model.yt,'kp','MarkerSize',16,'MarkerFaceColor','y');
% plot(model.xs,model.ys,'bs','MarkerSize',12,'MarkerFaceColor','y');
% grid on
% box on

% %% 图二
% model=CreateModel();%构建模型
% axis square
% hold on;
% 
% linewith = 3;
% load('E:\IEEE_LaTex\IoTJ-AUV-Lyapunov\code\Main\Data\MTES-1.mat');
% plot(result.xx_c,result.yy_c,'-rs','LineWidth',linewith);%METES-1路径
% load('E:\IEEE_LaTex\IoTJ-AUV-Lyapunov\code\Main\Data\MTES-2.mat');
% plot(result.xx_c,result.yy_c,'-b+','LineWidth',linewith);%MTES-2
% load('E:\IEEE_LaTex\IoTJ-AUV-Lyapunov\code\Main\Data\MTES-3.mat');
% plot(result.xx_c,result.yy_c,'-mx','LineWidth',linewith);%MTES-3
% load('E:\IEEE_LaTex\IoTJ-AUV-Lyapunov\code\Main\Data\MTES-4.mat');
% plot(result.xx_c,result.yy_c,'-go','LineWidth',linewith);%MTES-4
% sz =40;
% scatter(model.SN_X,model.SN_Y,sz,'o','MarkerEdgeColor',[0 .5 .5],...
%       'MarkerFaceColor',[0 .7 .7],...
%       'LineWidth',5);
% plot(model.xt,model.yt,'kp','MarkerSize',16,'MarkerFaceColor','y');
% plot(model.xs,model.ys,'bs','MarkerSize',12,'MarkerFaceColor','y');
% grid on
% box on

% %% 图3-4
% 
% 
% % 解决优化问题1
% %海洋环境+传感器位置建模
% model=CreateModel();%构建模型
% [model.w1,model.w2,model.vorbeta,model.V] = deal(0.1,0.9,2e3,1e7);%变量赋值
% datarate_seq = [2];
% % datarate_seq = [1.5];
% % data_copy = zeros(length(datarate_seq),13);
% empty_data_copy.w1=[];
% empty_data_copy.w2=[];
% empty_data_copy.vorbeta=[];
% empty_data_copy.E_T_pre = [];
% empty_data_copy.E_A_pre = [];
% empty_data_copy.Violation = [];
% empty_data_copy.EE_A_pre = [];
% empty_data_copy.EE_N_pre = [];
% empty_data_copy.EE_T_pre = [];
% empty_data_copy.EE_A = [];
% empty_data_copy.EE_N = [];
% empty_data_copy.EE_T = [];
% empty_data_copy.V = [];
% data_copy = repmat(empty_data_copy,length(datarate_seq),1);
% for i=1:length(datarate_seq)
%     %单独修改传输速率设定
%     model.bitrate = datarate_seq(i) * 10 * 1024;
% %     model.cap_max = 0.98 * model.bitrate;
%     [result(i),TSP(i),greedy(i)]=PSO_path_planning(model);
% %     plot_map(result,model);%构建模型
%     final(i) = Lyapunove_op(result(i),model);
%     data_copy(i).w1 =  model.w1;
%     data_copy(i).w2 =  model.w2;
%     data_copy(i).vorbeta= model.vorbeta;
%     data_copy(i).E_T_pre = result(i).E_T;
%     data_copy(i).E_A_pre = (result(i).E_P+result(i).E_C);
%     data_copy(i).Violation = result(i).Violation;
%     data_copy(i).EE_A_pre = result(i).EE_A_pre;
%     data_copy(i).EE_N_pre = result(i).EE_N_pre;
%     data_copy(i).EE_T_pre = result(i).EE_T_pre;
%     data_copy(i).EE_A = final(i).EE_A;
%     data_copy(i).EE_N = final(i).EE_N;
%     data_copy(i).EE_T = final(i).EE_T;
%     data_copy(i).V = model.V;
% end
% 
% for i=1:length(datarate_seq)
% %     TSP_op(i) = Lyapunove_op(TSP(i),model);
%     model.bitrate = datarate_seq(i) * 10 * 1024;
%     Greedy_op(i) = Lyapunove_op(greedy(i),model);
% end

% Plot_fig_EE_bitrate(data,datarate_seq);

% %% EE_N_bitrate
% datarate_seq = [1.9:0.05:2.4];
% data = zeros(8,length(datarate_seq));
% load('Lyapunov_MEA_bitrate.mat');
% [data(1,:),data(2,:)] = Get_data_from_struct(result,final);
% load('Lyapunov_MEN_bitrate.mat');
% [data(3,:),data(4,:)] = Get_data_from_struct(result,final);
% load('Lyapunov_MTSE_bitrate.mat');
% [data(5,:),data(6,:)] = Get_data_from_struct(result,final);
% load('Lyapunov_greedy_bitrate.mat');
% [data(7,:),data(8,:)] = Get_data_from_struct(greedy,Greedy_op);
% Plot_fig_EE_bitrate(data,datarate_seq);
% 
% %% EE_A_bitrate
% datarate_seq = [1.9:0.05:2.4];
% data = zeros(8,length(datarate_seq));
% load('Lyapunov_MEA_bitrate.mat');
% [data(1,:),data(2,:)] = Get_data_EE_A_bitrate(result,final);
% load('Lyapunov_MEN_bitrate.mat');
% [data(3,:),data(4,:)] = Get_data_EE_A_bitrate(result,final);
% load('Lyapunov_MTSE_bitrate.mat');
% [data(5,:),data(6,:)] = Get_data_EE_A_bitrate(result,final);
% load('Lyapunov_greedy_bitrate.mat');
% [data(7,:),data(8,:)] = Get_data_EE_A_bitrate(greedy,Greedy_op);
% Plot_fig_EE_bitrate(data,datarate_seq);


% %% Risky index
% %% 图3-4
% 
% 
% % 解决优化问题1
% %海洋环境+传感器位置建模
% model=CreateModel();%构建模型
% [model.w1,model.w2,model.vorbeta,model.V] = deal(0,1,2e3,1e8);%变量赋值
% % w_seq=[1 0;0.5 0.5;0 1];
% beta_seq = [0:5e2:2.5e3];
% for i=1:length(beta_seq)
%     %单独修改传输速率设定
%     model.vorbeta = beta_seq(i);
%     [result(i),TSP,greedy]=PSO_path_planning(model);
% end
% len = size(result,2);
% temp = zeros(1,len);
% for i=1:len
%     temp(1,i)=result(i).Violation;
% end
% plot(beta_seq,temp,'r-o');
% figure;
% hold on;
% Plot_riskyindex();

% %% L/Q曲线，V=1e8，Bitrate=20kbps
% % MEA
% load('Lyapunov_MEA_V.mat');
% Plot_fig_Q_L(final(3));
% load('Lyapunov_MEN_V.mat');
% Plot_fig_Q_L(final(3));
% load('Lyapunov_MTSE_V.mat');
% Plot_fig_Q_L(final(3));
% load('Lyapunov_greedy_V.mat');
% Plot_fig_Q_L(Greedy_op(3));

%% 不同比特率下，Q值变化
datarate_seq = [1.9:0.05:2.4]*10240;
data = zeros(4,length(datarate_seq));
load('Lyapunov_MEA_bitrate.mat');
data(1,:) = Get_data_Q_bitrate(final);
load('Lyapunov_MEN_bitrate.mat');
data(2,:)  = Get_data_Q_bitrate(final);
load('Lyapunov_MTSE_bitrate.mat');
data(3,:)  = Get_data_Q_bitrate(final);
load('Lyapunov_greedy_bitrate.mat');
data(4,:)  = Get_data_Q_bitrate(Greedy_op);
Plot_fig_Q_bitrate(data,datarate_seq);
%% 不同比特率下，L值变化
datarate_seq = [1.9:0.05:2.4]*10240;
data = zeros(4,length(datarate_seq));
load('Lyapunov_MEA_bitrate.mat');
data(1,:) = Get_data_L_bitrate(final);
load('Lyapunov_MEN_bitrate.mat');
data(2,:)  = Get_data_L_bitrate(final);
load('Lyapunov_MTSE_bitrate.mat');
data(3,:)  = Get_data_L_bitrate(final);
load('Lyapunov_greedy_bitrate.mat');
data(4,:)  = Get_data_L_bitrate(Greedy_op);
Plot_fig_L_bitrate(data,datarate_seq);
sound(sin(2*pi*25*(1:4000)/100));