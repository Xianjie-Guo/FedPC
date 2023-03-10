function [TP] = evaluate_ske(skeleton,true_skeleton)

true_skeleton=true_skeleton+true_skeleton';

TP=length(find((skeleton&true_skeleton)==1));
TN=length(  find(  (skeleton|true_skeleton)==0  )  );
FP = length(find((skeleton==1)&(true_skeleton==0)));
FN = length(find((skeleton==0)&(true_skeleton==1)));

[row,~]=size(skeleton);

if TP == 0
    precision = 0;
    recall = 0;
    f1 = 0;
    accuracy = 0;
else
    accuracy=(TP+TN)/(row*row);
    precision=TP/length(find(skeleton==1));
    recall=TP/length(find(true_skeleton==1));
    f1=2*(precision*recall)/(precision+recall);
end


