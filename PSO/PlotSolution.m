%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPAP115
% Project Title: Path Planning using PSO in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function PlotSolution(sol,model)
    
    xs=model.xs;
    ys=model.ys;
    xt=model.xt;
    yt=model.yt;

    
    XS=sol.XS;
    YS=sol.YS;
    xx=sol.xx_c;
    yy=sol.yy_c;
    plot(xx,yy,'-ro','LineWidth',3);
    hold on;
%     plot(XS,YS,'ro');
    plot(xs,ys,'bs','MarkerSize',12,'MarkerFaceColor','y');
    plot(xt,yt,'kp','MarkerSize',16,'MarkerFaceColor','g');
  


    
    grid on;
    axis equal;
    hold off; 
end