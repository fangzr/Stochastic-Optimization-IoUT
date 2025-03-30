clc;
clear all;
close all;

%测试gamma函数
l=1;
fc=[0:1:99];%单位是kHz
gamma = [0:1:99];
temp = [0:1:99];
% for i=1:1:100
%     gamma(i) = SNR_gamma(l,fc(i));
% end
% figure
% ylabel('SNR/dB','Fontsize',18);
% xlabel('frequency/kHz','Fontsize',18);
% grid on;
% hold on;
% plot(fc,gamma);
