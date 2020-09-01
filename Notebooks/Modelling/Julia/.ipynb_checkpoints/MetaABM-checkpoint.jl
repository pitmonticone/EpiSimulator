### A Pluto.jl notebook ###
# v0.11.8

using Markdown
using InteractiveUtils

# ╔═╡ 04981242-ec8b-11ea-0c48-4fda39c1245e
begin 
	# Data Management 
	using DataFrames, DataFramesMeta, DrWatson, Queryverse
	# Statistics
	using StatsBase, Distributions, Random
	# Graphs 
	using LightGraphs, SimpleWeightedGraphs, GraphIO, GraphPlot
	# Modelling
	using Agents
	# Numerical Computation 
	using LinearAlgebra
	# Data Visualization
	using Plots, AgentsPlots, PlotThemes
	# Python Interface
	###using PyCall 
	###nx = pyimport("networkx");
end

# ╔═╡ 8edb8016-ec8a-11ea-213b-ffcca7d88845
md"
# Data-Driven Agent-Based Metapopulation SEIR Model

## Framework 
* Data exploration, selection and processing in Python 
* Modelling and simulations in Julia 

## Desiderata
1. Implement `move_to_work` and `move_back_home` methods
1. Implement `I_a` and `I_s` compartments
1. Think about diagnostic module
1. Think about how to implement delays (e.g. incubation period, onset of symptoms, ...)
1. Implement age-stratified susceptibility and recovery/death rates. Read Davies, N.G., Klepac, P., Liu, Y. et al. [Age-dependent effects in the transmission and control of COVID-19 epidemics](https://doi.org/10.1038/s41591-020-0962-9). *Nature Medicine* 26, 1205–1211 (2020).

## Age Categories
* Young : 1-6
* Middle: 7-12
* Old : 13-16

## Age-Specific Distributions (Daviers et al. 2020)
* Susceptibility to infection upon contact with an infectious person $\mathcal{N}(\mu=0.1,\sigma=0.023, min=0)$ 
* Clinical fraction on infection: 
    1. $y_y  \sim \mathcal{N}(\mu=0.5,\sigma=0.1, min=0, max = 0.5)$ 
    1. $y_m = 0.5$
    1. $y_o \sim \mathcal{N}(\mu=0.5,\sigma=0.1, min=0.5, max = 1)$

## Delays
* Incubation period ($E$ to $I_a$ and $E$ to $I_s$; days): $d_E \sim \mathcal{\Gamma}(\mu = 3.0, k = 4)$
"

# ╔═╡ 1951b03a-ec8b-11ea-326b-9b07018058f1
md"
## Modules
"

# ╔═╡ 2f7454ee-ec8b-11ea-3227-17ab1eff2513
md"
## Data 
"

# ╔═╡ 1761da66-ec8b-11ea-05b7-519b5405c9ae
md"
### Population 
"

# ╔═╡ 4380dbf6-ec8b-11ea-31f9-d565a048f603
begin
	population_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/ProvincialPopulation.csv"));
	age_population_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/AgeStratifiedProvincialPopulation.csv"));

	# ADD POPULATION DATA PATHS 
	### PIETRO1: "/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/ProvincialPopulation.csv"
	### PIETRO2: "/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/ProvincialPopulation.csv"

	# ADD AGE-STRATIFIED POPULATION DATA PATHS 
	### PIETRO1: "/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/AgeStratifiedProvincialPopulation.csv"
	### PIETRO2: "/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/AgeStratifiedProvincialPopulation.csv"
end;

# ╔═╡ 7d2351ae-ec8b-11ea-0f27-c9fe5fd25f8e
md"
### Contact
"

# ╔═╡ 6ffd583a-ec8b-11ea-3505-3764a56edece
begin
	# Load contact data
	contact_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/ContactEdgeList.csv"))
	# Build contact graph 
	contact_graph = SimpleWeightedDiGraph(contact_data[1].+1, contact_data[2].+1, contact_data[3]);

	# ADD CONTACT DATA PATHS 
	### PIETRO1: "/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/ContactEdgeList.csv"
	### PIETRO2: "/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/ContactEdgeList.csv"
end;

# ╔═╡ 82ad393c-ec8b-11ea-2474-f1e7400a1536
md"
### Mobility 
"

# ╔═╡ 8cae6d28-ec8b-11ea-0f9f-4bfee0ec90b1
begin
	# Load mobility data
	mobility_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/MobilityFlow.csv"))
	# Build mobility graph 
	mobility_graph = SimpleWeightedDiGraph(mobility_data[1], mobility_data[2], mobility_data[3])

	# Remove the 104th node: provincial code doesn't exist
	rem_vertex!(mobility_graph, 104)
	# Remove the 105th node: provincial code doesn't exist
	rem_vertex!(mobility_graph, 104)
	# Remove the 106th node: provincial code doesn't exist
	rem_vertex!(mobility_graph, 104)
	# Remove the 107th node: provincial code doesn't exist
	rem_vertex!(mobility_graph, 104);

	# ADD MOBILITY DATA PATHS 
	### PIETRO1: "/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/MobilityFlow.csv"
	### PIETRO2: "/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/MobilityFlow.csv"
end;

# ╔═╡ b50b2880-ec8b-11ea-3989-21870f8c0f72
md"
## Agent Type
"

# ╔═╡ 9e707de6-ec8b-11ea-38c7-cb8a621135d0
# Patient Definition
mutable struct Patient <: AbstractAgent
    id::Int          # identity code ∈ ℕ               
    pos::Int         # location node ∈ ℕ 
    age_group::Int   # age group ∈ [1,16] ⊂ ℕ
    home::Int        # household node ∈ ℕ
    #work::Int       # workplace node ∈ ℕ
    status::Symbol   # ∈ {S,E,I_as,RD}
    #incubation_left 
end;

# ╔═╡ cab724b8-ec8b-11ea-1f80-eb2ef177675e
md"
## Behaviors
"

# ╔═╡ c7971b8c-ec8b-11ea-3ef9-b9cf02336e5b
begin
	# Mobility Dynamics
	function migrate!(agent, model)
		agent.status == :D && return
		source = agent.pos
		x = [outneighbor for outneighbor in LightGraphs.weights(model.space.graph)[source,:]]
		#outneighbors = node_neighbors(agent, model; neighbor_type=:out)
		distribution = DiscreteNonParametric(1:(model.M), x./sum(x))
		target = rand(distribution)
		if target ≠ source
			agent.pos = target #move_agent!(agent, target, model)
		end
	end

	# Contact Dynamics 
	function contact!(agent, model)
		neighbors = get_node_agents(agent.pos, model)
		contacted_agents = []

		for age_group in 1:model.K
			aged_neighbors = [neighbor for neighbor in neighbors if neighbor.age_group == age_group]  # ADD NOISE !!
			#out_contacts = round(Int, LightGraphs.weights(model.contact_graph)[agent.age_group, age_group])
			ncontacts = round(Int, LightGraphs.weights(model.contact_graph)[age_group, agent.age_group]) # in
			if length(aged_neighbors) != 0 
				push!(contacted_agents, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
			end
		end
		contacted_agents = [(contacted_agents...)...] 
		return contacted_agents
	end


	# Transmission Dynamics
	function get_exposed!(agent, model, contacted_agents)
		# If I'm not susceptible, I return
		agent.status != :S && return

		neighbors = contacted_agents
		for neighbor in neighbors 
			if neighbor.status == :I && (rand() ≤ model.α)
				agent.status = :E
				break
			end
		end
	end

	# Infection Dynamics
	### ADD two compartments (sub- & clinical)
	function get_infected!(agent, model)
		# If I'm not susceptible, I return
		agent.status != :E && return

		if rand() ≤ model.β
			agent.status = :I
		end
	end

	# Recovery Dynamics
	function recover_or_die!(agent, model)
		agent.status != :I && return
		if rand() ≤ model.γ
			agent.status = :R

		elseif rand() ≤ model.σ
			agent.status = :D
			#delete!(model.agents, agent.id)
		end
	end;

	# Mobility Dynamics
	function move_back_home!(agent, model)
		agent.pos == agent.home && return
		if rand() ≤ model.h 
			agent.pos = agent.home #move_agent!(agent, agent.home, model)
		end
	end

	# Micro Dynamics
	function agent_step!(agent, model)
		migrate!(agent, model)                       # M
		contacted_agents = contact!(agent, model)    # C
		get_exposed!(agent, model, contacted_agents) # E
		get_infected!(agent,model)                   # I
		recover_or_die!(agent, model)                # R or D 
		move_back_home!(agent, model)
	end;

	# REMEMBER MODEL_STEP!
end;

# ╔═╡ ea17e80e-ec8b-11ea-1c0f-8bbd80a8bb9a
md"
## Parameters
"

# ╔═╡ f2d7ab0c-ec8b-11ea-1ad4-f5b14794a405
begin
	# Time 
	δt = 1
	nsteps = 80
	tf = nsteps*δt
	t = 0:δt:tf;
	
	# Populations 
	provincial_pops = round.(Int, population_data.population./9000);  # provincial sub-populations
	age_provincial_pops = round.(Int, age_population_data./9000);     # age-stratified provincial sub-populations
	N = sum(Array(age_provincial_pops))  # number of agents
	M = length(provincial_pops)          # number of subpopulations
	K = length(age_provincial_pops[1])   # number of age groups (16)

	# Transition rates 
	α = 0.1      # S -> E
	β = 0.3      # E -> I
	γ = 0.1    # I -> R
	#γ = 0.2    # I -> R
	σ = 0.001    # I -> D

	# Migration rates
	h = 0.8    # home 

	# Initial conditions 
	I0 = round(Int, N/1500)
end;

# ╔═╡ 11311608-ec8c-11ea-1858-5736b227c537
md"
## Model
"

# ╔═╡ 1bdcafac-ec8c-11ea-3586-f70109e150ef
begin
	# Model initialization 
	function initialize_model(provincial_pops::Array{Int,1}, age_provincial_pops::DataFrame,
							  contact_graph::SimpleWeightedDiGraph{Int64,Float64},
							  mobility_graph::SimpleWeightedDiGraph{Int64,Float64}, 
							  α::Real, β::Real, γ::Real,σ::Real,h::Real,
							  I0::Int)
		# Set populations
		N = sum(Array(age_provincial_pops))  # number of agents
		M = length(provincial_pops)          # number of subpopulations
		K = length(age_provincial_pops[1])   # number of age groups (16)
		# Initialize id 
		id = 0    

		# Define the dictionary of model properties
		properties = @dict(contact_graph, 
						   provincial_pops, age_provincial_pops,
						   α, β, γ, σ, h, I0,
						   N, M, K)

		# Instantiate graph ambient space
		space = GraphSpace(mobility_graph) 
		# Instatiate model
		model = ABM(Patient, space; properties = properties)

		# Populate the model
		for province ∈ 1:M
			for age ∈ 1:K 
				for n ∈ 1:age_provincial_pops[province][age]
					id+=1
					home=province
					pos=home
					age_group=age
					status=:S
					add_agent!(pos, model, age_group, home, status)
				end
			end
		end

		# Initialize infected agents 
		agents = [agent for agent in allagents(model)]
		for agent in StatsBase.sample(agents, I0)
			agent.status = :I
		end

		return model
	end;
end;

# ╔═╡ 3561741c-ec8c-11ea-2a37-6be5151207b3
md"
## Simulations 
"

# ╔═╡ 3bddaf18-ec8c-11ea-1958-8b69072c855f
begin
	# Seed Selection
	Random.seed!(1234);

	# Initialize the model
	model = initialize_model(provincial_pops, age_provincial_pops, contact_graph, mobility_graph,α, β, γ, σ, h, I0)

	#simulation_data = @time run!(model, agent_step!, 100);

	#sort!(DataFrame(allagents(model)), :home, rev = false)

	# Ideal Surveillance 
	susceptible(x) = count(i == :S for i in x)
	exposed(x) = count(i == :E for i in x)
	infected(x) = count(i == :I for i in x)
	recovered(x) = count(i == :R for i in x)
	dead(x) = count(i == :D for i in x);

	# Data Collection
	to_collect = [(:status, f) for f in (susceptible, exposed, infected, recovered, dead)]
	data, _ = @time run!(model, agent_step!, nsteps; adata = to_collect);

	sort!(DataFrame(allagents(model)), :home, rev = false)
end

# ╔═╡ 4d012f86-ec8c-11ea-1e30-b7182bb5c4b7
md"
## Visualization
"

# ╔═╡ 457b07b4-ec8c-11ea-10cf-0f42a8b57829
begin 
	# Data Manipulation
	data[!,:t] = t;
	N_list = fill(N,nsteps+1)

	# Select Theme
	theme(:default)
	###theme(:default)
	###theme(:vibrant)
	###theme(:ggplot2)

	# Plot
	plot(t,data[:,2],label="S",
		 xlab="Time",
		 ylabel="Number",
		 title="Agent-Based Metapopulation SEIRD", 
		 legend=:right,
		 lw=2.5)
	plot!(t,data[:,3],label="E", lw=2.5)
	plot!(t,data[:,4],label="I", lw=2.5)
	plot!(t,data[:,5],label="R", lw=2.5)
	plot!(t,data[:,6],label="D", lw=2.5)
	#plot!(t,N_list-data[:,2]-data[:,3]-data[:,4]-data[:,5], label="D")
end

# ╔═╡ Cell order:
# ╟─8edb8016-ec8a-11ea-213b-ffcca7d88845
# ╟─1951b03a-ec8b-11ea-326b-9b07018058f1
# ╠═04981242-ec8b-11ea-0c48-4fda39c1245e
# ╟─2f7454ee-ec8b-11ea-3227-17ab1eff2513
# ╟─1761da66-ec8b-11ea-05b7-519b5405c9ae
# ╠═4380dbf6-ec8b-11ea-31f9-d565a048f603
# ╟─7d2351ae-ec8b-11ea-0f27-c9fe5fd25f8e
# ╠═6ffd583a-ec8b-11ea-3505-3764a56edece
# ╟─82ad393c-ec8b-11ea-2474-f1e7400a1536
# ╠═8cae6d28-ec8b-11ea-0f9f-4bfee0ec90b1
# ╟─b50b2880-ec8b-11ea-3989-21870f8c0f72
# ╠═9e707de6-ec8b-11ea-38c7-cb8a621135d0
# ╟─cab724b8-ec8b-11ea-1f80-eb2ef177675e
# ╠═c7971b8c-ec8b-11ea-3ef9-b9cf02336e5b
# ╟─ea17e80e-ec8b-11ea-1c0f-8bbd80a8bb9a
# ╠═f2d7ab0c-ec8b-11ea-1ad4-f5b14794a405
# ╟─11311608-ec8c-11ea-1858-5736b227c537
# ╠═1bdcafac-ec8c-11ea-3586-f70109e150ef
# ╟─3561741c-ec8c-11ea-2a37-6be5151207b3
# ╟─3bddaf18-ec8c-11ea-1958-8b69072c855f
# ╟─4d012f86-ec8c-11ea-1e30-b7182bb5c4b7
# ╟─457b07b4-ec8c-11ea-10cf-0f42a8b57829
