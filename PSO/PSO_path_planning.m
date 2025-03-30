function [result,TSP,Greedy]=PSO_path_planning(model)
%PSO维度
pso_d = model.n;
pso_w = (model.xmax - model.xmin)/pso_d;%分段

CostFunction=@(x) MyCost(x,model);    % Cost Function

nVar=model.n;       % Number of Decision Variables

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin.x=model.xmin;           % Lower Bound of Variables
VarMax.x=model.xmax;           % Upper Bound of Variables
VarMin.y=model.ymin;           % Lower Bound of Variables
VarMax.y=model.ymax;           % Upper Bound of Variables

%% PSO Parameters

MaxIt=50;          % Maximum Number of Iterations

nPop=model.nPop+2;           % Population Size (Swarm Size)

w=1;                % Inertia Weight
wdamp=0.9;         % Inertia Weight Damping Ratio
c1=1.5;             % Personal Learning Coefficient
c2=1.5;             % Global Learning Coefficient
alpha=0.9;

VelMax.x=alpha*(VarMax.x-VarMin.x);    % Maximum Velocity
VelMin.x=-VelMax.x;                    % Minimum Velocity
VelMax.y=alpha*(VarMax.y-VarMin.y);    % Maximum Velocity
VelMin.y=-VelMax.y;                    % Minimum Velocity

%% Initialization

% Create Empty Particle Structure
empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Sol=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Sol=[];
% Initialize Global Best
GlobalBest.Cost=inf;

% Create Particles Matrix
particle=repmat(empty_particle,nPop,1);%empty_particle作为元素，平铺为nPop * 1的矩阵，每个矩阵有粒子位置、速度等信息

%全局变量记录迭代值
global iteration_num;

%PSO算法循环
for i=1:nPop
   iteration_num = i;
    %初始化位置
    if i > 0
        %添加TSP路径
        if i == nPop
            xx_temp = [model.xs model.SN_X model.xt]';
            yy_temp = [model.ys model.SN_Y model.yt]';
            xx1 = linspace(model.xs, model.xt, model.n+2)';x1 = xx1';
            yy1 = interp1q(xx_temp,yy_temp,xx1);y1 = yy1';
            particle(i).Position.x = x1(2:end-1); %每个粒子一开始赋值都是直线上点
            particle(i).Position.y = y1(2:end-1); 
        %贪婪路径（路径最短）
        elseif (i == (nPop-1))
            xx = linspace(model.xs, model.xt, model.n+2); %定义x坐标数组，等间距直线
            yy = linspace(model.ys, model.yt, model.n+2); %定义y坐标数组，等间距直线
            particle(i).Position.x = xx(2:end-1); %每个粒子一开始赋值都是直线上点
            particle(i).Position.y = yy(2:end-1); %每个粒子一开始赋值都是直线上点
        %粒子群算法的初值赋值
        else
 %          particle(i).Position=CreateRandomSolution(model);
            particle(i).Position=CreateInitialValue_1(i,model,nPop);
        end
    else
        % Straight line from source to destination 绘制一条起点到终点的直线
        xx = linspace(model.xs, model.xt, model.n+2); %定义x坐标数组，等间距直线
        yy = linspace(model.ys, model.yt, model.n+2); %定义y坐标数组，等间距直线
        particle(i).Position.x = xx(2:end-1); %每个粒子一开始赋值都是直线上点
        particle(i).Position.y = yy(2:end-1); %每个粒子一开始赋值都是直线上点
    end
    
    % Initialize Velocity
    particle(i).Velocity.x=zeros(VarSize);%初始化速度为0，n维
    particle(i).Velocity.y=zeros(VarSize);%初始化速度为0，n维
    
    
    % Evaluation
    [particle(i).Cost, particle(i).Sol]=CostFunction(particle(i).Position);  
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Sol=particle(i).Sol;
    
    % Update Global Best
    if particle(i).Best.Cost<GlobalBest.Cost
        
        GlobalBest=particle(i).Best;
        
    end
end

% Array to Hold Best Cost Values at Each Iteration
BestCost=zeros(MaxIt,1);

%% PSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop-2%不用粒子群算法的不要进入迭代
        iteration_num = i;%记录迭代数
        % x Part
        
%         % Update Velocity
%         particle(i).Velocity.x = w*particle(i).Velocity.x ...
%             + c1*rand(VarSize).*(particle(i).Best.Position.x-particle(i).Position.x) ...
%             + c2*rand(VarSize).*(GlobalBest.Position.x-particle(i).Position.x);
%         
%         % Update Velocity Bounds
%         particle(i).Velocity.x = max(particle(i).Velocity.x,VelMin.x);
%         particle(i).Velocity.x = min(particle(i).Velocity.x,VelMax.x);
%         
%         % Update Position
%         particle(i).Position.x = particle(i).Position.x + particle(i).Velocity.x;
%         
%         % Velocity Mirroring
%         OutOfTheRange=(particle(i).Position.x<VarMin.x | particle(i).Position.x>VarMax.x);
%         particle(i).Velocity.x(OutOfTheRange)=-particle(i).Velocity.x(OutOfTheRange);
%         
%         % Update Position Bounds
%         particle(i).Position.x = max(particle(i).Position.x,VarMin.x);
%         particle(i).Position.x = min(particle(i).Position.x,VarMax.x);
        
        % y Part
        
        % Update Velocity
        particle(i).Velocity.y = w*particle(i).Velocity.y ...
            + c1*rand(VarSize).*(particle(i).Best.Position.y-particle(i).Position.y) ...
            + c2*rand(VarSize).*(GlobalBest.Position.y-particle(i).Position.y);
        
        % Update Velocity Bounds
        particle(i).Velocity.y = max(particle(i).Velocity.y,VelMin.y);
        particle(i).Velocity.y = min(particle(i).Velocity.y,VelMax.y);
        
        % Update Position
        particle(i).Position.y = particle(i).Position.y + particle(i).Velocity.y;
        
        % Velocity Mirroring
        OutOfTheRange=(particle(i).Position.y<VarMin.y | particle(i).Position.y>VarMax.y);
        particle(i).Velocity.y(OutOfTheRange)=-particle(i).Velocity.y(OutOfTheRange);
        
        % Update Position Bounds
        particle(i).Position.y = max(particle(i).Position.y,VarMin.y);
        particle(i).Position.y = min(particle(i).Position.y,VarMax.y);
        
        % Evaluation
        [particle(i).Cost, particle(i).Sol]=CostFunction(particle(i).Position);
        
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Sol=particle(i).Sol;
            
            % Update Global Best
            if particle(i).Best.Cost<GlobalBest.Cost
                GlobalBest=particle(i).Best;
            end
            
        end
        
        
    end
    
    % Update Best Cost Ever Found
    BestCost(it)=GlobalBest.Cost;
    
    % Inertia Weight Damping
    w=w*wdamp;

    % Show Iteration Information
    if GlobalBest.Sol.IsFeasible
        Flag=' *';
    else
        Flag=[', Violation = ' num2str(GlobalBest.Sol.Violation)];
    end
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) Flag '; Node energy consumption=' num2str(GlobalBest.Sol.E_T) '; AUV energy consumption=' num2str(GlobalBest.Sol.E_P + GlobalBest.Sol.E_C)]);
    
    % Plot Solution
%     figure;
    PlotSolution(GlobalBest.Sol,model);
end

%% Results

% figure;
% plot(BestCost,'LineWidth',2);
% xlabel('Iteration');
% ylabel('Best Cost');
% grid on;

result = GlobalBest.Sol;
TSP = particle(nPop).Sol;
Greedy = particle(nPop-1).Sol;
