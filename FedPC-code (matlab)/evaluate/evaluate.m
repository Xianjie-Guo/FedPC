function [] = evaluate(DAG,true_DAG,time)

C = DAG - true_DAG;
x1 = 0;
x2 = 0;
x3 = 0;
x4 = 0;
x5 = 0;
[~,p] = size(DAG);
for i = 1:p
    for j = i:p
         x1 = x1 + true_DAG(i,j);
         x1 = x1 + true_DAG(j,i);
        if (true_DAG(i,j) == DAG(i,j) & DAG(i,j)== 1) || (true_DAG(j,i) == DAG(j,i) & DAG(j,i) == 1)
            x2 = x2 + 1;
        end
        if (true_DAG(i,j) == DAG(j,i) & DAG(j,i) == 1) || (true_DAG(j,i) == DAG(i,j) & DAG(i,j) == 1)
            x3 = x3 + 1;
        end
        if C(i,j) + C(j,i) == 1
            x4 = x4 + 1;
        elseif C(i,j) + C(j,i) == -1
            x5 = x5 + 1;
        end
    end
end

fprintf("total edges in true graph = %d\n" ,x1);
fprintf("total variables           = %d\n" ,p);
fprintf("total edges in the output = %d\n" ,(x2 + x3 + x4));
fprintf("correct edges             = %d\n" ,x2);
fprintf("reverse edges             = %d\n" ,x3);
fprintf("extra edges               = %d\n" ,x4);
fprintf("miss edges                = %d\n" ,x5);
fprintf("SHD                       = %d\n" ,(x3 + x4 + x5));

if x1 ~= 0
    Recall = x2 / x1;
    fprintf("TPR(Recall)               = %.4f\n",( (x2 / x1)));
end
if x2 + x3 + x4 ~= 0
    Precision = x2 / (x2 + x3 + x4);
    FDR = (x3 + x4) / (x2 + x3 + x4);
    fprintf("Precision                 = %.4f\n",( (x2 / (x2 + x3 + x4))));
    fprintf("FDR                       = %.4f\n",( ((x3 + x4) / (x2 + x3 + x4))));
else
    Precision = 0;
    FDR = 0;
    fprintf("Precision                 error\n");
    fprintf("FDR                       error\n");
end
F1 = 2 * (Precision * Recall) / (Precision + Recall);
fprintf("F1                        = %.4f\n",F1);
fprintf("FPR                       = %.4f\n",( ((x3 + x4) / (p * (p - 1) / 2 - x1))));
fprintf("time consuming            = %.4fs\n",time);


