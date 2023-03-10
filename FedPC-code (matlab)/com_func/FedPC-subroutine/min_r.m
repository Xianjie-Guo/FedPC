function [minsep]  = min_r(x,y,candidate,dataset,clients)
% MIN_P find out the seperation set between 2 nodes with min r-value
% INPUT :
%     x,y is 2 nodes
%     candidate is candidates for separation set 
%     dataset is data across clients
%     clients is the number of clients
% OUTPUT:
%     minsep is the separation set between 2 nodes with min r-value

alpha = 0.01;
minsep = [];
rmin = 10000;
for ord = 0:3
    SS = subsets1(candidate, ord);
    for si=1:length(SS)
        S = SS{si};
        for i = 1:clients
            data = dataset{i};
            [samples,~]=size(data);
            [CI,r] = my_fisherz_test(x,y,S,data,samples,alpha);
            % CI = 1：independent
            % CI = 0：dependent
            if isnan(r)
                CI = 0;
            end
            if(CI==1)
                if r < rmin
                    rmin = r;
                    minsep = S;
                end
            end
        end
    end
end

