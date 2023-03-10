clear all
clc
close all
% Discrete Bayesian benchmark Networks

% Name of dataset
data_name = 'alarm';

% Samples of data
data_samples = 5000;  

% number of clients
clients = 15;

% Significance level
alpha = 0.01;

% federate ratio
ratio = 0.3;

% Path of the dataset
data_path=strcat('dataset/',data_name,'_',num2str(data_samples),'.txt');
if exist(data_path,'file')==0
     fprintf('\n%s does not exist.\n\n',strcat('dataset/',data_name,'_',num2str(data_samples),'.txt'));
     return;
end

% Load data according to the path
% data needs to start from 0
data = importdata(data_path)+1;
[~,p] = size(data);

% Load true graph according to the path
graph_path=strcat('dataset/',data_name,'_graph.txt');
if exist(graph_path,'file')==0
     fprintf('\n%s does not exist.\n\n',strcat('dataset/',data_name,'_graph.txt'));
     return;
end
graph = importdata(graph_path);

% read parition
partition_path = strcat('dataset/',data_name,'_',num2str(clients),'clients_partition.txt');
if exist(partition_path,'file')==0
     fprintf('\n%s does not exist.\n\n',strcat('dataset/',data_name,'_',num2str(clients),'clients_partition.txt'));
     return;
end
partition_num = importdata(partition_path);

% You can use the function to generate the partition of data on clients.
% partition_num = random_partition(data_samples,clients);

% data on clients
stat = 1;
dataset = cell(1,clients);
for i = 1:clients
    temp = data(fix(stat:stat+partition_num(i)-1),:);
    stat = stat + partition_num(i);
    dataset{i} = temp;
end

% length of seperation set, the maximum value is 3
ord = 0;

fprintf('\nFedPC start learning\n');
start=tic;

while ord < 4
    % skeleton learned in each layer
    ske_set = cell(1,clients);
    
    % seperation set learned in each layer
    sep_set = cell(1,clients);
    
    fprintf('\nlength of seperation set:%d\n',ord);
    for i = 1:clients
        data = dataset{i};
        
        if ord == 0
            % initialize seperation set 
            sep = cell(p,p);
            % initialize DAG
            G = ones(p,p);
            G=setdiag(G,0);
        end
          
        % Result1 is learned causal graph skeleton
        % Result2 is seperation set
        [Result1,Result2] = layer_dis(data,alpha,G,sep,ord);
        ske_set{i} = Result1;
        sep_set{i} = Result2;
        numedge = length(find(Result1))/2;
        fprintf('client %d gets %d edges in the skeleton.\n',i,numedge);
    end
    [fed_ske,fed_sep] = layer_federate(ske_set,sep_set,clients,ratio);
    G = fed_ske;
    sep = fed_sep;
    ord = ord + 1;
end
TP = evaluate_ske(fed_ske,graph);
fprintf('\nSkeleton completed.\n');
fprintf('total edges in true graph:%d\n',length(find(graph)));
fprintf('total edges in the output skeleton:%d\n',length(find(fed_ske))/2);
fprintf('correct edges in the output skeleton:%d\n',TP/2);

fprintf('\nStart orientation.\n');
DAG = orient_dis(G,dataset,clients);
time=toc(start);
fprintf('\nDAG completed.\n');
evaluate(DAG,graph,time);





