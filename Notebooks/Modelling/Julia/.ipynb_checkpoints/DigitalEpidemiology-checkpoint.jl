# DIGITAL EPIDEMIOLOGY JULIA PACKAGE 
# AUTHORS: Monticone Pietro, Orsenigo Davide 
# LAST UPDATE: 03-09-2020

module DigitalEpidemiology
export test!

# REQUIRED PACKAGES 

using DataFrames, DataFramesMeta, DrWatson, Queryverse    # Data Management 
using Random, Distributions, StatsBase             # Statistics
using LightGraphs, SimpleWeightedGraphs, GraphIO   # Graphs 
using GraphPlot, Plots, AgentsPlots, PlotThemes    # Data Visualization
using LinearAlgebra                                # Numerical Computation

# MACRO
### Diagnosis Dyanmics
	
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

end # Moudule