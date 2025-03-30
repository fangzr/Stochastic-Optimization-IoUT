%viscous Lamb vortices
%input: 
%V_X: the X position of the center of the vertexes, MX1 
%V_Y: the Y position of the center of the vertexes, MX1 
%Delta_V: the radius of the vertexes, MX1 
%Gamma_V: the strength of the vortexes, MX1 
%m: the length of the map
%n: the width of the map
%output:
%xx: the X position of map
%yy: the Y position of map
%V_xx: the velocity of the X position
%V_yy: the velocity of the Y position
function [xx,yy,V_xx,V_yy] = Lamb_vortices(V_X,V_Y,Delta_V,Gamma_V,m,n,t)
M = numel(V_X);
V_xx = zeros(m,n);V_yy = zeros(m,n);
%每个坐标要叠加M个漩涡的矢量和
for i=1:m 
    for j=1:n
        temp_VX = 0;
        temp_VY = 0;
        for k=1:M
            temp0 = (i*t-V_X(k))^2+(j*t-V_Y(k))^2;
            temp1 = 1-exp(-1*(temp0/(Delta_V(k))^2));
            temp_y = (Gamma_V(k) * (j*t-V_Y(k))/(2 * pi * temp0) ) * temp1;
            temp_x = (Gamma_V(k) * (-1) * (i*t-V_X(k))/(2 * pi * temp0) ) * temp1;
            temp_VX = temp_VX + temp_x;
            temp_VY = temp_VY + temp_y;
        end
        V_xx(i,j) = temp_VX;
        V_yy(i,j) = temp_VY;
        xx(i,j)=j*t;yy(i,j)=i*t;
    end
end
V_xx(isnan(V_xx)) = 0;
V_yy(isnan(V_xx)) = 0;

