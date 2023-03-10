function [maxsep]  = max_p(x,y,candidate,dataset,clients)
% MAX_P find out the seperation set between 2 nodes with max p-value
% INPUT :
%     x,y is 2 nodes
%     candidate is candidates for separation set 
%     dataset is data across clients
%     clients is the number of clients
% OUTPUT:
%     maxsep is the separation set between 2 nodes with max p-value

alpha = 0.01;
maxsep = [];
pmax = -1;
for ord = 0:3
    SS = subsets1(candidate, ord);
    for si=1:length(SS)
        S = SS{si};
        for i = 1:clients
            data = dataset{i};
            ns = max(data);
            [pval,~] = my_g2_test(x,y,S,data,ns,alpha);
            % CI = 1：independent
            % CI = 0：dependent
            if isnan(pval)
                CI = 0;
            else
                if pval <= alpha
                    CI = 0;
                else
                    CI = 1;
                end
            end
            if(CI == 1)
                if pval > pmax
                    pmax = pval;
                    maxsep = S;
                end
            end
        end
    end
end

