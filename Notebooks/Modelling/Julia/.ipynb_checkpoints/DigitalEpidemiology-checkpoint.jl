# DIGITAL EPIDEMIOLOGY JULIA PACKAGE 
# AUTHORS: Monticone Pietro, Orsenigo Davide 
# LAST UPDATE: 26-07-2020

module DigitalEpidemiology

# REQUIRED PACKAGES 

## INSTALL 
###ENV["PYTHON"] = "path/to/python"
###Pkg.build("PyCall")

## IMPORT 
using DataFrames, DataFramesMeta, DrWatson         # Data Management 
using Random, Distributions, StatsBase             # Statistics
using LightGraphs, SimpleWeightedGraphs, GraphIO   # Graphs 
using GraphPlot, Plots, AgentsPlots, PlotThemes    # Data Visualization
using PyCall, PyPlot                               # Python
nx = pyimport("networkx")                          # Python
np = pyimport("numpy")                             # Python
nw = pyimport("netwulf")                           # Python

# FUNCTIONS 

### Convert weighted directed LightGraphs into weighted directed NetworkX 
function LightGraphs_to_NetworkX(G)
    # instantiate directed graph object 
    H = nx.DiGraph()  
    # create empty edgelist 
    edgelist = []     
    # fill edgelist 
    for row in eachrow(DataFrame([edge for edge in edges(G)]))
        push!(edgelist, (row[1], row[2], row[3]))
    end
    # build NetworkX weighted directed graph from edgelist 
    H.add_weighted_edges_from(edgelist)
    return H
end

### Convert directed LightGraphs into directed NetworkX 
function LG_to_NX(G)
    # instantiate directed graph object 
    H = nx.DiGraph()
    # create empty edgelist 
    edgelist = []
    # fill edgelist 
    for row in eachrow(DataFrame([edge for edge in edges(G)]))
        push!(edgelist, (row[1], row[2]))
    end
    # build NetworkX weighted directed graph from edgelist 
    H.add_edges_from(edgelist)
    return H
end

### Convert weighted directed NetworkX into weighted directed LightGraphs 
function NetworkX_to_LightGraphs(H)
    # conveniently relable nodes
    nx.convert_node_labels_to_integers(H, first_label=1)
    # write NX edgelist
    nx.write_edgelist(H, "graph.edgelist")
    # read LG edgelist
    G = loadgraph("graph.edgelist", GraphIO.EdgeList.EdgeListFormat())
    return SimpleWeightedDiGraph(G)
end

end # Moudule