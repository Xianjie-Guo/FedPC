function [DAG] = orient_con(G,dataset,clients)
% INPUT :
% G is the skeleton of DAG
% dataset is the data 
% clients is the number of clients
% 
% OUTPUT:
% DAG is the output after orienting
%
[~,p] = size(G);
DAG = G;                 
[X, Y] = find(G);
% We want to generate all unique triples x,y,z
% This code generates x,y,z and z,y,x.
for i=1:length(X)
    x = X(i);
    y = Y(i);
    Z = find(G(y,:));
    Z = mysetdiff(Z, x);
    for z=Z(:)'
        if G(x,z)==0
            pc1 = mysetdiff(myneighbors(G, x), z); 
            pc2 = mysetdiff(myneighbors(G, z), x); 
            candidate = unique([pc1, pc2]);
            sep1 = min_r(x,z,candidate,dataset,clients);
            sep2 = min_r(z,x,candidate,dataset,clients);
            if ~ismember(y, sep1) && ~ismember(y, sep2)
                %fprintf('%d -> %d <- %d\n', x, y, z);
                DAG(x,y) = -1; DAG(y,x) = 0;
                DAG(z,y) = -1; DAG(y,z) = 0;
            end
        end
    end
end

% fprintf('--------finishing V structures, directed edge directions---------\n')

old_pdag = zeros(p);
iter = 0;
while ~isequal(DAG, old_pdag)
    iter = iter + 1;
    old_pdag = DAG;
    % rule 1            % a -> b --C  => b->c
    [A,B] = find(DAG==-1); % a -> b
    for i=1:length(A)
        a = A(i); b = B(i);
        C = find(DAG(b,:)==1 & G(a,:)==0); % all nodes adj to b but not a
        if ~isempty(C)
            DAG(b,C) = -1; DAG(C,b) = 0;
            %fprintf('rule 1: a=%d->b=%d and b=%d-c=%d implies %d->%d\n', a, b, b, C, b, C);
        end
    end
    % rule 2            % a->c->b, a--b => a->b
    [A,B] = find(DAG==1); % unoriented a-b edge
    for i=1:length(A)
        a = A(i); b = B(i);
        if any( (DAG(a,:)==-1) & (DAG(:,b)==-1)' )
            DAG(a,b) = -1; DAG(b,a) = 0;
            %fprintf('rule 2: %d -> %d\n', a, b);
        end
    end
    % rule 3            % a--c->b, a--d->b, pdag(c,d)=pdag(d,c)=0, a--b  => a->b
    [A,B] = find(DAG==1); % a-b
    for i=1:length(A)
        a = A(i); b = B(i);
        C = find( (DAG(a,:)==1) & (DAG(:,b)==-1)' );
        % C contains nodes c s.t. a-c->ba
        G2 = setdiag(G(C, C), 1);
        if any(G2(:)==0) % there are 2 different non adjacent elements of C
            DAG(a,b) = -1; DAG(b,a) = 0;
            %fprintf('rule 3: %d -> %d\n', a, b);
        end
    end
end
DAG(DAG==-1)=1;
DAG=cpdag_to_dag(DAG);

