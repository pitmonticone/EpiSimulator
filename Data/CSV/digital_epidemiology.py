# DIGITAL EPIDEMIOLOGY MODULE 
# AUTHORS: Monticone Pietro, Orsenigo Davide
# LAST MODIFIED: 27/07/2020

# REQUIRED MODULES 
import sys, os                          # Utils
import pandas as pd                     # Data wrangling
import numpy as np                      # Data wrangling
import math as math                     # Maths
from scipy import stats                 # Statistics
import powerlaw as pwl                  # Statistical analysis of power law distributions
import networkx as nx                   # Network Analysis
import EoN                              # Network Epidemiology 
from matplotlib import pyplot as plt    # Data visualization 
import seaborn as sns                   # Data visualization
import matplotlib.ticker as ticker      # Data visualization
import seaborn as sns                   # Data visualization
from netwulf import visualize           # Data visualization
from collections import Counter         # Utils
import sys, os, os.path                 # Utils
import itertools                        # Utils
from progressbar import ProgressBar     # Utils
from progressbar import Bar, Percentage # Utils
from operator import itemgetter         # Utils
from collections import Counter         # Utils
from collections import defaultdict     # Utils
import random as rand                   # Utils
from scipy.integrate import odeint      # ODE
from scipy.integrate import ode         # ODE
from scipy.integrate import solve_ivp   # ODE

############# CONTENTS #################### 

# 0. BASIC UTILITIES
# 1. NETWORK DATA SCIENCE
# 2. COMPUTATIONAL EPIDEMIOLOGY

############# 0. BASIC UTILITIES ####################

def expand(data, level, demo=None):
    # Add column of neighbors 
    data["NEIGHBORS"] = None 
    # Regional level
    if level == "regional": 
        for index, region in data.iterrows():   
            neighbors = data[~data.geometry.disjoint(region.geometry)].DEN_REG.tolist()
            neighbors = [ name for name in neighbors if region.DEN_REG != name ]
            data.at[index, "NEIGHBORS"] = ",".join(neighbors)
        return 
    # Provincial level
    elif level == "provincial": 
        for index, province in data.iterrows():   
            neighbors = data[~data.geometry.disjoint(province.geometry)].SIGLA.tolist()
            neighbors = [ name for name in neighbors if province.SIGLA != name ]
            data.at[index, "NEIGHBORS"] = ",".join(neighbors)
        return
    # Municipal level
    elif level == "municipal": 
        # Add column of population 
        data["POPULATION"] = None
        for i, municipality in data.iterrows(): 
            # Fill neighbors
            neighbors = data[~data.geometry.disjoint(municipality.geometry)].PRO_COM.tolist()
            neighbors = [ name for name in neighbors if municipality.PRO_COM != name ]
            data.at[i, "NEIGHBORS"] = neighbors
            # Fill demographics
            municipal_code = int(municipality.PRO_COM)
            for j, demographic in demo.iterrows():
                demographic_code = int(demographic.Codice_Comune)
                population = int(demographic.Totale)
                if demographic_code == municipal_code: 
                    data.at[i, "POPULATION"] = population
        return
    
def build_graph(data,level,graph): 
    # Regional level
    if level == "regional": 
        i = 0
        regional_list = list(data.DEN_REG)
        for region in regional_list:
            neighbors_list = data.NEIGHBORS[i].split(",")
            for j in neighbors_list:
                graph.add_edge(region, j)
            i += 1   
        # Remove potential empty nodes 
        if '' in graph.nodes :
            graph.remove_node('')
        # Add metadata
        graph.pos = dict.fromkeys(regional_list) # position
        k = 0
        for region in regional_list:
            graph.pos[region] = (data.centroid[k].x, data.centroid[k].y)
            k +=1
    # Provincial level
    elif level == "provincial":
        i = 0
        provincial_list = list(data.SIGLA)
        for province in provincial_list:
            neighbors_list = data.NEIGHBORS[i].split(",")
            for j in neighbors_list:
                graph.add_edge(province, j)
            i += 1
        # Remove potential empty nodes 
        if '' in graph.nodes :
            graph.remove_node('')
        # Add metadata
        graph.pos = dict.fromkeys(provincial_list) # position
        k = 0
        for province in provincial_list:
            graph.pos[province] = (data.centroid[k].x, data.centroid[k].y)
            k +=1
    # Municipal level
    elif level == "municipal": 
        i = 0
        municipal_list = list(data.PRO_COM)
        for municipality in municipal_list:
            neighbors_list = data.NEIGHBORS[i]
            for j in neighbors_list:
                graph.add_edge(municipality, j)
            i += 1
        # Remove potential empty nodes 
        if '' in graph.nodes :
            graph.remove_node('')
        # Add metadata
        graph.pos = dict.fromkeys(municipal_list)    # position 
        graph.name = dict.fromkeys(municipal_list)   # name 
        graph.pop = dict.fromkeys(municipal_list)    # total population
        k = 0
        for municipality in municipal_list:
            graph.pos[municipality] = (data.centroid[k].x, data.centroid[k].y)
            graph.name[municipality] = data.COMUNE[k]
            graph.pop[municipality] = data.POPULATION[k]
            k +=1
    return graph

def omit_by(dct, predicate=lambda x: x!=0):
    """
    Omit zeros.
    """
    return {k: v for k, v in dct.items() if predicate(v)}

def log_bin(dict,n_bins):
    """
    Logarithmic binning.
    """
    # Define the interval of dict values
    min_val=sorted(dict.values())[0]
    max_val=sorted(dict.values())[-1]
    delta=(math.log(float(max_val))-math.log(float(min_val)))/n_bins
    # Create the bins, in this case the log of the bins is equally spaced (bins size increases exponentially)
    bins=np.zeros(n_bins+1,float)
    bins[0]=min_val
    for i in range(1,n_bins+1):
        bins[i]=bins[i-1]*math.exp(delta)
    # Assign the dict of each node to a bin
    values_in_bin=np.zeros(n_bins+1,float)
    nodes_in_bin=np.zeros(n_bins+1,float)  # this vector is crucial to evalute how many nodes are inside each bin    
    for i in dict:
        for j in range(1,n_bins+1):
            if j<n_bins:
                if dict[i]<bins[j]:
                    values_in_bin[j]+=dict[i]
                    nodes_in_bin[j]+=1.
                    break
            else:
                if dict[i]<=bins[j]:
                    values_in_bin[j]+=dict[i]
                    nodes_in_bin[j]+=1.
                    break
    # Evalutate the average x value in each bin
    for i in range(1,n_bins+1):
        if nodes_in_bin[i]>0:
            values_in_bin[i]=values_in_bin[i]/nodes_in_bin[i]
    # Get the binned distribution        
    binned=[]
    for i in range(1,n_bins+1):
        if nodes_in_bin[i]>0:
                x=values_in_bin[i]
                y=nodes_in_bin[i]/((bins[i]-bins[i-1])*len(dict))
                binned.append([x,y])
    return binned
 
def median(files):

  ite=len(files)
  out=[]
  if len(files)%2 ==0:

		  median=[]
		  median=files

		  median=sorted(median)

		  median.reverse()
		  ee=int(float(ite)/2.)

		  m_cinq=ee-1-int((ee-1)*0.5)
		  max_cinq=ee +int((ee-1)*0.5)
		  m_novc=ee-1-int((ee-1)*0.95)
		  max_novc=ee +int((ee-1)*0.95)

		  out.append([(median[ee]+median[ee-1])/2.,median[m_cinq],median[max_cinq],median[m_novc],median[max_novc]])

  else:

		  median=[]
		  median=files

		  median=sorted(median)

		  median.reverse()
		  ee=int(float(ite)/2.+0.5)
		  m_cinq=ee-1-int((ee-1)*0.5)
		  max_cinq=ee-1+int((ee-1)*0.5)
		  m_novc=ee-1-int((ee-1)*0.95)
		  max_novc=ee-1+int((ee-1)*0.95)
		  
		  out.append([median[ee-1],median[m_cinq],median[max_cinq],median[m_novc],median[max_novc]])

  return out

############# 1. NETWORK DATA SCIENCE  ####################

### 1.1 DATA WRANGLING

def rtweet_to_networkx(fo, so, all = False, save = None):
    """
    Pipeline from rtweet edge-lists to networkx graph objects.
    """
    # Read .csv datasets 
    fo_friends_csv = pd.read_csv(fo)
    so_edges_csv = pd.read_csv(so)
    
    try:
        fo_friends = fo_friends_csv["Target"].tolist()
    except Exception as err:
        print("Error! Expected column names are 'Source' and 'Target' for all csv.")
        raise err
    so_edges = list(zip(so_edges_csv["Source"].tolist(), so_edges_csv["Target"].tolist())) 
    
    if all == True:
        edge_list = [tup for tup in so_edges]
    else:    
        edge_list = [ tup for tup in so_edges if tup[1] in fo_friends ]
        #edge_list = [ (row["Source"],row["Target"]) for _,row in so_edges_csv.iterrows() if row["Target"] in fo_friends ] # line to be removed if the function works on new data  
    # Create directed graph
    G = nx.DiGraph()
    G.add_nodes_from(fo_friends) # add nodes
    G.add_edges_from(edge_list) # add edges
    
    if save is not None:
        nx.write_graphml(G, save)
        
    return G


### 1.2 DEGREE DISTRIBUTIONS

def get_degree_distribution(G, which):
    """
    Get a specific in-/out-/undirected degree distribution.
    """
    
    if which == "degree":
        degree_view = dict(G.degree())
    elif which == "in_degree":
        try:
            degree_view = dict(G.in_degree())
        except:
            print("Error, check the graph! Is it directed?")
    elif which == "out_degree":
        try: 
            degree_view = dict(G.out_degree())
        except:
            print("error, check the graph! Is it directed?")
    else:
        print("Invalid 'which' argument: it must be one of 'degree', 'in_degree' or 'out_degree'")
        return
    mean = np.mean(np.array(list(degree_view.values())))
    var  = np.var(np.array(list(degree_view.values())))
    return (degree_view, mean, var)

def plot_degree_distribution(degree_distribution, hist = True, kde = True, log_binning = None, color = 'darkblue', hist_kws={'edgecolor':'black'}, kde_kws={'linewidth': 3}, title = "", log = False, dimensions = (15,8), display_stats = None):
    """
    Degree distribution visualization.
    """
    plt.rcParams['figure.figsize'] = dimensions
    if log_binning is not None:
        degree_distribution_nonzero = omit_by(dct = degree_distribution)
        log_distrib = log_bin(degree_distribution_nonzero,log_binning)
        bins = [0]+[lim[0] for lim in log_distrib]
    else:
        bins = None
    ax = sns.distplot(list(degree_distribution.values()), hist = hist, kde = kde, bins = bins , color = color, hist_kws = hist_kws , kde_kws =  kde_kws)
    ax.set_title(title, fontsize = 16)
    ax.set_xlabel("$k$", fontsize = 14)
    ax.set_ylabel("$P(k)$", fontsize = 14)
    ax.tick_params(labelsize  = 11)
    if log:
        ax.set_yscale("log")
        ax.set_xscale("log")
#     if display_stats is not None:
#         mean  = np.var(np.array(list(degree_distribution.values())))
#         var  = np.mean(np.array(list(degree_distribution.values())))
        #plt.gcf().text(0.9, 0.8, f"mean = {mean} \n var = {var}", fontsize=14) #, xy=(0.005, 700), xytext=(0.005, 700)
    plt.show()

### 1.3 CENTRALITY METRICS

def get_centrality(G, type_centrality):
    
    if type_centrality=="degree":
        centrality=[]
        for i in G.nodes():
            centrality.append([G.degree(i),i])
        centrality=sorted(centrality,reverse=True)
        return centrality
        
    elif type_centrality=="closeness":
        l=nx.closeness_centrality(G)
        centrality=[]
        for i in G.nodes():
            centrality.append([l[i],i])
        centrality=sorted(centrality,reverse=True)
        return centrality
    
    elif type_centrality=="betweenness":
        l=nx.betweenness_centrality(G)
        centrality=[]
        for i in G.nodes():
            centrality.append([l[i],i])
        centrality=sorted(centrality,reverse=True)
        return centrality
    
    elif type_centrality=="eigenvector":
        l=nx.eigenvector_centrality(G, max_iter=1000, tol=1e-06)
        centrality=[]
        for i in G.nodes():
            centrality.append([l[i],i])
        centrality=sorted(centrality,reverse=True)
        return centrality
    
    elif type_centrality=="katz":
        l=nx.katz_centrality(G, alpha=0.001, beta=1.0, max_iter=1000, tol=1e-06)
        centrality=[]
        for i in G.nodes():
            centrality.append([l[i],i])
        centrality=sorted(centrality,reverse=True)
        return centrality
    
    elif type_centrality=="pagerank":
        l=nx.pagerank(G,0.85)
        centrality=[]
        for i in G.nodes():
            centrality.append([l[i],i])
        centrality=sorted(centrality,reverse=True)
        return centrality
    
    elif type_centrality=="random":
        
        centrality=[]
        for i in G.nodes():
            centrality.append([i,i])
        rand.shuffle(centrality)
        return centrality
    else:
        return 0
    
##### K tau
def k_tau(list_1,list_2):
    id1=[]
    id2=[]
    map_id={}
    c=1
    for i in range(len(list_1)):
        map_id[list_1[i][1]]=c # we need to order the list of one from 1 to N
                               # we map the id to the position in this list
        id1.append(c)
        c+=1
    for i in range(len(list_2)):        
        id2.append(map_id[list_2[i][1]])  # we add the id in the correct order

    
    tau = stats.kendalltau(id1,id2)
    return (tau)

##### Correlation Centralities

def correlation_centralities(G):
    degree_centrality=get_centrality(G,"degree")
    closeness_centrality=get_centrality(G,"closeness")
    betweenness_centrality=get_centrality(G,"betweenness")
    pagerank=get_centrality(G,"pagerank")
    eigenvector_centrality=get_centrality(G,"eigenvector")

    dict_centralities={}
    dict_centralities[0]=["degree",degree_centrality]
    dict_centralities[1]=["closeness",closeness_centrality]
    dict_centralities[2]=["betweenness",betweenness_centrality]
    dict_centralities[3]=["pagerank",pagerank]
    dict_centralities[4]=["eigenvector",eigenvector_centrality]

    list_correlations=[]
    for i in dict_centralities:
        for j in dict_centralities:
            if i<j:
                pair=dict_centralities[i][0]+"-"+dict_centralities[j][0]
                value=k_tau(dict_centralities[i][1],dict_centralities[j][1])[0]
                p_value=k_tau(dict_centralities[i][1],dict_centralities[j][1])[1]
                list_correlations.append([value,p_value,pair])
                
    list_correlations=sorted(list_correlations,reverse=True)
    return list_correlations

##### Plot Centrality Distributions
def plot_centrality_distribution(G, list_centrality, color, n_bins):
    
    dict_centrality={}
    for i in list_centrality:
        if i[0]>0.:
            dict_centrality[i[1]]=i[0]
       
    centrality_binned=log_bin(dict_centrality,n_bins)

    # we then plot their binned distribution
    x_centrality=[]
    y_centrality=[]
    for i in centrality_binned:
        x_centrality.append(i[0])
        y_centrality.append(i[1])

    plt.plot(x_centrality,y_centrality, color=color,linewidth=2,marker="o", alpha=0.6) 
    plt.yscale('log')
    plt.xscale('log')
    plt.xlabel('$x$', fontsize = 15)
    plt.ylabel('$P(x)$', fontsize = 15)
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)
    plt.show()

    
##### Evaluate Efficiency of Centrality Metrics
def evaluate_centrality(G,centrality):
    """
    To evaluate the efficiency of centrality measures we can look at what happen 
    if we remove nodes ranked according to a specific measure.
    """
    
    size=np.zeros(len(centrality)+1,float)

    # Get the size of the largest connected component in the undamaged network
    l=nx.connected_components(G)
    for i in l:
        l=sorted(nx.connected_components(G), key = len, reverse=True)
        size[0]=len(l[0])
        break
        
    # Damage progressively the network & measure the size of the largest connected component at each iteration 
    c=1    
    for i in centrality:   
        G.remove_node(i[1])
        l=sorted(nx.connected_components(G), key = len, reverse=True)
        if len(l)>0:
            size[c]=len(l[0])
            c+=1    
    return size

def evaluate_centrality2(G,type_node):
    list_type=[]
    for i in G.nodes():
        if G.nodes[i]["type"]==type_node:
            list_type.append(i)
        
    size=np.zeros(len(list_type)+1,float)

    # let us get the size of the largest connected component in the undamaged network
    l=nx.connected_components(G)
    for i in l:
        l=sorted(nx.connected_components(G), key = len, reverse=True)
        size[0]=len(l[0])
        break
        
    # let us damage progressively the network and measure at each iteration 
    # the size of the largest connected component    
    c=1
    for i in list_type: 
        G.remove_node(i)
        l=sorted(nx.connected_components(G), key = len, reverse=True)
        if len(l)>0:
            size[c]=len(l[0])
            c+=1    
    return size

##### Plot Efficiency of Centrality Metrics
def plot_centralities_efficiency(G, method=["degree","closeness","betweenness","eigenvector","pagerank","random"]):
    
    N = G.number_of_nodes()
    size_methods=np.zeros((len(method),N+1),float)
    
    c=0
    
    for i in method:
        H=nx.Graph()
        H.add_edges_from(G.edges())
    
        centrality=get_centrality(G,i)
    
        size_methods[c]=evaluate_centrality(H,centrality)
        c+=1
    
    x=np.array([i/float(N) for i in range(N+1)])  

    colors=["#EE5C3D","Green","Blue","Black","Cyan","Orange"]
    alpha_list=[0.5,0.4,0.3,0.2,0.1,0.01]

    # Set figure size 
    plt.figure(figsize=(10,6.6))
    
    # Set figure features
    for i in range(len(method)):
        plt.plot(x,size_methods[i]/size_methods[i][0],color=colors[i],linewidth=2.5,alpha=1,label=method[i])
        #  marker="o", alpha_list[i]
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)
    plt.xlabel("Fraction of Removed Nodes", fontsize=14.5)
    plt.ylabel("$s/s_0$", fontsize=14.5)
    plt.title("Efficiency of Centrality Metrics", fontsize = 16)
    plt.legend(fontsize = 13)
    plt.show()

### 1.4 POWER LAW STATISTICAL ANALYSIS
def power_law_plot(graph, log = True,linear_binning = False, bins = 90, draw= True,x_min = None):
    degree = list(dict(graph.degree()).values())
    
    #powerlaw does not work if a bin is empty
    #sum([1 if x == 0 else 0 for x in list(degree)])
    corrected_degree = [x for x in degree if x != 0 ]
    if x_min is not None:
        corrected_degree = [x  for x in corrected_degree if x>x_min]
    # fit powerlaw exponent and return distribution
    pwl_distri=pwl.pdf(corrected_degree, bins = bins)
    
    if draw:
        degree_distribution = Counter(degree)

        # Degree distribution
        x=[]
        y=[]
        for i in sorted(degree_distribution):   
            x.append(i)
            y.append(degree_distribution[i]/len(graph)) 
        #plot our distributon compared to powerlaw
        
        #plt.figure(figsize=(10,7))
        plt.yscale('log')
        plt.xscale('log')
        plt.plot(x,y,'ro')

        plt.xticks(fontsize=15)
        plt.yticks(fontsize=15)

        plt.xlabel('$k$', fontsize=16)
        plt.ylabel('$P(k)$', fontsize=16)

        if linear_binning:
            pwl.plot_pdf(corrected_degree, linear_bins=True, color='black', linewidth=2)
        else:
            pwl.plot_pdf(corrected_degree, color='black', linewidth=2)
    
    return pwl_distri

### 1.5 COMMUNITY DETECTION

##### Modularity Evaluation 
def modularity(partition):
    return nx.community.quality.modularity(G, partition)

##### Partition Mapping
def create_partition_map(partition):
    partition_map = {}
    for idx, cluster_nodes in enumerate(partition):
        for node in cluster_nodes:
            partition_map[node] = idx
    return partition_map


############# 2. COMPUTATIONAL EPIDEMIOLOGY  ####################

### 2.1 HOMOGENOEOUS MIXING

def SI_hm(beta, N, status):
    """ 
    SI time step under the assumption of 
    homogenous mixing.
    
    * status[1] = S
    * status[2] = I
    """
    p = 0.
    delta = 0.
    
    # Force of infection
    p = beta * float(status[2])/N  ## P(S-->I) 

    if p > 0.:
        # Binomial extraction to identify the number of infected people going to I given p
        delta = np.random.binomial(status[1], p)

    # Update the compartments
    status[1] -= delta
    status[2] += delta
    
    return 0

def SIR_hm(beta,mu,N,status):
    """ 
    SIR time step under the assumption of 
    homogenous mixing.
    """
    p_1=0.
    delta_1=0.
    delta_2=0.
    
    p_1=beta*float(status[1])/N  ## P(S-->I) 
    p_2=mu                      ## P(I--->R)       

    if p_1>0.:
        # binomial extraction to identify the number of infected people going to I given p_1
        delta_1=np.random.binomial(status[0], p_1)
        
    if status[2]!=0:
        delta_2=np.random.binomial(status[1],p_2)

    # update the compartments
    status[0]-= delta_1

    status[1]+= delta_1
    status[1]-= delta_2
    
    status[2]+= delta_2 # R is id=2
    
    return 0

def SIR_ODE(times,initial_condition,parameters):
    """
    Deterministic SIR ODE.
    
    Example arguments:
    parameters = [0.1,0.05]
    initial_condition = [0.99,0.01,0] 
    times = np.linspace(0,200,2001)
    
    Example solution: 
    solution = solve_ivp(fun=lambda t, y: SIR_ODE(t, y, parameters), t_span=[min(times),max(times)], y0=initial_condition, t_eval=times)
    data = pd.DataFrame({"t":solution["t"],"S":solution["y"][0],"I":solution["y"][1],"R":solution["y"][2]})
    """
    b, g = parameters
    S,I,R = initial_condition

    dS = -b*S*I
    dI = b*S*I-g*I
    dR = g*I
    return [dS,dI,dR]

## 2.2 EPIDEMIC DYNAMICS ON STATIC NETWORKS 

def network_SIR_multirun_simulation(G, nrun, lambd, mu):
    """
    Multi-run stochastic SIR simulation. 
    """
    I_dict = defaultdict(list)   # Define the time series dictionary for I 
    Irun = []                    # Define the multi-run list of lists for I 
    
    for run in range(0,nrun):
        # Create a dictionary of nodal infection/disease states s.t. S=0, I=1, R=-1
        G.disease_status = {} 
    
        # Create a list of infected notes 
        I_nodes = []
    
        # Choose a seed
        node_list = []
        deg = dict(G.degree())
        for i in sorted(deg.items(), key = itemgetter(1)):
            node_list.append(i[0])
        seed = node_list[-1]
    
        # Initialize the network
        I_nodes.append(seed)
    
        for n in G.nodes():
            if n in I_nodes:
                # Infected
                G.disease_status[n] = 1 
            else:
                # Susceptible
                G.disease_status[n] = 0 
            
        t = 0                          # Initialize the clock
    
        I_list = []                    # Define the single-run list for I 
        I_list.append(len(I_nodes))    # Initialize the single-run list for I
        I_dict[t].append(I_nodes)      # Initialize the time series dictionary for I
    
        # Implement the dynamical model 
        while len(I_nodes)>0:
    
            # Transmission dynamics (S -> I)
            for i in I_nodes:                           # For any infected node 
                for j in G.neighbors(i):                # For any of its neighbours 
                    if G.disease_status[j] == 0:        # If it's S, 
                        p = np.random.random()          # then infect it with probability lambda
                        if p < lambd:
                            G.disease_status[j] = 1
                
            # Recovery dynamics (I -> R)
            for k in I_nodes:                           # For any infected node 
                p = np.random.random()                  # It recovers with probability mu
                if p < mu:
                    G.disease_status[k] = -1
    
            # Update infected nodes
            I_nodes = []
            for node in G.nodes():
                if G.disease_status[node] == 1:
                    I_nodes.append(node)
        
            t += 1
            # Register the prevalence for each time step
            #I_graph.append(len(infected_nodes))
            I_list.append(len(I_nodes))
            I_dict[t].append(len(I_nodes))
        
        Irun.append(I_list)
    return Irun 

def network_SIR_finalsize_lambda_sensitivity(G, mu, rho, lambda_min, lambda_max, nruns):
    """
    Lambda-sensitivity assessment. 
    """
    #average_degree = 2 * G.number_of_edges() / G.number_of_nodes()
    #lc = mu / average_degree
 
    final_size = defaultdict(list) # normalized attack rate
    
    for lambd in np.geomspace(lambda_min, lambda_max, nruns):
    
        for run in range(0, nruns):
            t, S, I, R = EoN.fast_SIR(G, tau=lambd, gamma=mu, rho=rho)
        
            final_size[lambd].append(R[-1]/G.number_of_nodes())
    
    return pd.DataFrame.from_dict(final_size)

def plot_ensemble(runs):
    """
    Plot the ensemble of epidemic projections / trajectories.
    """
    #plt.figure(figsize = (10,7))
    plt.xticks(fontsize = 11)
    plt.yticks(fontsize = 11)
    plt.xlabel('Time', fontsize = 16)
    plt.ylabel('Prevalence', fontsize = 16)
    for run in runs: 
        plt.plot(range(0,len(run)),run)

def boxplot_finalsize_lambda_sensitivity(G, mu, data, ymin, ymax, xlim):
    """
    Box plot of lambda-sensitivity analysis.
    """
    average_degree = 2 * G.number_of_edges() / G.number_of_nodes()
    lc = mu / average_degree
    
    data.boxplot(positions=np.array(data.columns), 
                 widths=np.array(data.columns)/3)
    
    plt.vlines(x=lc, ymin=ymin, ymax=ymax)
    plt.xscale('log')
    plt.yscale('log')
    plt.xlim(xlim) 
    plt.ylim(0.045, 1.1)
    plt.xticks(fontsize=14)
    plt.yticks(fontsize=14)
    plt.ylabel('Final Epidemic Size ($R_f / |V_G|$)', fontsize=18)
    plt.xlabel('Transmission Rate per Contact ($\lambda$)', fontsize=18)
    plt.show()

def random_walk(G,source,stop,t,nt,visited):
    nt[t]=source # at time t the walker visits node "source"
    visited[source]+=1 # the node has been visited another time
    # the process ends after reaching a certain threshold
    if t<stop:
        # explore the neighbors
        neighbors=list(G.neighbors(source))
        # select one randomly
        target=neighbors[random.randint(0,len(neighbors)-1)]
        # move there using the same function
        random_walk(G,target,stop,t+1,nt,visited)
    else:
        return 0

def get_coverage(nt):
    coverage=np.zeros(nt.size,int)
    v=set()
    for i in range(nt.size):
        v.add(nt[i])
        coverage[i]=len(v) # at each time the coverage is the set up to t 
    return coverage

# let us see another way to do it, without recursion
def random_walk2(G,source,stop,nt,visited):
    t=0
    while t<stop:
        visited[source]+=1
        nt[t]=source
        neighbors=list(G.neighbors(source))
        target=neighbors[random.randint(0,len(neighbors)-1)]
        source=target
        t+=1
        
def ini_subpop(G,average_V,s,x):
    # let assign V people to each subpopulation
    N = G.number_of_nodes()
    V=np.zeros(N,int)
    for i in G.nodes():
        V[i]=average_V

    # inside each subpopulation people are divided in compartments S,I,R
    # let's create a dictionary with the compartments
    compartments={}
    compartments[0]='S'
    compartments[1]='I'
    compartments[2]='R'
    # that that this could be read from file
    # then let's create a dictionary for each subpop that tell us how many people in each compartment are there


    status_subpop={}
    for i in G.nodes():
        status_subpop.setdefault(i,np.zeros(3,int))
        for j in compartments:
            if compartments[j]=='S': # initially they are all S
                status_subpop[i][j]=V[i]
            else:
                status_subpop[i][j]=0

    # now we need to select the subpopulation that are initially seeded
    # let's select a random fraction of s as initially seeded


    n_of_infected=int(s*N)
    # we get the list of nodes and shuffle it
    list_subpop=[]
    for i in range(N):
        list_subpop.append(i)
    random.shuffle(list_subpop)

    # now let's add a number of infected people in the selected subpopulation
    for i in range(n_of_infected):
        seed_subpop=list_subpop[i]
        # for each initial seed we need to change the subpop distribution
        for j in compartments:
            if compartments[j]=='S': # we remove 10 people
                status_subpop[seed_subpop][j]-=x
            if compartments[j]=='I': # we make them infected!
                status_subpop[seed_subpop][j]+=x
            
    return status_subpop

# what about using a different d_kk'? 
# remember from the lecture a more realistic one is d_kk' ~ (kk')^(theta)
# let's create the weights first
def get_p_traveling(theta,G):
    dij={} # this a dictionary we use to compute the rate of travels from any pair ij
    for i in G.nodes():
        l=G.neighbors(i) # we compute the traveling rate to each neighbor
        summ=0.
        dij.setdefault(i,{})
        for j in l:
            # this the numerator of the dij
            w= (G.degree(i)*G.degree(j))**theta
            dij[i].setdefault(j,w)
            summ+=w  # this is the normalization factor: \sum_{j}wij

        for j in dij[i]:
            dij[i][j]=dij[i][j]/summ
    return dij

def random_walk4(G,stop,dij,p,W):
    t=0
    N=G.number_of_nodes()
    while t<stop:
        # temporary vector where to store who moves where at eact t
        temp=np.zeros(N,int)
        temp2=np.zeros(N,int)
        for source in G.nodes():
            # for each node we let diffuse the walkers out of it
            neighbors=list(G.neighbors(source))
            # we need to get the probabilities
            # now p is not 1!!
            prob=[]
            for j in neighbors:
                prob.append(p*dij[source][j])  # with prob p they travel to j with prob p*d_ij
            # with prob 1-p they stay
            prob.append(1.-p)
            output=np.random.multinomial(W[source], prob, size=1)
            # after calling the multinomial we know how to divide W(i)
            id=0
            for j in range(len(output[0])-1):
                temp[neighbors[id]]+=output[0][j] # these are the traveling in
                id+=1 
            temp2[source]=output[0][-1] # these are those staying in source
        # after the loop across all nodes
        # we update the values of W
        for i in G.nodes():
            W[i]=temp[i]+temp2[i]  #since p!=0, this is given by those than arrive plus those that stayed 
            
        t+=1
    
# let's convert all of this into a function

def metapop(t_max,N,compartments,status_subpop,G,beta,mu,p,theta,dij):
    
    diseased={} # for each t let's save the number of diseased subpop
    prevalence={} # for each t let's save the number of infected people
    for t in range(t_max):
        # at each iteration the first thing is to make people travel
        # we make each compartment travel separately
        for j in compartments:
            people_traveling=np.zeros(N,int) # this is the vector of people traveling in comp j
            for k in G.nodes():
                people_traveling[k]+=status_subpop[k][j]

            # we then call the random walk function for 1 time step
            random_walk4(G,1,dij,p,people_traveling)
            # we update the populations given the travels
            for k in G.nodes():
                status_subpop[k][j]=people_traveling[k]

        # after the traveling we can call the SIR model in each subpopulation

        for k in G.nodes():
            tot_pop=0 # we need to know how many people are living in each subpop
            inf=0     # also we run the SIR just if there are infected
            for j in compartments:
                tot_pop+=status_subpop[k][j]
                if j==1:
                    inf=status_subpop[k][j]
            if inf>0:
                SIR_hm(beta,mu,tot_pop,status_subpop[k]) # note how we are passing status_subpop[k] to the function
        #let's see how many diseased subpopulation we have
        disease_sub_pop=0
        tot_inf=0.
        for k in G.nodes():
            if status_subpop[k][1]>0:
                    disease_sub_pop+=1
                    tot_inf+=status_subpop[k][1]
        diseased[t]=disease_sub_pop
        prevalence[t]=tot_inf
        
    return diseased, prevalence

### END OF MODIFIED PERRA MODULES ###

### SEIR ODE (SEI3R or SEIIIR)
def SEIR_ODE(y,t,b,a,g,p,u,N): 
    """
    • Don't track S because all variables must add up to 1.
    • Include blank first entry in vector for beta, gamma, p so that indices align in equations and code. 
    • In the future could include recovery or infection from the exposed class (asymptomatics).
    """
    dy=[0,0,0,0,0,0]
    S=N-sum(y);
    dy[0]=np.dot(b[1:3],y[1:3])*S-a*y[0]  # E: Exposed / Latent
    dy[1]= a*y[0]-(g[1]+p[1])*y[1]        # I1: Mild Infectious
    dy[2]= p[1]*y[1] -(g[2]+p[2])*y[2]    # I2: Severe Infectious
    dy[3]= p[2]*y[2] -(g[3]+u)*y[3]       # I3: Critical Infectious 
    dy[4]= np.dot(g[1:3],y[1:3])          # R: Recovered
    dy[5]=u*y[3]                          # D: Dead
    return dy


def plot_SEIR(time, solution, scale = "both", linear_legend_loc = "center right", log_legend_loc = "lower right"):
    """
    Plot SEIR Evolution (Linear + Log Scales)
    """
    # Linear & Log scale
    if scale == "both":
        plt.figure(figsize=(14,8))  # set figure size
        
        plt.subplot(1,2,1)          # set 2nd subplot
        plt.plot(time,solution)     # set variables to plot 
        plt.xticks(fontsize=12)
        plt.yticks(fontsize=12)
        plt.xlabel("Time (days)", fontsize=15)
        plt.ylabel("Number per 1000 People", fontsize=15)
        plt.legend(("S","E","I1","I2","I3","R","D"), loc = linear_legend_loc, fontsize = 14)
        plt.title("SEIR Evolution (Linear Scale)", fontsize=17)
        plt.ylim([0,10**3])

        plt.subplot(1,2,2)        # set 2nd subplot
        plt.plot(time,solution)   # set variables to plot 
        plt.semilogy()            # set semi-log scale for y axis
        plt.xticks(fontsize=12)  
        plt.yticks(fontsize=12)
        plt.xlabel("Time (days)", fontsize=15)
        plt.ylabel("Number per 1000 People", fontsize=15)
        plt.legend(("S","E","I1","I2","I3","R","D"), loc = log_legend_loc, fontsize = 14)
        plt.title("SEIR Evolution (Logarithmic Scale)", fontsize=17)
        plt.ylim([1,10**3])
        #plt.tight_layout()
        
    # Linear scale
    elif scale == "linear":
        plt.figure(figsize=(12,7))  # set figure size
        plt.plot(time,solution)     # set variables to plot 
        plt.xticks(fontsize=12)
        plt.yticks(fontsize=12)
        plt.xlabel("Time (days)", fontsize=15)
        plt.ylabel("Number per 1000 People", fontsize=15)
        plt.legend(("S","E","I1","I2","I3","R","D"), loc = linear_legend_loc, fontsize = 14)
        plt.title("SEIR Evolution (Linear Scale)", fontsize=17)
        plt.ylim([0,10**3])
    
    # Log scale
    elif scale == "log":
        plt.figure(figsize=(12,7))  # set figure size
        plt.plot(time,solution)     # set variables to plot 
        plt.semilogy()              # set semi-log scale for y axis
        plt.xticks(fontsize=12)  
        plt.yticks(fontsize=12)
        plt.xlabel("Time (days)", fontsize=15)
        plt.ylabel("Number per 1000 People", fontsize=15)
        plt.legend(("S","E","I1","I2","I3","R","D"), loc = log_legend_loc, fontsize = 14)
        plt.title("SEIR Evolution (Logarithmic Scale)", fontsize=17)
        plt.ylim([1,10**3])

def growth_rate(time,solution,t1,t2,i):
    """
    • Get observed growth rate r (and doubling time) for a particular variable between selected time points.
    • All infected classes eventually grow at same rate during early infection.
    • Don't have a simple analytic formula for r for this model due to the complexity of the stages.
    """
    i1=np.where(time==t1)[0][0]
    i2=np.where(time==t2)[0][0]
    r=(np.log(solution[i2,1])-np.log(solution[i1,1]))/(t2-t1)
    doubling_time=np.log(2)/r
    
    return r, doubling_time

def plot_scenarios(time, scenario1, scenario2, scale = "both"): 
    """
    Compare epidemic trajectories / projections under 
    two different scenarios (e.g. mitigated vs. un-mitigated).
    """
    
    # Linear & Log scale
    if scale == "both": 
        plt.figure(figsize=(13,8))  # set figure size
        
        plt.subplot(1,2,1)
        plt.plot(time,np.sum(scenario1[:,2:5],axis=1,keepdims=True)) # set variables to plot 
        plt.plot(time,np.sum(scenario2[:,2:5],axis=1,keepdims=True)) # set variables to plot  
        plt.xticks(fontsize=12)  
        plt.yticks(fontsize=12)
        plt.xlabel("Time (days)", fontsize=15)
        plt.ylabel("Number per 1000 People", fontsize=15)
        plt.legend(("No intervention","Intervention"), fontsize=14)
        #plt.ylim([0,300])
        plt.title('SEIR Incidence (Linear Scale)', fontsize=17)
        
        plt.subplot(1,2,2)
        plt.plot(time,np.sum(scenario1[:,2:5],axis=1,keepdims=True)) # set variables to plot 
        plt.plot(time,np.sum(scenario2[:,2:5],axis=1,keepdims=True)) # set variables to plot 
        plt.semilogy()                                               # set semi-log scale for y axis
        plt.xticks(fontsize=12)  
        plt.yticks(fontsize=12)
        plt.xlabel("Time (days)", fontsize=15)
        plt.ylabel("Number per 1000 People", fontsize=15)
        plt.legend(("No intervention","Intervention"), fontsize=14)
        #plt.ylim([0,300])
        #plt.xlim([0,400])
        plt.title('SEIR Incidence (Log Scale)', fontsize=17)
        
    # Linear scale
    if scale == "linear": 
        plt.figure(figsize=(12,7))                                   # set figure size
        plt.plot(time,np.sum(scenario1[:,2:5],axis=1,keepdims=True)) # set variables to plot 
        plt.plot(time,np.sum(scenario2[:,2:5],axis=1,keepdims=True)) # set variables to plot  
        plt.xticks(fontsize=12)  
        plt.yticks(fontsize=12)
        plt.xlabel("Time (days)", fontsize=15)
        plt.ylabel("Number per 1000 People", fontsize=15)
        plt.legend(("No intervention","Intervention"), fontsize=14)
        #plt.ylim([0,300])
        plt.title('SEIR Incidence (Linear Scale)', fontsize=17)

    # Log scale
    if scale == "log": 
        plt.figure(figsize=(12,7))                                   # set figure size
        plt.plot(time,np.sum(scenario1[:,2:5],axis=1,keepdims=True)) # set variables to plot 
        plt.plot(time,np.sum(scenario2[:,2:5],axis=1,keepdims=True)) # set variables to plot  
        plt.semilogy()                                               # set semi-log scale for y axis
        plt.xticks(fontsize=12)  
        plt.yticks(fontsize=12)
        plt.xlabel("Time (days)", fontsize=15)
        plt.ylabel("Number per 1000 People", fontsize=15)
        plt.legend(("No intervention","Intervention"), fontsize=14)
        #plt.ylim([0,300])
        plt.title('SEIR Incidence (Logarithmic Scale)', fontsize=17)

    
def plot_H_ICU(time, tmax, solution, available_hospital_beds, available_ICU_beds):
    hospital = solution[:,3]+solution[:,4]
    ICU = solution[:,4]

    plt.figure(figsize=(13,4.8))   # set figure size
    
    # Hospitalization
    plt.subplot(1,2,1)
    plt.plot(time,hospital)
    plt.plot(np.array((0, tmax)),available_hospital_beds*np.ones(2),color='C0',linestyle=":")
    plt.xticks(fontsize=12)  
    plt.yticks(fontsize=12)
    plt.xlabel("Time (days)", fontsize=15)
    plt.ylabel("Number per 1000 People", fontsize=15)
    plt.legend(("Cases Needing ICU","Available ICU Beds"), fontsize=14)
    peak_hospital=np.argmax(hospital)                          #find peak
    time_peak_hospital=10*np.ceil(hospital[peak_hospital]/10)  #find time at peak
    #plt.ylim([0,time_peak_hospital])
    
    # ICU
    plt.subplot(1,2,2)
    plt.plot(time,ICU,color='C1')
    plt.plot(np.array((0, tmax)),available_ICU_beds*np.ones(2),color='C1',linestyle=":")
    plt.xticks(fontsize=12)  
    plt.yticks(fontsize=12)
    plt.xlabel("Time (days)", fontsize=15)
    plt.ylabel("Number per 1000 People", fontsize=15)
    plt.legend(("Cases Needing ICU","Available ICU Beds"), fontsize=14)
    peak_ICU=np.argmax(ICU)                     #find peak
    time_peak_ICU=10*np.ceil(ICU[peak_ICU]/10)  #find time at peak
    #plt.ylim([0,time_peak_ICU])
    #plt.ylim([0,peak_hospital])
    
    return hospital, ICU, peak_hospital, peak_ICU


# 4.2 EPIDEMIC DYNAMICS ON TEMPORAL NETWORKS 