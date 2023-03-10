function [fed_ske,fed_sep] = layer_federate(ske_set,sep_set,clients,ratio)
% INPUT :
%   ske_set is the data matrix set learning from clients
%   sep_set is the separation set learning from clients
%   clients is the number of clients
%   ratio is the voting ratio to determine edges
% 
% OUTPUT:
%   fed_ske is DAG after voting
%   fed_sep is the union of nodes in separation sets 
% 
    [~,p] = size(ske_set{1});
    fed_ske = zeros(p,p);
    fed_sep = cell(p,p);

    G = ones(p,p);
    G=setdiag(G,0);
    [X,Y] = find(G);

    for i=1:length(X)
        x = X(i); 
        y = Y(i);
        
        temp = 0;
        for j = 1:clients
            temp = temp + ske_set{1,j}(x,y);
        end
        
        if temp >= round(clients * ratio)
            fed_ske(x,y) = 1;
        else
            fed_ske(x,y) = 0;
            a = [];
            for k = 1:clients
                a = [a,sep_set{1,k}{x,y}];
            end
             fed_sep{x,y}=unique(a);
        end
    end
    





    




