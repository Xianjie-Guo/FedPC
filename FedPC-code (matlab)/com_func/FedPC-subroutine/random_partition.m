function [partition] = random_partition(data_samples,clients)
% INPUT :
%   data_samples is the number of all data samples 
%   clients is the number of clients
% 
% OUTPUT:
%   partition is the distribution of data samples on clients 
% 
partition = zeros(1,clients);
left = data_samples;
sum = 0;
for i = 1:clients-1
    flag = 0;
    while flag == 0 

        max = fix(left/ (clients - i)  );
        min = data_samples/(clients*2);
        ran = floor((max - min) .* rand(1) + min);

        if sum + ran < data_samples - min * (clients - 1 - i)-100
            flag = 1;
            sum = sum + ran;
            left = left - ran;
            partition(i) = ran;
        end
    end
end
partition(clients) = left;
for k = 1:clients
    fprintf('%d  ',partition(k));
end
