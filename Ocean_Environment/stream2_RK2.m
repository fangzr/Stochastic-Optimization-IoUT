function streamline_i=stream2_RK2(x,y,u,v,startx,starty,dt,N)
streamline_i=zeros(N,2);
streamline_i(1,:)=[startx,starty];
x_old=startx;y_old=starty;
F_u = griddedInterpolant(x',y',u','linear');
F_v = griddedInterpolant(x',y',v','linear');
for k=2:N
    %利用改进欧拉法（或者叫2阶Runge-Kutta,预估校正）
    %interp2太慢，放弃
%     u_K1=interp2(x,y,u,x_old,y_old,'linear')*dt;
%     v_K1=interp2(x,y,v,x_old,y_old,'linear')*dt;
    u_K1 = F_u(x_old,y_old)*dt;
    v_K1 = F_v(x_old,y_old)*dt;
%     u_K2=interp2(x,y,u,x_old+0.5*u_K1,y_old+0.5*v_K1,'linear')*dt;
%     v_K2=interp2(x,y,v,x_old+0.5*u_K1,y_old+0.5*v_K1,'linear')*dt;
    u_K2 = F_u(x_old+0.5*u_K1,y_old+0.5*v_K1)*dt;
    v_K2 = F_v(x_old+0.5*u_K1,y_old+0.5*v_K1)*dt;
    x_new=x_old+0.5*(u_K1+u_K2);
    y_new=y_old+0.5*(v_K1+v_K2);
    %保存
    streamline_i(k,:)=[x_new,y_new];
    x_old=x_new;y_old=y_new;
    if isnan(x_new) || isnan(y_new)
        streamline_i(k+1:end,:)=[];
        break
    end
end
end