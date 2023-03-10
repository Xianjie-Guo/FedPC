Towards Privacy-Aware Causal Structure Learning in Federated Setting


Usage
==========
"FedPC_discrete.m" (for discrete datasets) and "FedPC_continues" (for continues datasets) are two main scripts.

-------------------------------------------------------------------------------------------------------------------

'layer_dis.m'(for discrete datasets) and 'layer_con.m'(for continues datasets) is implemented for the layer-wise strategy.

In 'layer_dis.m' and 'layer_con.m', the inputs and outputs are the same, shown below:

function [DAG,sep] = layer_dis(data,alpha,G,sep,ord)    /    function [DAG,sep] = layer_con(data,alpha,G,sep,ord)

INPUT:

      data is the data matrix
      
      alpha is the significance level
      
      G is the learned skeleton; for the first time, fully connected matrix
      
      sep is the seperation set
      
      ord is the length of the seperation set
      
OUTPUT:

      DAG is uncomplete DAG under the length of seperation set
      
      sep is seperation set identified

-------------------------------------------------------------------------------------------------------------------

'orient_dis.m'(for discrete datasets) and 'orient_con.m' (for continues datasets) is to orient edges.

In 'orient_dis.m' and 'orient_con.m', the inputs and outputs are the same, shown below:

function [DAG] = orient_dis(G,dataset,clients)    /    function [DAG] = orient_con(G,dataset,clients)

INPUT:

    G is the skeleton of DAG
    
    dataset is the data 
    
    clients is the number of clients
    
OUTPUT:

    DAG is the output after orienting

-------------------------------------------------------------------------------------------------------------------

'random_partition.m' is to generate the random number of clients across clients.

function [partition] = random_partition(data_samples,clients)

INPUT:

    data_samples is the number of all data samples 
  
    clients is the number of clients
  
OUTPUT:

    partition is the distribution of data samples on clients 

-------------------------------------------------------------------------------------------------------------------

'layer_federate.m' is the process federating parameters at server.

function [fed_ske,fed_sep] = layer_federate(ske_set,sep_set,clients,ratio)

INPUT:

    ske_set is the data matrix set learning from clients
  
    sep_set is the separation set learning from clients
  
    clients is the number of clients
  
    ratio is the voting ratio to determine edges
  
OUTPUT:

    fed_ske is DAG after voting
  
    fed_sep is the union of nodes in separation sets 

-------------------------------------------------------------------------------------------------------------------

'max_p.m' and 'min_r.m' is to find out the seperation set with max p-value.

function [maxsep]  = max_p(x,y,candidate,dataset,clients)

INPUT:

    x,y is 2 nodes
    
    candidate is candidates for separation set 
    
    dataset is data across clients
    
    clients is the number of clients
    
OUTPUT:

    maxsep is the separation set between 2 nodes with max p-value

function [minsep]  = min_r(x,y,candidate,dataset,clients)

INPUT:

    x,y is 2 nodes
    
    candidate is candidates for separation set 
    
    dataset is data across clients
    
    clients is the number of clients
    
OUTPUT:

    minsep is the seperation set between 2 nodes with min r-value

References
==========
[1] Huang J, Yu K, Guo X, et al. Towards Privacy-Aware Causal Structure Learning in Federated Setting[J]. arXiv preprint arXiv:2211.06919, 2022.
