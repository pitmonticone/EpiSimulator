### A Pluto.jl notebook ###
# v0.11.10

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
1. Implement age-stratified susceptibility and recovery/death rates. 
1. Import real COVID-19 data for Italy (tests, lockdown_mobility,...)
1. Think about contact-tracing app 

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
* Incubation period ($E$ to $I_a$ and $E$ to $I_s$; days): $$d_E \sim \mathcal{\Gamma}(\mu = 3.0, k = 4)$$
* Duration of infectiousness in days during the pre-symptomatic phase $d_P=\mathcal{\Gamma}(1.5,4)$
*  **Duration of infectiousness in days during the symptomatic phase $d_S=\mathcal{\Gamma}(3.5,4)$**
*  **Duration of infectiousness in days during the a-symptomatic phase $d_A=\mathcal{\Gamma}(5,4)$**

## Diagnostics

0. Dividere gli algoritmi di sorveglianza in due classi: attiva e passiva, a seconda che sia corredata o meno da intervento (farmaceutico o meno)
1. Partire dall’implementazione della più banale: passiva, nazionale, uniforme 
2. Passiva, nazionale, per fasce d’età / rischio a priori 
3. Passiva, nazionale, symptom-based / rischio a posteriori

4. Passiva, provinciale, uniforme
5. Passiva, provinciale, per fasce d’età / rischio a priori
6. Passiva provinciale, symptom-based / rischio a posteriori

7. Attiva, nazionale, uniforme 
8. Attiva, nazionale, per fasce d’età / rischio a priori 
9. Attiva, nazionale, symptom-based / rischio a posteriori

10. Attiva, provinciale, uniforme
11. Attiva, provinciale, per fasce d’età / rischio a priori
12. Attiva provinciale, symptom-based / rischio a posteriori

14. Passiva, contact-tracing biased 
15. Attiva, contact-tracing biased (a la Crisanti) 

17. Tutte quelle scritte senza distanziamento o mitigazione alcuna
18. Tutte quelle scritte con distanziamento sociale non forzato (behavioral compartments)
19. Tutte quelle scritte sopra con distanziamento sociale forzato (lockdown) locale e/o globale

* Stavo per dimenticare la mia preferita: attiva, contact-tracing biased, lockdown_on, symptomatic_is_positive che consiste nel considerare, in piena epidemia (prevalenza alta), tutti i sintomatici come infetti e quindi contarli come positivi senza tampone (accettando quindi incertezza della diagnosi del medico di base) potendo così allocarne di più alla sorveglianza attiva dei maledetti asintomatici.

## References
* Davies, N.G., Klepac, P., Liu, Y. et al. [Age-dependent effects in the transmission and control of COVID-19 epidemics](https://doi.org/10.1038/s41591-020-0962-9). *Nature Medicine* 26, 1205–1211 (2020).
* Kiesha Prem et al. (2020). [Projecting contact matrices in 177 geographical regions: an update and comparison with empirical data for the COVID-19 era](https://doi.org/10.1101/2020.07.22.20159772). *medRxiv pre-print*. 
* Giordano, G., Blanchini, F., Bruno, R. et al. [Modelling the COVID-19 epidemic and implementation of population-wide interventions in Italy](https://doi.org/10.1038/s41591-020-0883-7). Nat Med 26, 855–860 (2020). 
* Jessica Watson et al. [Interpreting a covid-19 test result](https://doi.org/10.1136/bmj.m1808). *BMJ*, 2020.
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
    id::Int           # identity code ∈ ℕ               
   	pos::Int          # location node ∈ ℕ 
   	age_group::Int    # age group ∈ [1,16] ⊂ ℕ
   	home::Int         # household node ∈ ℕ
   	#work::Int        # workplace node ∈ ℕ
    status::Symbol    # ∈ {S,E,I_a,I_p,I_s,I_c,R,D}
    delay_left::Int  #
	diagnosis::Symbol  # {N,O,P,HR}
	#prescription::Symbol # {O,Q}
	#serological
	#contacts
	#fear   
end;

# ╔═╡ 3f36a99a-ed03-11ea-3936-5ff45f406f73
md"
## Utilities
"

# ╔═╡ 58ffc854-ed01-11ea-2972-750e0dc0908c
# Create truncated normal distribution
begin 
	function TruncatedNormal(μ,σ,min,max)
		y = 0
		while true
			y = rand(Normal(μ,σ))
			if y ≥ min && y ≤ max
				break
			end	
		end
		return y
	end
	
	function SymptomaticFraction(age_group)
		if age_group ≤ 6
			return TruncatedNormal(0.5,0.1,0,0.5)
		elseif age_group ≤ 12
			return 0.5
		else
			return TruncatedNormal(0.5,0.1,0.5,1)
		end
	end
	
	# function DiagnosticCapacity(time)
	
end;

# ╔═╡ cab724b8-ec8b-11ea-1f80-eb2ef177675e
md"
## Behaviors
"

# ╔═╡ 5c57691c-ed24-11ea-33e4-779a4bd311a8
md"
### Macro
"

# ╔═╡ 63ad5744-ed24-11ea-317c-5f53e1137cda
md"
### Micro
"

# ╔═╡ c7971b8c-ec8b-11ea-3ef9-b9cf02336e5b
begin

	# Mobility Dynamics
	function migrate!(agent, model)
		agent.status == :D && return
		source = agent.pos
		x = [outneighbor for outneighbor in LightGraphs.weights(model.space.graph)[source,:]]
		#outneighbors = node_neighbors(agent, model; neighbor_type=:out)
		distribution = DiscreteNonParametric(1:(model.M),x./sum(x))
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
			if (neighbor.status == :I_s || neighbor.status == :I_p) && (rand() ≤ TruncatedNormal(0.5,0.1,0,0.5))
				agent.status = :E
				agent.delay_left = round(Int, rand(Gamma(3,4)))
				break
			elseif neighbor.status == :I_a && (rand() ≤ 0.5*TruncatedNormal(0.5,0.1,0,0.5))
				agent.status = :E
				agent.delay_left = round(Int, rand(Gamma(3,4)))
				break
			end
		end
	end

	# Infection Dynamics
	function get_infected!(agent, model)
		# If I'm not susceptible, I return
		agent.status != :E && return
		agent.delay_left !=0 && return
			
		if rand() ≤ SymptomaticFraction(agent.age_group)
			agent.status = :I_p 
			agent.delay_left = round(Int, rand(Gamma(1.5,4)))
		else
			agent.status = :I_a
			###agent.delay_left = round(Int, rand(Gamma(5,4)))
		end
	end
	
	function get_symptoms!(agent, model)
		# If I'm not susceptible, I return
		agent.status != :I_p && return
		agent.delay_left !=0 && return
		agent.status = :I_s
		###agent.delay_left = round(Int, rand(Gamma(3.5,4)))
	end
	
	# Recovery Dynamics
	function recover_or_die!(agent, model)
		(agent.status!=:I_s && agent.status!=:I_a) && return
		###agent.delay_left != 0 && return
		
		if rand() ≤ model.γ
			agent.status = :R

		elseif rand() ≤ model.σ
			agent.status!=:I_s && return
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
		get_infected!(agent,model)                   # I_p | I_a
		get_symptoms!(agent,model)                   # I_s                      
		recover_or_die!(agent, model)                # R or D 
		move_back_home!(agent, model)
		if agent.delay_left > 0
			agent.delay_left-=1
		end
	end;
end;

# ╔═╡ ea17e80e-ec8b-11ea-1c0f-8bbd80a8bb9a
md"
## Parameters
"

# ╔═╡ f2d7ab0c-ec8b-11ea-1ad4-f5b14794a405
begin
	# Time 
	δt = 1
	nsteps = 100
	tf = nsteps*δt
	t = 0:δt:tf;
	
	# Populations 
	provincial_pops = round.(Int, population_data.population./100);  # provincial sub-populations
	age_provincial_pops = round.(Int, age_population_data./100);     # age-stratified provincial sub-populations
	N = sum(Array(age_provincial_pops))  # number of agents
	M = length(provincial_pops)          # number of subpopulations
	K = length(age_provincial_pops[1])   # number of age groups (16)

	# Transition rates 
	α = 0.1    # S -> E   
	β = 0.3    # E -> I
	γ = 0.1    # I -> R
	#γ = 0.2   # I -> R
	σ = 0.01   # I -> D

	# Migration rates
	h = 0.8    # home 

	# Initial conditions 
	I0 = round(Int, N/500)
	
	# Health System
	capacity = round(Int, N * 5 * 10^(-4))
end;

# ╔═╡ 03fd6022-ed23-11ea-1587-f58557320659
begin
	# Diagnosis Dyanmics
	function test!(model,strategy,capacity)
		agents = [agent for agent in allagents(model) if agent.status!=:D || agent.diagnosis!=:HR]
		provinces = 1:model.M
		prov_populations = model.provincial_pops
		
		prov_capacities = round.(Int, normalize(prov_populations) * capacity)
		prov_agents = [[agent for agent in agents if agent.home == i] for i in provinces]
		
		if strategy == "base_passive_random_uniform_national"
			for agent in StatsBase.sample(agents, capacity)
				if agent.status == :S || agent.status == :R
					if rand() ≤ 0.95 #specificity
						agent.diagnosis=:N
					else 
						agent.diagnosis=:P
					end
				elseif agent.status!=:S && agent.status!=:R
					if rand() ≤ 0.70 #sensitivity
						agent.diagnosis=:P
					else 
						agent.diagnosis=:N
					end
				end
			end
			
		elseif strategy == "passive_random_uniform_national"
			for agent in StatsBase.sample(agents, capacity)
				if (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status == :S || agent.status == :R)
					if rand() ≤ 0.95
						agent.diagnosis=:N
					else 
						agent.diagnosis=:P
					end
				elseif (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status!=:S && agent.status!=:R) 
					if rand() ≤ 0.70
						agent.diagnosis=:P
					else 
						agent.diagnosis=:N
					end
				elseif agent.diagnosis==:P && (agent.status == :S || agent.status == :R)
					if rand() ≤ 0.95
						agent.diagnosis=:HR
					else 
						agent.diagnosis=:P
					end
				elseif agent.diagnosis==:P && (agent.status!=:S && agent.status!=:R) 
					if rand() ≤ 0.70
						agent.diagnosis=:P
					else 
						agent.diagnosis=:HR
					end
				end
			end
			
		elseif strategy == "passive_random_uniform_provincial"
			for prov in provinces
				for agent in StatsBase.sample(prov_agents[prov], prov_capacities[prov])
					if (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status == :S || agent.status == :R)
						if rand() ≤ 0.95
							agent.diagnosis=:N
						else 
							agent.diagnosis=:P
						end
					elseif (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status!=:S && agent.status!=:R) 
						if rand() ≤ 0.70
							agent.diagnosis=:P
						else 
							agent.diagnosis=:N
						end
					elseif agent.diagnosis==:P && (agent.status == :S || agent.status == :R)
						if rand() ≤ 0.95
							agent.diagnosis=:R
						else 
							agent.diagnosis=:P
						end
					elseif agent.diagnosis==:P && (agent.status!=:S && agent.status!=:R) 
						if rand() ≤ 0.70
							agent.diagnosis=:P
						else 
							agent.diagnosis=:R
						end
					end
				end
			end
		end	
	end
	
	# Macro Dynamics
	function model_step!(model)
		#test!(model,"base_passive_random_uniform_national",capacity)
		#test!(model,"passive_random_uniform_national",capacity)
		test!(model,"passive_random_uniform_provincial",capacity)
	end
	
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
					delay_left=-1
					diagnosis=:O
					add_agent!(pos, model, age_group, home, status, 
								delay_left, diagnosis)
				end
			end
		end

		# Initialize infected agents 
		agents = [agent for agent in allagents(model)]
		for agent in StatsBase.sample(agents, I0)
			agent.status = :I_s
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

	# Surveillance 
	susceptible(status) = count(i == :S for i in status)
	exposed(status) = count(i == :E for i in status)
	infected_presymptomatic(status) = count(i == :I_p for i in status)
	infected_symptomatic(status) = count(i == :I_s for i in status)
	infected_asymptomatic(status) = count(i == :I_a for i in status)
	infected(status) =infected_asymptomatic(status)+infected_presymptomatic(status)+infected_symptomatic(status)
	recovered(status) = count(i == :R for i in status)
	dead(status) = count(i == :D for i in status);
	
	tested(diagnosis) = count(i != :O for i in diagnosis);
	positive(diagnosis) = count(i == :P for i in diagnosis);
	positive_rate(diagnosis)=positive(diagnosis)/tested(diagnosis)
	infected_rate(status)= infected(status) / model.N

	# Data Collection
	to_collect = [(:status, susceptible),(:status, exposed),(:status, infected_presymptomatic),(:status, infected_symptomatic),(:status, infected_asymptomatic),(:status, infected),(:status, recovered),(:status, dead),(:status, infected_rate),
		(:diagnosis, tested),(:diagnosis, positive),(:diagnosis, positive_rate)]
	
	data, _ = @time run!(model, agent_step!, model_step!, nsteps; adata = to_collect);

	sort!(DataFrame(allagents(model)), :home, rev = false)
end

# ╔═╡ 4d012f86-ec8c-11ea-1e30-b7182bb5c4b7
md"
## Visualization
"

# ╔═╡ ac81d164-ed2b-11ea-0433-85048542e41b
begin 
	# Data Manipulation
	data[!,:t] = t;
	#N_list = fill(N,nsteps+1)

	# Select Theme
	theme(:default)
	###theme(:default)
	###theme(:vibrant)
	###theme(:ggplot2)

	# Plot
	plot(t,data[:,10],label="Infected Rate",
		 xlab="Time",
		 ylabel="Number",
		 title="Agent-Based Metapopulation SEIIRD", 
		 legend=:topright,
		 lw=2.5)
	plot!(t,data[:,13],label="Positive Rate", lw=2.5)
end

# ╔═╡ 457b07b4-ec8c-11ea-10cf-0f42a8b57829
begin
	# Plot
	plot(t,data[:,2],label="S",
		 xlab="Time",
		 ylabel="Number",
		 title="Agent-Based Metapopulation SEIIRD", 
		 legend=:right,
		 lw=2.5)
	plot!(t,data[:,3],label="E", lw=2.5)
	plot!(t,data[:,4]+data[:,5]+data[:,6],label="I", lw=2.5)
	plot!(t,data[:,8],label="R", lw=2.5)
	plot!(t,data[:,9],label="D", lw=2.5)
	#plot!(t,N_list-data[:,2]-data[:,3]-data[:,4]-data[:,5]-data[:,6]-data[:,7], label="D")
end

# ╔═╡ bec50eac-ed41-11ea-0137-c7016eb9e5a9
begin
	# Plot
	plot(t,data[:,4],label="Pre-Symptomatic",
		 xlab="Time",
		 ylabel="Number",
		 title="Agent-Based Metapopulation SEIIRD", 
		 legend=:topright,
		 lw=2.5)
	plot!(t,data[:,5],label="Symptomatic", lw=2.5)
	plot!(t,data[:,6],label="Asymptomatic", lw=2.5)
end

# ╔═╡ 4e4be2ac-ed0c-11ea-0e9d-7dc8d803f923
#=
begin 
	exposed_fraction(x) = cgrad(:inferno)[count(a.status == :E for a in x) / length(x)]
	
	model1 = initialize_model(provincial_pops, age_provincial_pops, contact_graph, mobility_graph,α, β, γ, σ, h, I0)

	g = model1.space.graph
	weight_matrix = LightGraphs.weights(g)
	for i in 1:nv(g)
		weight_matrix[i,i] = 0
	end

	edgewidthsdict = Dict()
	for node in 1:nv(g)
		nbs = neighbors(g,node)
		for nb in nbs
			edgewidthsdict[(node,nb)] = weight_matrix[node,nb] / sum([outneighbor for outneighbor in weight_matrix[node,:]])
		end
	end

	edgewidthsf(s,d,w) = edgewidthsdict[(s,d)]*3

	plotargs = (node_size=0.15, method=:circular, linealpha=0.4, 
				aspect_ratio = 1, size = (800, 800), showaxis = false)

	plotargs = merge(plotargs, (edgewidth = edgewidthsf,))

	plotabm(model1; ac=exposed_fraction, plotargs...)
end;
=#

# ╔═╡ 804007b6-ed0c-11ea-2e06-4be094d672c3
#=begin 
	model2 = initialize_model(provincial_pops, age_provincial_pops, contact_graph, mobility_graph,α, β, γ, σ, h, I0)

	n = 10
	anim = @animate for i in 0:30
		i > 0 && step!(model2, agent_step!, 1)
		p1 = plotabm(model2; ac = exposed_fraction, plotargs...)
		title!(p1, "Day $(i)")
	end

	gif(anim, "anim.gif", fps = 10)
end
=#

# ╔═╡ Cell order:
# ╟─8edb8016-ec8a-11ea-213b-ffcca7d88845
# ╟─1951b03a-ec8b-11ea-326b-9b07018058f1
# ╟─04981242-ec8b-11ea-0c48-4fda39c1245e
# ╟─2f7454ee-ec8b-11ea-3227-17ab1eff2513
# ╟─1761da66-ec8b-11ea-05b7-519b5405c9ae
# ╟─4380dbf6-ec8b-11ea-31f9-d565a048f603
# ╟─7d2351ae-ec8b-11ea-0f27-c9fe5fd25f8e
# ╟─6ffd583a-ec8b-11ea-3505-3764a56edece
# ╟─82ad393c-ec8b-11ea-2474-f1e7400a1536
# ╟─8cae6d28-ec8b-11ea-0f9f-4bfee0ec90b1
# ╟─b50b2880-ec8b-11ea-3989-21870f8c0f72
# ╠═9e707de6-ec8b-11ea-38c7-cb8a621135d0
# ╟─3f36a99a-ed03-11ea-3936-5ff45f406f73
# ╟─58ffc854-ed01-11ea-2972-750e0dc0908c
# ╟─cab724b8-ec8b-11ea-1f80-eb2ef177675e
# ╟─5c57691c-ed24-11ea-33e4-779a4bd311a8
# ╠═03fd6022-ed23-11ea-1587-f58557320659
# ╟─63ad5744-ed24-11ea-317c-5f53e1137cda
# ╠═c7971b8c-ec8b-11ea-3ef9-b9cf02336e5b
# ╟─ea17e80e-ec8b-11ea-1c0f-8bbd80a8bb9a
# ╠═f2d7ab0c-ec8b-11ea-1ad4-f5b14794a405
# ╟─11311608-ec8c-11ea-1858-5736b227c537
# ╠═1bdcafac-ec8c-11ea-3586-f70109e150ef
# ╟─3561741c-ec8c-11ea-2a37-6be5151207b3
# ╠═3bddaf18-ec8c-11ea-1958-8b69072c855f
# ╟─4d012f86-ec8c-11ea-1e30-b7182bb5c4b7
# ╟─ac81d164-ed2b-11ea-0433-85048542e41b
# ╟─457b07b4-ec8c-11ea-10cf-0f42a8b57829
# ╟─bec50eac-ed41-11ea-0137-c7016eb9e5a9
# ╠═4e4be2ac-ed0c-11ea-0e9d-7dc8d803f923
# ╠═804007b6-ed0c-11ea-2e06-4be094d672c3
