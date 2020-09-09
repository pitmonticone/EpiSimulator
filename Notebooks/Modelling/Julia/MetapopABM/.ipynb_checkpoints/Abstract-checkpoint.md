<!-- Title -->
<h1 align="center">
  Digital Epidemiology Project
</h1>

<!-- Subtitle -->
<h2 align="center">
   Data-Driven Stochastic Agent-Based Metapopulation Model
</h2>

<h2 align="center">
  Authors
</h2>

| Name  | Mail | GitHub | Twitter | Contributions |
| :---- | :---- | :---- | :---- | :---- |
| Pietro Monticone | [pietro.monticone@edu.unito.it](pietro.monticone@edu.unito.it) | [@pitmonticone](https://github.com/pitmonticone) | [@PietroMonticone](https://github.com/pitmonticone) | Geospatial data exploration, selection and processing | 
|  |  |  |  | Contact data exploration, selection and processing |
|  |  |  |  | Mobility data exploration, selection and processing |
|  |  |  |  | Epidemiological data exploration, selection and processing | 
|  |  |  |  | Policy data exploration, selection and processing | 
|  |  |  |  | Age-specific IFR calibration |
|  |  |  |  | Surveillance module design and implementation |
| Davide Orsenigo | [davide.orsenigo@edu.unito.it](davide.orsenigo@edu.unito.it) | [@daorse](https://github.com/daorse) | [@DavideOrsenigo](https://twitter.com/DavideOrsenigo) | Population data exploration, selection and processing | 
|  |  |  |  | Diagnostic data exploration, selection and processing |
|  |  |  |  | Age-specific symptomatic fraction calibration |
|  |  |  |  | Inter-compartment transition delays calibration |

<h2 align="center">
  Computational Framework
</h2> 

| Language  | Activities |
| :---- | :---- |
| [Python](https://www.python.org/) | Data collection | 
| | Data wrangling | 
|  | Data visualization | 
| [Julia](https://julialang.org) | Modelling | 
|  | Scenario Analysis | 

<h2 align="center">
  Parameters
</h2> 

| Name | Value | Description | References | 
| :---- | :---- | :---- | :---- | 
| $y$ | `age_group` $\in [1,6]$ | Category of "young" age groups |  | 
| $m$ | `age_group` $\in [7,12]$ | Category of "middle" age groups |  | 
| $o$ | `age_group` $\in [13,16]$ | Category of "old" age groups |  | 
|  |  |  |  | 
| $s_y$ | $$\sim \mathcal{N}(\mu=0.5,\sigma=0.1;[0,0.5])$$ | Symptomatic fraction on infection for "young" age groups|  
| $s_m$ | $0.5$ | Symptomatic fraction on infection  for "middle" age groups|  | 
| $s_o$ | $\sim \mathcal{N}(\mu=0.5,\sigma=0.1;[0.5,1])$ | Symptomatic fraction on infection for "old" age groups |  |
|  |  |  |  |
| $d_E$ | $\sim \mathcal{\Gamma}(\mu=3,k=4)$ | Incubation period |  |
| $d_P$ | $\sim \mathcal{\Gamma}(\mu=1.5,k=4)$ | Duration of infectiousness in days during the pre-symptomatic phase |  |
| $d_A$ | $\sim \mathcal{\Gamma}(\mu=3.5,k=4)$ | Duration of infectiousness in days during the a-symptomatic phase |  |
| $d_S$ | $\sim \mathcal{\Gamma}(\mu=5,k=4)$ | Duration of infectiousness in days during the symptomatic phase |  |

<h2 align="center">
  Diagnostic Strategies
</h2> 

| Role | Region | Priority | Distribution | Contact-Tracing | 
| :---- | :---- | :---- | :---- | :---- |
| Passive | National | Random | Uniform | No |
|  |  |  |  | Yes |
|  |  | Targeted | Age-based / Ex-Ante IFR | No |
|  |  |  | | Yes |
|  |  |  | Symptom-based / Ex-Post IFR | No |
|  |  |  | | Yes |
|  | Provincial | Random | Uniform | No |
|  |  |  |  | Yes |
|  |  | Targeted | Age-based / Ex-Ante IFR | No |
|  |  |  | | Yes |
|  |  |  | Symptom-based / Ex-Post IFR | No |
|  |  |  | | Yes |
| Active | National | Random | Uniform | No |
|  |  |  |  | Yes |
|  |  | Targeted | Age-based / Ex-Ante IFR | No |
|  |  |  | | Yes |
|  |  |  | Symptom-based / Ex-Post IFR | No |
|  |  |  | | Yes |
|  | Provincial | Random | Uniform | No |
|  |  |  |  | Yes |
|  |  | Targeted | Age-based / Ex-Ante IFR | No |
|  |  |  | | Yes |
|  |  |  | Symptom-based / Ex-Post IFR | No |
|  |  |  | | Yes |

* All the above with behavioral module: endogenous, individual-based physical distancing (local and global)
* All the above with behavioral module: exogeneous, enforced physical distancing (local and global lockdown)
* **Special one**: Active, provincial, targeted, symptom-based, symptomatic-is-positive, contact-tracing, endogenous & exogenous distancing: assume all symptomatic patients to be **positive** ($I_s$) without testing them (accepting the uncertainty of the symptom-based MD diagnosis) in order to allocate more diagnostic resources to the active surveillance of exposed, asymptomatic, vulnerable patients.

## Desiderata
1. Design compartmental diagram for epidemic ($\alpha_X$, $d_X$, $\beta_X(age)$,...) and surveillance systems  ($O,N,P,H/W,R$)
1. Implement timeline of policy interventions
1. Import real COVID-19 data for Italy (tests, lockdown_mobility,...)
1. Implement contact-tracing app and centrality-based passive and active surveillance strategies

## Age-Specific Distributions 
* Susceptibility to infection upon contact with an infectious person $\mathcal{N}(\mu=0.1,\sigma=0.023, min=0)$ 