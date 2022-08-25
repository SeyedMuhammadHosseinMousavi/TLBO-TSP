% These lines of code, solves the Travelling Salesman Problem (TSP)
% by Teaching Learning Based Optimization Algorithm (TLBO) algorithm. 
% By default, 20 points are made by "MakeModel.m” file and you can 
% change it if you want. 

clc;
clear;
close all;

%% Problem 
model=MakeModel();
CostFunction=@(s) CostF(s,model);        % Cost Function
nVar=model.n;             % Number of Decision Variables
VarSize=[1 nVar];         % Decision Variables Matrix Size
VarMin=0;                 % Lower Bound of Variables
VarMax=1;                 % Upper Bound of Variables

%% TLBO Parameters
MaxIt = 500;         % Maximum Number of Iterations
nPop = 50;           % Population Size

%% Start 
% Empty Individuals
empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Sol = [];

% Population Array
pop = repmat(empty_individual, nPop, 1);
% Initialize Best Solution
BestSol.Cost = inf;
% Population Members
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
[pop(i).Cost pop(i).Sol] = CostFunction(pop(i).Position);
if pop(i).Cost < BestSol.Cost
BestSol = pop(i);
end
end
% Best Cost Record
BestCosts = zeros(MaxIt, 1);

%% TLBO 
for it = 1:MaxIt
% Calculate Population Mean
Mean = 0;
for i = 1:nPop
Mean = Mean + pop(i).Position;
end
Mean = Mean/nPop;
% Select Teacher
Teacher = pop(1);
for i = 2:nPop
if pop(i).Cost < Teacher.Cost
Teacher = pop(i);
end
end

% Teacher Phase
for i = 1:nPop
% Create Empty Solution
newsol = empty_individual;
% Teaching Factor
TF = randi([1 2]);
% Teaching (moving towards teacher)
newsol.Position = pop(i).Position ...
+ rand(VarSize).*(Teacher.Position - TF*Mean);
% Clipping
newsol.Position = max(newsol.Position, VarMin);
newsol.Position = min(newsol.Position, VarMax);
% Evaluation
[newsol.Cost newsol.Sol] = CostFunction(newsol.Position);
% Comparision
if newsol.Cost<pop(i).Cost
pop(i) = newsol;
if pop(i).Cost < BestSol.Cost
BestSol = pop(i);
end
end
end

% Learner Phase
for i = 1:nPop
A = 1:nPop;
A(i) = [];
j = A(randi(nPop-1));
Step = pop(i).Position - pop(j).Position;
if pop(j).Cost < pop(i).Cost
Step = -Step;
end
% Create Empty Solution
newsol = empty_individual;
% Teaching (moving towards teacher)
newsol.Position = pop(i).Position + rand(VarSize).*Step;
% Clipping
newsol.Position = max(newsol.Position, VarMin);
newsol.Position = min(newsol.Position, VarMax);
% Evaluation
[newsol.Cost newsol.Sol] = CostFunction(newsol.Position);
% Comparision
if newsol.Cost<pop(i).Cost
pop(i) = newsol;
if pop(i).Cost < BestSol.Cost
BestSol = pop(i);
end
end
end
BestCosts(it) = BestSol.Cost;
% Iteration 
disp(['In ITR ' num2str(it) ': TLBO Cost Value Is = ' num2str(BestCosts(it))]);
% Plot Res
figure(1);
Plotfig(BestSol.Sol.tour,model);
end

%% ITR
figure;
plot(BestCosts, 'LineWidth', 2);
xlabel('ITR');
ylabel('Cost Value');
ax = gca; 
ax.FontSize = 12; 
ax.FontWeight='bold';
set(gca,'Color','k')
grid on;
