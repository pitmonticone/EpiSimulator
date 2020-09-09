<!-- Title -->
<h1 align="center">
  Digital Epidemiology Project
</h1>

<!-- Subtitle -->
<h2 align="center">
   Data-Driven Stochastic Agent-Based Metapopulation Model
</h2>

### Authors

| Name | Contacts | Contribution | 
| :---- | :---- | :---- |
| Pietro Monticone | [Mail](pietro.monticone@edu.unito.it) | Geospatial data exploration, selection and processing | 
|  | [GitHub](https://github.com/pitmonticone) | Contact data exploration, selection and processing | 
|  | [Twitter](https://twitter.com/PietroMonticone) | Mobility data exploration, selection and processing | 
|  |  | Epidemiological data exploration, selection and processing | 
|  |  | Policy data exploration, selection and processing | 
|  |  | Age-specific IFR calibration |
|  |  | Surveillance module design and implementation |
| Davide Orsenigo | [Mail](davide.orsenigo@edu.unito.it) | Population data exploration, selection and processing | 
|  | [GitHub](https://github.com/daorse) | Diagnostic data exploration, selection and processing | 
|  | [Twitter](https://twitter.com/DavideOrsenigo) | Age-specific symptomatic fraction calibration | 
|  |  | Inter-compartment transition delays calibration |

### Computational Framework

| Language  | Activities |
| :---- | :---- |
| [Python](https://www.python.org/) | Data collection | 
| | Data wrangling | 
|  | Data visualization | 
| [Julia](https://julialang.org) | Modelling | 
|  | Scenario Analysis | 

### Parameters

| Name | Value | Description | References | 
| :---- | :---- | :---- | :---- | 
| *y* | `age_group` in [1,6] | Category of "young" age groups |  | 
| *m*  | `age_group` in [7,12] | Category of "middle" age groups |  | 
| *o*  | `age_group` in [13,16] | Category of "old" age groups |  | 
|  |  |  |  | 
| *s_y* | *N(μ=0.5, σ=0.1; [0,0.5])* | Symptomatic fraction on infection for "young" age groups|  
| *s_m* | 0.5 | Symptomatic fraction on infection  for "middle" age groups|  | 
| *s_o* | *N(μ=0.5, σ=0.1; [0.5,1])* | Symptomatic fraction on infection for "old" age groups |  |
|  |  |  |  |
| *d_E* | *Γ(μ=3,k=4)* | Incubation period |  |
| *d_P* | *Γ(μ=1.5,k=4)* | Duration of infectiousness in days during the pre-symptomatic phase |  |
| *d_A* | *Γ(μ=3.5,k=4)* | Duration of infectiousness in days during the a-symptomatic phase |  |
| *d_S* | *Γ(μ=5,k=4)* | Duration of infectiousness in days during the symptomatic phase |  |

### Diagnostic Strategies

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
