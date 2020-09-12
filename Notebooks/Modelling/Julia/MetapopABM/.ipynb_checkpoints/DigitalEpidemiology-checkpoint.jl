# DIGITAL EPIDEMIOLOGY JULIA PACKAGE 
# LAST UPDATE: 11-09-2020

###########################################
################ AUTHORS ##################
###########################################
# PIETRO MONTICONE 
# DAVIDE ORSENIGO 


module DigitalEpidemiology

###################################
######## REQUIRED PACKAGES ########
###################################

using DataFrames, DataFramesMeta, DrWatson, Queryverse       # Data Management 
using StatsBase, Distributions, Random                       # Statistics 
using LightGraphs, SimpleWeightedGraphs, GraphIO, GraphPlot  # Graphs
using Agents                                                 # Modelling 
using LinearAlgebra                                          # Numerical Computation
using LinearAlgebra                                          # Parallel Computation
using Plots, AgentsPlots, PlotThemes, Images, ImageIO        # Visualization

#####################################
######### DATA COLLECTION ###########
#####################################

function LoadData(file, user)
    # POPULATION
    ### Load population dataset
    if file=="ProvincialPopulation"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Population/ProvincialPopulation.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/Population/ProvincialPopulation.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\2020\Population\ProvincialPopulation.csv"))
        end
    ### Load age-stratified population dataset
    elseif file=="AgeStratifiedProvincialPopulation"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Population/AgeStratifiedProvincialPopulation.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/Population/AgeStratifiedProvincialPopulation.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\2020\Population\AgeStratifiedProvincialPopulation.csv"))
        end
    # CONTACT
    ### Load contact data for all locations
    elseif file=="AllEdgeList"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/AllEdgeList.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/AllEdgeList.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\ContactMatrices\AllEdgeList.csv"))
        end
    ### Load contact data for home 
    elseif file=="HomeEdgeList"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/HomeEdgeList.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/HomeEdgeList.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\ContactMatrices\HomeEdgeList.csv"))
        end
    ### Load contact data for work 
    elseif file=="WorkEdgeList"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/WorkEdgeList.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/WorkEdgeList.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\ContactMatrices\WorkEdgeList.csv"))
        end
    ### Load contact data for school 
    elseif file=="SchoolEdgeList"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/SchoolEdgeList.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/SchoolEdgeList.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\ContactMatrices\SchoolEdgeList.csv"))
        end
    ### Load contact data for other locations
    elseif file=="OtherEdgeList"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/OtherEdgeList.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/ContactMatrices/OtherEdgeList.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\ContactMatrices\OtherEdgeList.csv"))
        end
    # MOBILITY
    ### Load mobility data
    elseif file=="Flow1"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow1.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow1.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\2020\Mobility\Flow1.csv"))
        end
    elseif file=="Flow2"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow2.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow2.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\2020\Mobility\Flow2.csv"))
        end
    elseif file=="Flow3"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow3.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow3.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\2020\Mobility\Flow3.csv"))
        end
    elseif file=="Flow4"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow4.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/2020/Mobility/Flow4.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\2020\Mobility\Flow4.csv"))
        end
    # EPIDEMIOLOGY
    ### Load data on confirmed COVID-19 active cases
    elseif file=="Active"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Epidemiological/Active.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/Epidemiological/Active.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\Epidemiological\Active.csv"))
        end
    ### Load data on confirmed COVID-19 cases by date of diagnosis and symptoms onset
    elseif file=="SymptomsDiagnosis"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Epidemiological/SymptomsDiagnosis.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/Epidemiological/SymptomsDiagnosis.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\Epidemiological\SymptomsDiagnosis.csv"))
        end
    ### Load data on COVID-19 tests and tested patients
    elseif file=="Tests"
        if user=="PietroMonticone1"
            return DataFrame(load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Epidemiological/Tests.csv"))
        elseif user=="PietroMonticone2"
            return DataFrame(load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Data/CSV/Epidemiological/Tests.csv"))
        elseif user=="DavideOrsenigo"
            return DataFrame(load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Data\CSV\Epidemiological\Tests.csv"))
        end
    end
end

######################################
######### IMAGE COLLECTION ###########
######################################

function LoadImage(file, user)
    # POPULATION
    ### Load population pyramid image
    if file=="PopulationPyramid"
        if user=="PietroMonticone1"
            return Images.load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Images/PopulationPyramid.png")
        elseif user=="PietroMonticone2"
            return Images.load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Images/PopulationPyramid.png")
        elseif user=="DavideOrsenigo"
            return Images.load(raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Images\PopulationPyramid.png")
        end
    # CONTACT
    ### Load contact matrix plot for all locations
    elseif file=="All"
        if user=="PietroMonticone1"
            return Images.load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Images/Contact/All.png")
        elseif user=="PietroMonticone2"
            return Images.load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Images/Contact/All.png")
        elseif user=="DavideOrsenigo"
            return Images.load( raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Images\Contact\All.png")
        end
    ### Load contact matrix plot for home
    elseif file=="Home"
        if user=="PietroMonticone1"
            return Images.load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Images/Contact/Home.png")
        elseif user=="PietroMonticone2"
            return Images.load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Images/Contact/Home.png")
        elseif user=="DavideOrsenigo"
            return Images.load( raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Images\Contact\Home.png")
        end
    ### Load contact matrix plot for work
    elseif file=="Work"
        if user=="PietroMonticone1"
            return Images.load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Images/Contact/Work.png")
        elseif user=="PietroMonticone2"
            return Images.load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Images/Contact/Work.png")
        elseif user=="DavideOrsenigo"
            return Images.load( raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Images\Contact\Work.png")
        end
    ### Load contact matrix plot for school
    elseif file=="School"
        if user=="PietroMonticone1"
            return Images.load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Images/Contact/School.png")
        elseif user=="PietroMonticone2"
            return Images.load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Images/Contact/School.png")
        elseif user=="DavideOrsenigo"
            return Images.load( raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Images\Contact\School.png")
        end
    ### Load contact matrix plot for other locations
    elseif file=="Other"
        if user=="PietroMonticone1"
            return Images.load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Images/Contact/Other.png")
        elseif user=="PietroMonticone2"
            return Images.load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Images/Contact/Other.png")
        elseif user=="DavideOrsenigo"
            return Images.load( raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Images\Contact\Other.png")
        end
    # MOBILITY 
    ### Load mobility images
    elseif file=="Phase1"
        if user=="PietroMonticone1"
            return Images.load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Images/Mobility/Phase1.png")
        elseif user=="PietroMonticone2"
            return Images.load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Images/Mobility/Phase1.png")
        elseif user=="DavideOrsenigo"
            return Images.load( raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Images\Mobility\Phase1.png")
        end
    elseif file=="Phase2"
        if user=="PietroMonticone1"
            return Images.load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Images/Mobility/Phase2.png")
        elseif user=="PietroMonticone2"
            return Images.load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Images/Mobility/Phase2.png")
        elseif user=="DavideOrsenigo"
            return Images.load( raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Images\Mobility\Phase2.png")
        end
    elseif file=="Phase3"
        if user=="PietroMonticone1"
            return Images.load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Images/Mobility/Phase3.png")
        elseif user=="PietroMonticone2"
            return Images.load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Images/Mobility/Phase3.png")
        elseif user=="DavideOrsenigo"
            return Images.load( raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Images\Mobility\Phase3.png")
        end
    elseif file=="Phase4"
        if user=="PietroMonticone1"
            return Images.load("/Users/Pit/GitHub/DigitalEpidemiologyProject/Images/Mobility/Phase4.png")
        elseif user=="PietroMonticone2"
            return Images.load("/Users/pietromonticone/github/DigitalEpidemiologyProject/Images/Mobility/Phase4.png")
        elseif user=="DavideOrsenigo"
            return Images.load( raw"C:\Users\Utente\Desktop\Progetti\GitHub\DigitalEpidemiologyProject\Images\Mobility\Phase4.png")
        end
    end
end

###############################
######### UTILITIES ###########
###############################

## Truncated normal distribution
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
## Symptomatic fraction on infection | Davies et al. (2020)
function SymptomaticFraction(age_group)
    if age_group ≤ 6
        return TruncatedNormal(0.5,0.1,0,0.5)
    elseif age_group ≤ 12
        return 0.5
    else
        return TruncatedNormal(0.5,0.1,0.5,1)
    end
end
## Infection fatality ratio/risk | Poletti et al. (2020)
function IFR(age_group) 
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
## Diagnostic rates | Kucirka et al. (2020) | LOOK FOR OTHER REFERENCES (ALREADY FOUND!!)
function DiagnosticRate(status, request)
    false_negative_rate=0
    #false_positive_rate=0
    if status==:E
        false_negative_rate=(0.67+1)/2
        #false_positive_rate=0.06
    elseif status==:I_s || status==:I_a
        false_negative_rate=(0.38+0.20)/2
        #false_positive_rate=0.02
    elseif status==:I_p
        false_negative_rate=(0.67+0.38)/2
        #false_positive_rate=0.04
    end
    if request == "false_negative_rate"
        return false_negative_rate
    end
    #else
        #return false_positive_rate
    #end
end
## Household initialization
function InitializeHousehold(agent, model)
    #length(agent.household) != 0 && return
    agents=get_node_agents(agent.residence, model)
    neighbors=[a for a in agents if a != agent]
    for age_group in 1:model.K
        aged_neighbors = [neighbor.id for neighbor in neighbors if neighbor.age_group == age_group]      
        ncontacts = round(Int, LightGraphs.weights(model.home_contact_graph)[age_group, agent.age_group]) 
        if length(aged_neighbors)>0 && ncontacts>0
            push!(agent.household, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
        end
    end
    agent.household = [(agent.household...)...] 
end;
#= More complex household initialization
function InitializeHousehold(agent, model)
    length(agent.household) != 0 && return
    neighbors=get_node_agents(agent.residence, model)
    neighbors_without_household = [neighbor for neighbor in agents if neighbor != agent && length(neighbor.household) == 0]
    neighbors_with_household = [neighbor for neighbor in agents if neighbor != agent && length(neighbor.household) != 0]
    
    if length(neighbors_without_household) > 0
        contacted_agents = []
        for age_group in 1:model.K
            aged_neighbors = [neighbor for neighbor in neighbors if neighbor.age_group == age_group]  
            ncontacts = round(Int, LightGraphs.weights(model.home_contact_graph)[age_group, agent.age_group]) 
            if length(aged_neighbors)>0 && ncontacts>0
                push!(contacted_agents, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
            end
        end
        #contacted_agents = [(contacted_agents...)...] 
        return [(contacted_agents...)...] 
    else
        agent.housrand(neighbors_with_household).household
    end
end=#

## Workplace initialization
function InitializeWorkplace(agent, model)
    #length(agent.workplace) != 0 && return
    agents=get_node_agents(agent.pos, model)
    neighbors=[a for a in agents if a != agent]
    for age_group in 1:model.K
        aged_neighbors = [neighbor.id for neighbor in neighbors if neighbor.age_group == age_group]      
        ncontacts = round(Int, LightGraphs.weights(model.work_contact_graph)[age_group, agent.age_group]) 
        if length(aged_neighbors)>0 && ncontacts>0
            push!(agent.workplace, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
        end
    end
    agent.workplace = [(agent.workplace...)...] 
end;
#= More complex workplace initialization
function InitializeWorkplace(agent, model)
    length(agent.workplace) != 0 && return
    agents=get_node_agents(agent.pos, model)
    neighbors = [neighbor for neighbor in agents if neighbor != agent && length(neighbor.workplace) == 0] # WARNING: STRONG ASSUMPTION!
    contacted_agents = []
    for age_group in 1:model.K
        aged_neighbors = [neighbor for neighbor in neighbors if neighbor.age_group == age_group]  
        ncontacts = round(Int, LightGraphs.weights(model.work_contact_graph)[age_group, agent.age_group]) 
        if length(aged_neighbors)>0 && ncontacts>0
                push!(contacted_agents, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
        end
    end
    #contacted_agents = [(contacted_agents...)...] 
    return [(contacted_agents...)...] 
end;=#

####################################
########## SURVEILLANCE ############
####################################

susceptible(status) = count(i == :S for i in status)
exposed(status) = count(i == :E for i in status)
infected_presymptomatic(status) = count(i == :I_p for i in status)
infected_symptomatic(status) = count(i == :I_s for i in status)
infected_asymptomatic(status) = count(i == :I_a for i in status)
infected(status) =exposed(status)+infected_asymptomatic(status)+infected_presymptomatic(status)+infected_symptomatic(status)
# ACTIVE
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

####################################
######### MACRO-DYNAMICS ###########
####################################

# DIAGNOSTIC (CALIBRATE MEMORY WITH KNOWLEDGE OF AVG. DELAY)
function test!(model, strategy)
    model.capacity_array[model.t] == 0 && return
    
	agents = [agent for agent in allagents(model) if agent.status!=:D && agent.diagnosis!=:HR]
	provinces = 1:model.M
	prov_populations = model.provincial_pops

	prov_capacities = round.(Int, prov_populations./sum(prov_populations) * capacity)
	prov_agents = [[agent for agent in agents if agent.residence == i] for i in provinces]
	
	if strategy == "base_passive_random_uniform_national"
		for agent in StatsBase.sample(agents, capacity)
			if agent.status==:S || agent.status==:R
				if rand() ≤ 0.95  #specificity
					agent.diagnosis=:N
				else 
					agent.diagnosis=:P
				end
			elseif agent.status!=:S && agent.status!=:R
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate") #sensitivity
					agent.diagnosis=:P
				else 
					agent.diagnosis=:N
				end
			end
		end
		
	elseif strategy == "passive_random_uniform_national"
        pos=[agent for agent in agents if agent.diagnosis==:P && agent.diagnosis_delay_left==0] #:W
		npos=[agent for agent in agents if agent.diagnosis!=:P]
		pos=pos[randperm(length(pos))]
		npos=npos[randperm(length(npos))]
        ags=npos
        if rand() ≤ 0.4 
            ags = vcat(pos,npos)
        end
		for agent in ags[1:capacity] ###StatsBase.sample(agents, capacity)
			if (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status == :S || agent.status == :R)
				if rand() ≤ 0.95
					agent.diagnosis=:N
				else 
					agent.diagnosis=:P
                    agent.diagnosis_delay_left=14 # TRY INFECTIOUSNESS PERIOD GAMMA(MU,K)
				end
			elseif (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status !=:S && agent.status !=:R) 
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate") #sensitivity
					agent.diagnosis=:P
                    agent.diagnosis_delay_left=14
				else 
					agent.diagnosis=:N
				end
			elseif agent.diagnosis==:P && (agent.status == :S || agent.status == :R)
				if rand() ≤ 0.95
					agent.diagnosis=:HR
				else 
					agent.diagnosis=:P
                    agent.diagnosis_delay_left=14
				end
			elseif agent.diagnosis==:P && (agent.status !=:S && agent.status !=:R) 
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate") #sensitivity
					agent.diagnosis=:P
                    agent.diagnosis_delay_left=14
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
				elseif (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status !=:S && agent.status !=:R) 
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate") #sensitivity
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
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate") #sensitivity
						agent.diagnosis=:P
					else 
						agent.diagnosis=:HR
					end
				end
			end
		end
	elseif strategy == "passive_biased_symptoms_national"
			pos=[agent for agent in agents if agent.diagnosis==:P && agent.diagnosis_delay_left==0]
			syms=[agent for agent in agents if agent.diagnosis!=:P && agent.status==:I_s]
			nsyms=[agent for agent in agents if agent.diagnosis!=:P && agent.status !=:I_s]
			pos=pos[randperm(length(pos))]
			syms=syms[randperm(length(syms))]
			nsyms=nsyms[randperm(length(nsyms))]
            posyms=vcat(pos,syms)
            posyms=posyms[randperm(length(posyms))]
			ags = vcat(posyms,nsyms)
		for agent in ags[1:capacity]
			if (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status == :S || agent.status == :R)
				if rand() ≤ 0.95
					agent.diagnosis=:N
				else 
					agent.diagnosis=:P
                    agent.diagnosis_delay_left=14
				end
			elseif (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status!=:S && agent.status!=:R) 
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate") #sensitivity
					agent.diagnosis=:P
                    agent.diagnosis_delay_left=14
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
				if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate") #sensitivity
					agent.diagnosis=:P
				else 
					agent.diagnosis=:HR
				end
			end
		end
	elseif strategy == "passive_biased_symptoms_provincial"
		for prov in provinces
			pos=[agent for agent in prov_agents[prov] if agent.diagnosis==:P && agent.diagnosis_delay_left==0]
			syms=[agent for agent in prov_agents[prov] if agent.diagnosis!=:P && agent.status==:I_s]
			nsyms=[agent for agent in prov_agents[prov] if agent.diagnosis!=:P && agent.status!=:I_s]
			pos=pos[randperm(length(pos))]
            syms=syms[randperm(length(syms))]
            nsyms=nsyms[randperm(length(nsyms))]
			posyms=vcat(pos,syms)
            posyms=posyms[randperm(length(posyms))]
			ags = vcat(posyms,nsyms)
			for agent in ags[1:prov_capacities[prov]]
				if (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status == :S || agent.status == :R)
					if rand() ≤ 0.95
						agent.diagnosis=:N
					else 
						agent.diagnosis=:P
                        agent.diagnosis_delay_left=14
					end
				elseif (agent.diagnosis==:O || agent.diagnosis==:N) && (agent.status!=:S && agent.status!=:R) 
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate") #sensitivity
						agent.diagnosis=:P
                        agent.diagnosis_delay_left=14
					else 
						agent.diagnosis=:N
					end
				elseif agent.diagnosis==:P && (agent.status == :S || agent.status == :R)
					if rand() ≤ 0.95
						agent.diagnosis=:HR
					else 
						agent.diagnosis=:P
                        agent.diagnosis_delay_left=14
					end
				elseif agent.diagnosis==:P && (agent.status!=:S && agent.status!=:R) 
					if rand() ≤ 1-DiagnosticRate(agent.status,"false_negative_rate") #sensitivity
						agent.diagnosis=:P
                        agent.diagnosis_delay_left=14
					else 
						agent.diagnosis=:HR
					end
				end
			end
		end
	end
end;

# POLICY SCENARIOS 

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


####################################
######### MICRO-DYNAMICS ###########
####################################

# CONTACT | Put reference here !!
function contact!(agent, model, location)
	amplification = 1
    #age_amplification = fill(1,model.K)
    agents=get_node_agents(agent.pos, model)
    neighbors=[n for n in agents if n != agent && n.status !=:D] 
	### @ Home
    if location=="home" 
        possible_contacted_agents=[a for a in neighbors if a.id in agent.household]
        effective_contacted_agents=[]
        if model.phase == 3
            amplification=1.3
			#age_amplification= vcat(fill(1.5,4),fill(1.1,model.K-4)) # Davies et al.(2020)
            ncontacts = round(Int, amplification*length(possible_contacted_agents))
            # Think about DiscreteNonParametric
            if ncontacts>0
                push!(effective_contacted_agents, StatsBase.sample(possible_contacted_agents, ncontacts; replace=true, ordered=false))
            end
            effective_contacted_agents=[(effective_contacted_agents...)...] 
            return effective_contacted_agents
        else 
            return possible_contacted_agents
        end
    ### @ Work   
	elseif location=="work"
		if model.phase == 3
			amplification=0.3
        end
        contacted_agents = []
        for age_group in 1:model.K
            aged_neighbors = [neighbor for neighbor in neighbors if neighbor.age_group == age_group && neighbor.diagnosis !=:P]  # Total isolation of positives
            ncontacts = round(Int, amplification*LightGraphs.weights(model.work_contact_graph)[age_group, agent.age_group]) # in
            if length(aged_neighbors)>0 && ncontacts>0
                push!(contacted_agents, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
            end
        end
        contacted_agents = [(contacted_agents...)...] 
        return contacted_agents
    ### @ School    
	elseif location=="school"
        contacted_agents = []
        for age_group in 1:model.K
            aged_neighbors = [neighbor for neighbor in neighbors if neighbor.age_group == age_group && neighbor.diagnosis !=:P]  # Total isolation of positives
            ncontacts = round(Int, amplification*LightGraphs.weights(model.school_contact_graph)[age_group, agent.age_group]) # in
            if length(aged_neighbors)>0 && ncontacts>0
                push!(contacted_agents, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
            end
        end
        contacted_agents = [(contacted_agents...)...] 
        return contacted_agents
    ### @ Other Locations     
	elseif location=="other"
		if model.phase == 3
			amplification=0.4
		end
        contacted_agents = []
        for age_group in 1:model.K
            aged_neighbors = [neighbor for neighbor in neighbors if neighbor.age_group == age_group && neighbor.diagnosis !=:P]  # Total isolation of positives
            ncontacts = round(Int, amplification*LightGraphs.weights(model.other_contact_graph)[age_group, agent.age_group]) # in
            if length(aged_neighbors)>0 && ncontacts>0
                push!(contacted_agents, StatsBase.sample(aged_neighbors, ncontacts; replace=true, ordered=false))
            end
        end
        contacted_agents = [(contacted_agents...)...] 
        return contacted_agents
	end
end

# MOBILITY
### Out-residence flow
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
    distribution = DiscreteNonParametric(1:model.M,targets./sum(targets))
	target = rand(distribution)
	if target ≠ source
		agent.pos = target #move_agent!(agent, target, model)
	end
end
### In-residence flow
function move_back_home!(agent, model)
    agent.pos == agent.residence && return
    if rand() ≤ model.h 
        agent.pos = agent.residence 
    end
end

# EXPOSURE
function get_exposed!(agent, model, contacted_agents)
	agent.status!=:S && return
	(typeof(contacted_agents)==Nothing || length(contacted_agents)==0) && return
	
	neighbors = contacted_agents
	for neighbor in neighbors 
        if neighbor.status == :I_s && (rand() ≤ TruncatedNormal(0.5,0.1,0,0.5))
			agent.status = :E
			agent.status_delay_left = round(Int, rand(Gamma(3,4)))
			break
		elseif neighbor.status == :I_p && (rand() ≤ 0.15*TruncatedNormal(0.5,0.1,0,0.5)) # Aleta et al.(2020)
			agent.status = :E
			agent.status_delay_left = round(Int, rand(Gamma(3,4)))
			break
		elseif neighbor.status == :I_a && (rand() ≤ TruncatedNormal(0.5,0.1,0,0.5)/2)
			agent.status = :E
			agent.status_delay_left = round(Int, rand(Gamma(3,4)))
			break
		end
	end
end

# INFECTION
function get_infected!(agent, model)
	# If I'm not susceptible, I return
	(agent.status!=:E || agent.status_delay_left !=0) && return
		
	if rand() ≤ SymptomaticFraction(agent.age_group)
		agent.status = :I_p 
		agent.status_delay_left = round(Int, rand(Gamma(1.5,4))) # 2.1 | Davies et al. (2020)
	else
		agent.status = :I_a
		agent.status_delay_left = round(Int, rand(Gamma(5,4)))
	end
end

# SYMPTOMS ONSET
function get_symptoms!(agent, model)
	# If I'm not susceptible, I return
	(agent.status!=:I_p || agent.status_delay_left !=0) && return
	agent.status = :I_s
	agent.status_delay_left = round(Int, rand(Gamma(3.5,4))) # 2.9 | Davies et al. (2020)
end

# RECOVERY
function recover_or_die!(agent, model)
	((agent.status!=:I_s && agent.status!=:I_a)||agent.status_delay_left != 0) && return
	# eventually include DOF
	if rand() ≤ IFR(agent.age_group) && agent.status==:I_s
		agent.status=:D
	else
		agent.status=:R
	end
end;

#############################
######## END MODULE #########
#############################
end 