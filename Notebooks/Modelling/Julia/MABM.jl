# Data-Driven Stochastic Agent-Based Metapopulation SEIIIRD Model

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
# Visualization
using Plots, AgentsPlots, PlotThemes, Images, ImageIO

# Load population data
population_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Population/ProvincialPopulation.csv"));
# Load age-stratified population data
age_population_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Population/AgeStratifiedProvincialPopulation.csv"));

# Load contact data for all locations
all_contact_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/AllEdgeList.csv"))
# Build contact graph for all locations
all_contact_graph = SimpleWeightedDiGraph(all_contact_data[1].+1, all_contact_data[2].+1, all_contact_data[3]);
# Load contact data for home
home_contact_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/HomeEdgeList.csv"))
# Build contact graph for home
home_contact_graph = SimpleWeightedDiGraph(home_contact_data[1].+1, home_contact_data[2].+1, home_contact_data[3]);
# Load contact data for work
work_contact_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/WorkEdgeList.csv"))
# Build contact graph for work
work_contact_graph = SimpleWeightedDiGraph(work_contact_data[1].+1, work_contact_data[2].+1, work_contact_data[3]);
# Load contact data for school
school_contact_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/SchoolEdgeList.csv"))
# Build contact graph for school
school_contact_graph = SimpleWeightedDiGraph(school_contact_data[1].+1, school_contact_data[2].+1, school_contact_data[3]);
# Load contact data for other locations
other_contact_data = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/OtherEdgeList.csv"))
# Build contact graph for other locations
other_contact_graph = SimpleWeightedDiGraph(other_contact_data[1].+1, other_contact_data[2].+1, other_contact_data[3]);

# Load mobility data
mobility_data_phase1 = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow1.csv"))
mobility_data_phase2 = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow2.csv"))
mobility_data_phase3 = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow3.csv"))
mobility_data_phase4 = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow4.csv"))

# Build mobility graphs
mobility_graph_phase1 = SimpleWeightedDiGraph(mobility_data_phase1[1], mobility_data_phase1[2], mobility_data_phase1[3])
mobility_graph_phase2 = SimpleWeightedDiGraph(mobility_data_phase2[1], mobility_data_phase2[2], mobility_data_phase2[3])
mobility_graph_phase3 = SimpleWeightedDiGraph(mobility_data_phase3[1], mobility_data_phase3[2], mobility_data_phase3[3])
mobility_graph_phase4 = SimpleWeightedDiGraph(mobility_data_phase4[1], mobility_data_phase4[2], mobility_data_phase4[3])

mobility_graph = SimpleWeightedDiGraph(mobility_data_phase1[1], mobility_data_phase1[2], mobility_data_phase1[3])

# Remove the 104/5/6/7th node: provincial code doesn't exist
for i in 1:4
    rem_vertex!(mobility_graph_phase1, 104)
    rem_vertex!(mobility_graph_phase2, 104)
    rem_vertex!(mobility_graph_phase3, 104)
    rem_vertex!(mobility_graph_phase4, 104)
    rem_vertex!(mobility_graph, 104)
end

active_cases = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Epidemiological/Active.csv"))
symptoms_diagnosis_cases = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Epidemiological/SymptomsDiagnosis.csv"))
tests = DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Epidemiological/Tests.csv"))
# ADD POPULATION DATA PATHS
### PIETRO1: "/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/ActiveCases.csv"
### PIETRO2: "/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/ActiveCases.csv"
### DAVIDE: raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\2020\ActiveCases.csv"

plot_cases=plot(1:100,symptoms_diagnosis_cases["Diagnosis"][1:100],
                label="Date of Diagnosis",
                xlab="Time [Days]",
                ylabel="Number [Cases]",
                #title="COVID-19 Confirmed Cases in Italy",
                legend=:topleft,
                lw=2)
            plot!(plot_cases,1:100,symptoms_diagnosis_cases["Symptoms"][1:100],
                 label="Date of Symptoms Onset",
                 lw=2);

plot_active=plot(1:100,active_cases["Active Cases"][1:100],
    label="Active Cases",
    xlab="Time [Days]",
    ylabel="Number [Cases]",
    #title="COVID-19 Confirmed Cases in Italy",
    legend=:topleft,
    lw=2);

plot(plot_cases, plot_active, layout=2)

# Patient Definition
mutable struct Patient <: AbstractAgent
    id::Int           # identity code ∈ ℕ
    pos::Int          # location node ∈ ℕ
    age_group::Int    # age group ∈ [1,16] ⊂ ℕ
    residence::Int    # residence node ∈ ℕ || RESIDENCE!!
    household::Array  # household
    workplace::Array  # workplace
    status::Symbol    # ∈ {S,E,I_a,I_p,I_s,H,ICU,R,D}
    delay_left::Int
    diagnosis::Symbol # ∈ {N,O,P,HR} || DOUBLE NEGATIVE TEST!!!
    #prescription::Symbol # ∈ {O, Q, ICU}
    #serological
    #contact-tracing
    #fear, risk aversion -> individual-based social distancing
end;

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

function IFR(age_group) #Merler2020
    if age_group ≤ 10
        return 0 # Avg, but thing about the distribution
    elseif age_group ≤ 12
        return 0.46/100
    elseif age_group ≤ 14
        return 1.42/100
    else
        return 6.87/100
    end
end

function DiagnosticRate(status,request)
    false_negative_rate=0
    false_positive_rate=0
    if status==:E
        false_negative_rate=(0.67+1)/2
        false_positive_rate=0.06
    elseif status==:I_s || status==:I_a
        false_negative_rate=(0.38+0.20)/2
        false_positive_rate=0.02
    elseif status==:I_p
        false_negative_rate=(0.67+0.38)/2
        false_positive_rate=0.04
    end
    if request == "false_negative_rate"
        return false_negative_rate
    else
        return false_positive_rate
    end
end

function InitializeHousehold(agent, model)
    agents=get_node_agents(agent.residence, model)
    neighbors = [neighbor for neighbor in agents if neighbor != agent]
    contacted_agents = []
    for age_group in 1:K
        aged_neighbors = [neighbor for neighbor in neighbors if neighbor.age_group == age_group]
        ncontacts = round(Int, LightGraphs.weights(model.home_contact_graph)[age_group, agent.age_group])
        if length(aged_neighbors)>0 && ncontacts>0
                push!(contacted_agents, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
        end
    end
    #contacted_agents = [(contacted_agents...)...]
    return [(contacted_agents...)...]
end

function InitializeWorkplace(agent, model)
    agents=get_node_agents(agent.pos, model)
    neighbors = [neighbor for neighbor in agents if neighbor != agent] # WARNING: STRONG ASSUMPTION!
    contacted_agents = []
    for age_group in 1:K
        aged_neighbors = [neighbor for neighbor in neighbors if neighbor.age_group == age_group]
        ncontacts = round(Int, LightGraphs.weights(model.work_contact_graph)[age_group, agent.age_group])
        if length(aged_neighbors)>0 && ncontacts>0
                push!(contacted_agents, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
        end
    end
    #contacted_agents = [(contacted_agents...)...]
    return [(contacted_agents...)...]
end;
# function DiagnosticCapacity(time)

# MACRO
# Diagnosis Dyanmics
function test!(model,strategy,capacity)
	agents = [agent for agent in allagents(model) if agent.status!=:D && agent.diagnosis!=:HR]
	provinces = 1:model.M
	prov_populations = model.provincial_pops

	prov_capacities = round.(Int, prov_populations./sum(prov_populations) * capacity)
	prov_agents = [[agent for agent in agents if agent.residence == i] for i in provinces]

	if strategy == "base_passive_random_uniform_national"
		for agent in StatsBase.sample(agents, capacity)
			if agent.status==:S || agent.status==:R
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate") #specificity
					agent.diagnosis=:N
				else
					agent.diagnosis=:P
				end
			elseif agent.status!=:S && agent.status!=:R
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_positive_rate") #sensitivity
					agent.diagnosis=:P
				else
					agent.diagnosis=:N
				end
			end
		end

	elseif strategy == "passive_random_uniform_national"
		for agent in StatsBase.sample(agents, capacity)
			if (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status == :S || agent.status == :R)
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate")
					agent.diagnosis=:N
				else
					agent.diagnosis=:P
				end
			elseif (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status!=:S && agent.status!=:R)
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_positive_rate") #sensitivity
					agent.diagnosis=:P
				else
					agent.diagnosis=:N
				end
			elseif agent.diagnosis==:P && (agent.status == :S || agent.status == :R)
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate")
					agent.diagnosis=:HR
				else
					agent.diagnosis=:P
				end
			elseif agent.diagnosis==:P && (agent.status!=:S && agent.status!=:R)
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_positive_rate") #sensitivity
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
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate")
						agent.diagnosis=:N
					else
						agent.diagnosis=:P
					end
				elseif (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status!=:S && agent.status!=:R)
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_positive_rate") #sensitivity
						agent.diagnosis=:P
					else
						agent.diagnosis=:N
					end
				elseif agent.diagnosis==:P && (agent.status == :S || agent.status == :R)
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate")
						agent.diagnosis=:HR
					else
						agent.diagnosis=:P
					end
				elseif agent.diagnosis==:P && (agent.status!=:S && agent.status!=:R)
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_positive_rate") #sensitivity
						agent.diagnosis=:P
					else
						agent.diagnosis=:HR
					end
				end
			end
		end
	elseif strategy == "passive_biased_symptoms_national"
		if rand()≤0.3
			pos=[agent for agent in agents if agent.diagnosis==:P]
			syms=[agent for agent in agents if agent.diagnosis!=:P && agent.status==:I_s]
			nsyms=[agent for agent in agents if agent.diagnosis!=:P && agent.status!=:I_s]
			pos=pos[randperm(length(pos))]
			syms=syms[randperm(length(syms))]
			nsyms=nsyms[randperm(length(nsyms))]
			ags = vcat(pos,syms,nsyms)
		else
			syms=[agent for agent in agents if agent.status==:I_s]
			nsyms=[agent for agent in agents if agent.status!=:I_s]
			syms=syms[randperm(length(syms))]
			nsyms=nsyms[randperm(length(nsyms))]
			ags = vcat(syms,nsyms)
		end
		for agent in ags[1:capacity]
			if (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status == :S || agent.status == :R)
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate")
					agent.diagnosis=:N
				else
					agent.diagnosis=:P
				end
			elseif (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status!=:S && agent.status!=:R)
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_positive_rate") #sensitivity
					agent.diagnosis=:P
				else
					agent.diagnosis=:N
				end
			elseif agent.diagnosis==:P && (agent.status == :S || agent.status == :R)
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate")
					agent.diagnosis=:HR
				else
					agent.diagnosis=:P
				end
			elseif agent.diagnosis==:P && (agent.status!=:S && agent.status!=:R)
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_positive_rate") #sensitivity
					agent.diagnosis=:P
				else
					agent.diagnosis=:HR
				end
			end
		end
	elseif strategy == "passive_biased_symptoms_provincial"
		for prov in provinces
			if rand()≤0.2
				pos=[agent for agent in prov_agents[prov] if agent.diagnosis==:P]
				syms=[agent for agent in prov_agents[prov] if agent.diagnosis!=:P && agent.status==:I_s]
				nsyms=[agent for agent in prov_agents[prov] if agent.diagnosis!=:P && agent.status!=:I_s]
				pos=pos[randperm(length(pos))]
				syms=syms[randperm(length(syms))]
				nsyms=nsyms[randperm(length(nsyms))]
				ags = vcat(pos,syms,nsyms)
			else
				syms=[agent for agent in prov_agents[prov] if agent.status==:I_s]
				nsyms=[agent for agent in prov_agents[prov] if agent.status!=:I_s]
				syms=syms[randperm(length(syms))]
				nsyms=nsyms[randperm(length(nsyms))]
				ags = vcat(syms,nsyms)
			end
			for agent in ags[1:prov_capacities[prov]]
				if (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status == :S || agent.status == :R)
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate")
						agent.diagnosis=:N
					else
						agent.diagnosis=:P
					end
				elseif (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status!=:S && agent.status!=:R)
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_positive_rate") #sensitivity
						agent.diagnosis=:P
					else
						agent.diagnosis=:N
					end
				elseif agent.diagnosis==:P && (agent.status == :S || agent.status == :R)
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate")
						agent.diagnosis=:HR
					else
						agent.diagnosis=:P
					end
				elseif agent.diagnosis==:P && (agent.status!=:S && agent.status!=:R)
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_positive_rate") #sensitivity
						agent.diagnosis=:P
					else
						agent.diagnosis=:HR
					end
				end
			end
		end
	end
end;

# Policy scenarios
function phase1!(model)
   model.phase = 1
end
function phase2!(model)
   model.phase = 2
end
function phase3!(model)
   model.phase = 3
end
function phase4!(model)
   model.phase = 4
end

# Macro Dynamics
function model_step!(model)
   model.t+=1
   #test!(model,"base_passive_random_uniform_national",capacity)
   test!(model,"passive_random_uniform_national",capacity)
   #test!(model,"passive_random_uniform_provincial",capacity) #ONLY FOR LARGE N
   #test!(model,"passive_biased_symptoms_national",capacity)
   #test!(model,"passive_biased_symptoms_provincial",capacity)
   if model.t≤11
	   phase1!(model)
   elseif model.t≤11+22
	   phase2!(model)
   elseif model.t≤11+22+65
	   phase3!(model)
   elseif model.t≤11+22+65+28
	   phase4!(model)
   end
end;

# MICRO

# Contact Dynamics
function contact!(agent, model, location)
	attenuation_factor = 1

	if location=="home"
		agent.pos != agent.residence && return
        contacted_agents = [a for a in agent.household if a.pos==a.residence && a.status !=:D]
        return contacted_agents

	elseif location=="work"
        (typeof(agent.workplace)==Nothing || length(agent.workplace)==0) && return
        possible_contacted_agents = [a for a in agent.workplace if agent.pos==a.pos && a.status !=:D]
        effective_contacted_agents=[]
		if model.phase == 3
			attenuation_factor=0.4
            ncontacts = round(Int, attenuation_factor*length(possible_contacted_agents))
                # Think about DiscreteNonParametric
            if ncontacts>0
                push!(effective_contacted_agents, StatsBase.sample(possible_contacted_agents, ncontacts; replace=true, ordered=false))
            end
            effective_contacted_agents=[(effective_contacted_agents...)...]
            return effective_contacted_agents
        else
            return possible_contacted_agents
		end

	elseif location=="school"
		model.phase == 3 && return # school closure
        contact_graph=model.school_contact_graph

	elseif location=="other"
		if model.phase == 3
			attenuation_factor=0.5
		end
		contact_graph=model.other_contact_graph
	end

	neighbors = [n for n in get_node_agents(agent.pos, model) if n != agent]
	contacted_agents = []

	for age_group in 1:model.K
		aged_neighbors = [neighbor for neighbor in neighbors if neighbor.age_group == age_group && neighbor.status!=:D]
		#out_contacts = round(Int, LightGraphs.weights(model.contact_graph)[agent.age_group, age_group])
		ncontacts = round(Int, attenuation_factor*LightGraphs.weights(contact_graph)[age_group, agent.age_group]) # in
		if length(aged_neighbors)>0 && ncontacts>0
			push!(contacted_agents, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
		end
	end
	contacted_agents = [(contacted_agents...)...]
	return contacted_agents
end

# Mobility Dynamics
function migrate!(agent, model)
	source = agent.pos
	targets=[]
	if model.phase == 1
		targets = [outneighbor for outneighbor in LightGraphs.weights(model.mobility_graph_phase1)[source,:]]
	elseif model.phase == 2
		targets = [outneighbor for outneighbor in LightGraphs.weights(model.mobility_graph_phase2)[source,:]]
	elseif model.phase == 3
		targets = [outneighbor for outneighbor in LightGraphs.weights(model.mobility_graph_phase3)[source,:]]
	elseif model.phase == 4
		targets = [outneighbor for outneighbor in LightGraphs.weights(model.mobility_graph_phase4)[source,:]]
	end

	#outneighbors = node_neighbors(agent, model; neighbor_type=:out)
	distribution = DiscreteNonParametric(1:model.M,targets./sum(targets))
	target = rand(distribution)
	if target ≠ source
		agent.pos = target #move_agent!(agent, target, model)
	end
end

# Transmission Dynamics
function get_exposed!(agent, model, contacted_agents)
	# If I'm not susceptible, I return
	agent.status!=:S && return
	(typeof(contacted_agents)==Nothing || length(contacted_agents)==0) && return

	neighbors = contacted_agents
	for neighbor in neighbors
		if neighbor.status == :I_s && (rand() ≤ TruncatedNormal(0.5,0.1,0,0.5))
			agent.status = :E
			agent.delay_left = round(Int, rand(Gamma(3,4)))
			break
		elseif neighbor.status == :I_p && (rand() ≤ 0.15*TruncatedNormal(0.5,0.1,0,0.5)) # Aleta et al.(2020)
			agent.status = :E
			agent.delay_left = round(Int, rand(Gamma(3,4)))
			break
		elseif neighbor.status == :I_a && (rand() ≤ TruncatedNormal(0.5,0.1,0,0.5)/2)
			agent.status = :E
			agent.delay_left = round(Int, rand(Gamma(3,4)))
			break
		end
	end
end

# Infection Dynamics
function get_infected!(agent, model)
	# If I'm not susceptible, I return
	(agent.status!=:E || agent.delay_left !=0) && return

	if rand() ≤ SymptomaticFraction(agent.age_group)
		agent.status = :I_p
		agent.delay_left = round(Int, rand(Gamma(1.5,4)))
	else
		agent.status = :I_a
		agent.delay_left = round(Int, rand(Gamma(5,4)))
	end
end

function get_symptoms!(agent, model)
	# If I'm not susceptible, I return
	(agent.status!=:I_p || agent.delay_left !=0) && return
	agent.status = :I_s
	agent.delay_left = round(Int, rand(Gamma(3.5,4)))
end

# Recovery Dynamics
function recover_or_die!(agent, model)
	((agent.status!=:I_s && agent.status!=:I_a)||agent.delay_left != 0) && return
	# eventually include DOF
	if rand() ≤ IFR(agent.age_group) && agent.status==:I_s
		agent.status=:D
	else
		agent.status=:R
	end
end;

# Mobility Dynamics
function move_back_home!(agent, model)
    agent.pos == agent.residence && return
    if rand() ≤ model.h
        agent.pos = agent.residence
    end
end

# Micro Dynamics
function agent_step!(agent, model)
	agent.status==:D && return
	home_contacted_agents=contact!(agent, model,"home")
	get_exposed!(agent, model, home_contacted_agents)
	migrate!(agent, model)
	work_contacted_agents=contact!(agent, model,"work")
	get_exposed!(agent, model, work_contacted_agents)
	school_contacted_agents=contact!(agent, model,"school")
	get_exposed!(agent, model, school_contacted_agents)
	other_contacted_agents=contact!(agent, model,"other")
	get_exposed!(agent, model, other_contacted_agents)
	get_infected!(agent,model)
	get_symptoms!(agent,model)
	recover_or_die!(agent, model)
	move_back_home!(agent, model)
	if agent.delay_left > 0
		agent.delay_left-=1
	end
end;

# PARAMETERS
# Time
δt = 1
nsteps = 100
tf = nsteps*δt
t = 0:δt:tf;

# Populations
scale_factor=6000
provincial_pops = round.(Int, population_data.population./scale_factor);  # provincial sub-populations
age_provincial_pops = round.(Int, age_population_data./scale_factor);     # age-stratified provincial sub-populations
N = sum(Array(age_provincial_pops))  # number of agents
M = length(provincial_pops)          # number of subpopulations
K = length(age_provincial_pops[1])   # number of age groups (16)

# Transition rates
#α = 0.1    # S -> E
#β = 0.3    # E -> I
#γ = 0.1    # I -> R
#γ = 0.2   # I -> R
#σ = 0.01   # I -> D

# Migration rates
h = 0.8    # home

# Initial conditions
###I0 = round(Int, N/2000)
I0=2

# Health System
capacity = round(Int, N * 5 * 10^(-4))
#capacity = round(Int, N/100)

# MODEL
# Model initialization
function InitializeModel(t::Int, provincial_pops::Array{Int,1}, age_provincial_pops::DataFrame,
		home_contact_graph::SimpleWeightedDiGraph{Int64,Float64}, work_contact_graph::SimpleWeightedDiGraph{Int64,Float64}, school_contact_graph::SimpleWeightedDiGraph{Int64,Float64}, other_contact_graph::SimpleWeightedDiGraph{Int64,Float64},
		mobility_graph::SimpleWeightedDiGraph{Int64,Float64},mobility_graph_phase1::SimpleWeightedDiGraph{Int64,Float64},mobility_graph_phase2::SimpleWeightedDiGraph{Int64,Float64},mobility_graph_phase3::SimpleWeightedDiGraph{Int64,Float64},mobility_graph_phase4::SimpleWeightedDiGraph{Int64,Float64},
		h::Real,I0::Int)

	# Set populations
	N = sum(Array(age_provincial_pops))  # number of agents
	M = length(provincial_pops)          # number of subpopulations
	K = length(age_provincial_pops[1])   # number of age groups (16)
	# Initialize id
	id = 0
	# Initialize Phase
	phase = 1
	# Define the dictionary of model properties
	properties = @dict(t, phase,
		home_contact_graph, work_contact_graph, school_contact_graph, other_contact_graph,
		mobility_graph_phase1,mobility_graph_phase2,mobility_graph_phase3,mobility_graph_phase4,
		provincial_pops, age_provincial_pops,
		h, I0,
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
				residence=province
				household=[]
                workplace=[]
				pos=residence
				age_group=age
				status=:S
				delay_left=-1
				diagnosis=:O
				add_agent!(pos, model, age_group, residence, household, workplace, status, delay_left, diagnosis)
			end
		end
	end

    # Create a list of all agents
    agents = [agent for agent in allagents(model)]

	# Initialize households & workplaces
	for agent in agents
		agent.household=InitializeHousehold(agent, model)
		agent.workplace=InitializeWorkplace(agent, model)
	end

	# Initialize infected agents
	for agent in StatsBase.sample(agents, I0)
		agent.status = :E
		agent.delay_left = round(Int, rand(Gamma(3,4)))
	end

	return model
end;

# SIMULATIONS
# Seed Selection
Random.seed!(1234);

# Initialize the model
model = InitializeModel(0,
	provincial_pops, age_provincial_pops,
	home_contact_graph, work_contact_graph, school_contact_graph, other_contact_graph,
	mobility_graph,mobility_graph_phase1,mobility_graph_phase2,mobility_graph_phase3,mobility_graph_phase4,
	h, I0)

# Surveillance
susceptible(status) = count(i == :S for i in status)
exposed(status) = count(i == :E for i in status)
infected_presymptomatic(status) = count(i == :I_p for i in status)
infected_symptomatic(status) = count(i == :I_s for i in status)
infected_asymptomatic(status) = count(i == :I_a for i in status)
infected(status) =exposed(status)+infected_asymptomatic(status)+infected_presymptomatic(status)+infected_symptomatic(status)
recovered(status) = count(i == :R for i in status)
dead(status) = count(i == :D for i in status);
###total_tests = nsteps * capacity
###daily_tests = capacity
tested(diagnosis) = count(i != :O for i in diagnosis);
#daily_tested(diagnosis)= count
positive(diagnosis) = count(i == :P for i in diagnosis);
positive_rate(diagnosis)=positive(diagnosis)/tested(diagnosis)
#positive_rate(diagnosis)=positive(diagnosis)/capacity # new_positives/cpacity or #positives/ || "daily tests" != "daily tested people"
infected_rate(status)= infected(status) / model.N

# Data Collection
to_collect = [(:status, susceptible),(:status, exposed),(:status, infected_presymptomatic),(:status, infected_symptomatic),(:status, infected_asymptomatic),(:status, infected),(:status, recovered),(:status, dead),(:status, infected_rate),
	(:diagnosis, tested),(:diagnosis, positive),(:diagnosis, positive_rate)]

data, _ = @time run!(model, agent_step!, model_step!, nsteps; adata = to_collect, replicates=3);

#sort!(DataFrame(allagents(model)), :residence, rev = false)

gd = groupby(data, [:step])

# VISUALIZATION
timestep = 2:length(gd)

ft=[quantile(gd[i].tested_diagnosis-gd[i-1].tested_diagnosis,0.05) for i in timestep]
mt=[quantile(gd[i].tested_diagnosis-gd[i-1].tested_diagnosis,0.5) for i in timestep]
nt=[quantile(gd[i].tested_diagnosis-gd[i-1].tested_diagnosis,0.95) for i in timestep]

plot(timestep, mt[2:length(mt)],
	label="Tested Patients",
	xlab="Time",
	ylabel="Number",
	#title="DC=$capacity | Χ²=$Χ",
	legend=:bottomright,
	lw=2.5;
	ribbon=[mt-ft,nt-mt],
    fillalpha=0.3)
plot(timestep, mt,
	label="Daily Tested Patients",
	lw=2.5;
	ribbon=[mt-ft,nt-mt],
    fillalpha=0.3)
plot!(timestep, [capacity for i in timestep],
      label="Daily Tests",
      lw=2.5)

f1=[quantile(gd[i].infected_rate_status,0.05) for i in timestep]
m1=[quantile(gd[i].infected_rate_status,0.5) for i in timestep]
n1=[quantile(gd[i].infected_rate_status,0.95) for i in timestep]

f2=[quantile(gd[i].positive_rate_diagnosis,0.05) for i in timestep]
m2=[quantile(gd[i].positive_rate_diagnosis,0.5) for i in timestep]
n2=[quantile(gd[i].positive_rate_diagnosis,0.95) for i in timestep]

Χ = round(Int, sum(((m2-m1).^2)./m1))

plot(timestep, m1,
	  	label="Incidence",
	  	xlab="Time",
	  	ylabel="Number",
	  	title="DC=$capacity | Χ²=$Χ",
	  	legend=:right,
	  	lw=2.5;
	  	ribbon=[m1-f1,n1-m1],
	      fillalpha=0.3)
plot!(timestep, m2,
	  	label="Positive Rate",
	  	lw=2.5;
	  	ribbon=[m2-f2,n2-m2],
	      fillalpha=0.3)

m=[quantile(gd[i].infected_status,0.05) for i in 2:length(gd)]
f=[quantile(gd[i].infected_status,0.5) for i in 2:length(gd)]
n=[quantile(gd[i].infected_status,0.95) for i in 2:length(gd)]


m0=[quantile(gd[i].positive_diagnosis,0.05) for i in 2:length(gd)]
f0=[quantile(gd[i].positive_diagnosis,0.5) for i in 2:length(gd)]
n0=[quantile(gd[i].positive_diagnosis,0.95) for i in 2:length(gd)]

#=plot(timestep, m,
		  	label="Simulated Infected",
		  	xlab="Time",
		  	ylabel="Number",
		  	#title="DC=$capacity | Χ²=$Χ",
		  	legend=:right,
		  	lw=2.5;
		  	ribbon=[m-f,n-m],
		      fillalpha=0.3)=#
plot(timestep, m0,
		  	  label="Simulated Positive",
		  	  lw=2.5;
		  	  ribbon=[m0-f0,n0-m0],
		        fillalpha=0.3)
plot!(timestep,active_cases["Active Cases"][1:100]/scale_factor,
		  	  label="Active Cases",
		  	  lw=2.5)


# Ensemble of susceptibles
m3=[quantile(gd[i].susceptible_status,0.05) for i in 2:length(gd)]
f3=[quantile(gd[i].susceptible_status,0.5) for i in 2:length(gd)]
n3=[quantile(gd[i].susceptible_status,0.95) for i in 2:length(gd)]
# Ensemble of exposed
m4=[quantile(gd[i].exposed_status,0.05) for i in 2:length(gd)]
f4=[quantile(gd[i].exposed_status,0.5) for i in 2:length(gd)]
n4=[quantile(gd[i].exposed_status,0.95) for i in 2:length(gd)]
# Ensemble of infected
m5=[quantile(gd[i].infected_presymptomatic_status+gd[i].infected_symptomatic_status+gd[i].infected_asymptomatic_status,0.05) for i in 2:length(gd)]
f5=[quantile(gd[i].infected_presymptomatic_status+gd[i].infected_symptomatic_status+gd[i].infected_asymptomatic_status,0.5) for i in 2:length(gd)]
n5=[quantile(gd[i].infected_presymptomatic_status+gd[i].infected_symptomatic_status+gd[i].infected_asymptomatic_status,0.95) for i in 2:length(gd)]
# Ensemble of recovered
m6=[quantile(gd[i].recovered_status,0.05) for i in 2:length(gd)]
f6=[quantile(gd[i].recovered_status,0.5) for i in 2:length(gd)]
n6=[quantile(gd[i].recovered_status,0.95) for i in 2:length(gd)]
# Ensemble of died
m7=[quantile(gd[i].dead_status,0.05) for i in 2:length(gd)]
f7=[quantile(gd[i].dead_status,0.5) for i in 2:length(gd)]
n7=[quantile(gd[i].dead_status,0.95) for i in 2:length(gd)]

# Plot ensembles
plot(timestep, m3,
	label="S",
	xlab="Time",
	ylabel="Number",
	itle="Agent-Based Metapopulation SEIIRD",
	legend=:right,
	lw=2.5;
	ribbon=[m3-f3,n3-m3],
	illalpha=0.3)
plot!(timestep, m4,label="E",lw=2.5; ribbon=[m4-f4,n4-m4],fillalpha=0.3)
plot!(timestep, m5,label="I",lw=2.5; ribbon=[m5-f5,n5-m5],fillalpha=0.3)
plot!(timestep, m6,label="R",lw=2.5; ribbon=[m6-f6,n6-m6],fillalpha=0.3)
plot!(timestep, m7,label="D",lw=2.5; ribbon=[m7-f7,n7-m7],fillalpha=0.3)

# Ensemble of presymptomatic infected
m8=[quantile(gd[i].infected_presymptomatic_status,0.05) for i in 2:length(gd)]
f8=[quantile(gd[i].infected_presymptomatic_status,0.5) for i in 2:length(gd)]
n8=[quantile(gd[i].infected_presymptomatic_status,0.95) for i in 2:length(gd)]
# Ensemble of symptomatic infected
m9=[quantile(gd[i].infected_symptomatic_status,0.05) for i in 2:length(gd)]
f9=[quantile(gd[i].infected_symptomatic_status,0.5) for i in 2:length(gd)]
n9=[quantile(gd[i].infected_symptomatic_status,0.95) for i in 2:length(gd)]
# Ensemble of asymptomatic infected
m10=[quantile(gd[i].infected_asymptomatic_status,0.05) for i in 2:length(gd)]
f10=[quantile(gd[i].infected_asymptomatic_status,0.5) for i in 2:length(gd)]
n10=[quantile(gd[i].infected_asymptomatic_status,0.95) for i in 2:length(gd)]

plot(timestep, m8,
	label="Pre-Symptomatic",
	xlab="Time",
	ylabel="Number",
	title="Agent-Based Metapopulation SEIIRD",
	legend=:topright,
	lw=2.5;
	ribbon=[m8-f8,n8-m8],
    fillalpha=0.3)
plot!(timestep, m9,label="Symptomatic",lw=2.5; ribbon=[m9-f9,n9-m9],fillalpha=0.3)
plot!(timestep, m10,label="Asymptomatic",lw=2.5; ribbon=[m10-f10,n10-m10],fillalpha=0.3)
