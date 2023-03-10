function [DAG,sep] = layer_con(data,alpha,G,sep,ord)
% INPUT :
%       data is the data matrix
%       alpha is the significance level
%       G is the learned skeleton; for the first time, fully connected matrix
%       sep is the seperation set
%       ord is the length of the seperation set
% OUTPUT:
%       DAG is uncomplete DAG under the length of seperation set
%       sep is seperation set identified
%
[samples,~]=size(data);

[X,Y] = find(G);
for i=1:length(X)
    x = X(i); 
    y = Y(i);
    nbrs = mysetdiff(myneighbors(G, y), x); 
        if length(nbrs) >= ord && G(x,y) ~= 0 
           SS = subsets1(nbrs, ord);
            for si=1:length(SS)
                S = SS{si};
                [CI]=my_fisherz_test(x,y,S,data,samples,alpha);
                if isnan(CI)
                    CI=0;
                end
                if(CI==1)
                    G(x,y) = 0;
                    G(y,x) = 0;
                    sep{x,y} = myunion(sep{x,y}, S);
                    sep{y,x} = myunion(sep{y,x}, S);
                    break; 
                end
            end
        end
end
DAG = G;