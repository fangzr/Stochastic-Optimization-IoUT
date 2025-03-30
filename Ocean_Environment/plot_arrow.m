function plot_arrow(xy_lim,xy_ratio,xy_arrow,arrow_color,arrow_width,arrow_direction)
%��ʼ����ͷ��״����һ������״��
arrow_0=[0,0;-1,0.5;-1,-0.5];
%�Է�����й�һ��
a_dn=arrow_direction(:)./xy_ratio(:);
a_dn=a_dn/sqrt(sum(a_dn.^2));
d=(xy_lim(4)-xy_lim(3)+xy_lim(2)-xy_lim(1))/2;
%��ͷ�Դ�������
arrow_1=arrow_0*arrow_width*0.03*d;
%��ͷ��ת
arrow_2=arrow_1*[a_dn(1),a_dn(2);-a_dn(2),a_dn(1)];
%��ͷ����
xy_ratio_n=xy_ratio/sqrt(sum(xy_ratio.^2));%�Ա����߹�һ��
arrow_3=arrow_2.*xy_ratio_n+xy_arrow;
fill(arrow_3(:,1),arrow_3(:,2),arrow_color,'EdgeColor','none')
end