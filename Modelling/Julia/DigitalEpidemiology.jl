module DigitalEpidemiology

# Data Management 
using DataFrames, DataFramesMeta
using DrWatson

# Statistics
using Random
using Distributions
using StatsBase

# Graphs 
using LightGraphs, SimpleWeightedGraphs
using GraphPlot
 #using Graphs

# Modelling
using Agents

# Data Visualization
using Plots
using AgentsPlots
using PlotThemes

# Python
# ENV["PYTHON"] = "path/to/python"
# Pkg.build("PyCall")
using PyCall
using PyPlot
nx = pyimport("networkx")
np = pyimport("numpy")
hvnx = pyimport("hvplot.networkx")
nw = pyimport("netwulf");


function LightGraphs_to_NetworkX(G)
    H = nx.DiGraph()
    edgelist = []
    for row in eachrow(DataFrame([edge for edge in edges(G)]))
        push!(edgelist, (row[1], row[2], row[3]))
    end
    H.add_weighted_edges_from(edgelist)
    return H
end

end