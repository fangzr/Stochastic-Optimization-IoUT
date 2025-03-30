function plot_arrow(xy_lim,xy_ratio,xy_arrow,arrow_color,arrow_width,arrow_direction)
%初始化箭头形状（归一化的形状）
arrow_0=[0,0;-1,0.5;-1,-0.5];
%对方向进行归一化
a_dn=arrow_direction(:)./xy_ratio(:);
a_dn=a_dn/sqrt(sum(a_dn.^2));
d=(xy_lim(4)-xy_lim(3)+xy_lim(2)-xy_lim(1))/2;
%箭头对窗口缩放
arrow_1=arrow_0*arrow_width*0.03*d;
%箭头旋转
arrow_2=arrow_1*[a_dn(1),a_dn(2);-a_dn(2),a_dn(1)];
%箭头变形
xy_ratio_n=xy_ratio/sqrt(sum(xy_ratio.^2));%对比例尺归一化
arrow_3=arrow_2.*xy_ratio_n+xy_arrow;
fill(arrow_3(:,1),arrow_3(:,2),arrow_color,'EdgeColor','none')
end