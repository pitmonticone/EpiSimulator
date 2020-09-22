<!-- Meta-Badges -->
</p>

<p align="center">
    <img alt="Size" src="https://img.shields.io/github/repo-size/InPhyT/DigitalEpidemiologyProject">
  </a>
  <img alt="Forks" src="https://img.shields.io/github/forks/InPhyT/DigitalEpidemiologyProject">
  </a>
  <img alt="Stars" src="https://img.shields.io/github/stars/InPhyT/DigitalEpidemiologyProject">
  </a>
  <img alt="Languages" src="https://img.shields.io/github/languages/count/InPhyT/DigitalEpidemiologyProject">
  </a>
  <a href="https://github.com/InPhyT/DigitalEpidemiologyProject/graphs/contributors">
    <img alt="Contributors" src="https://img.shields.io/github/contributors/InPhyT/DigitalEpidemiologyProject">
  </a>
  <img alt="Licence" src="https://img.shields.io/github/license/InPhyT/DigitalEpidemiologyProject">
  </a>
  <img alt="Twitter" src="https://img.shields.io/twitter/url?url=https%3A%2F%2Fgithub.com%2FInPhyT%2FDigitalEpidemiologyProject"
  </a>
  
</p>
<!-- Title -->
<h1 align="center">
  Digital Epidemiology Project
</h1>

<!-- Subtitle -->
<h2 align="center">
   A Data-Drive Stochastic Hybrid Model for Italy
</h2>

## Authors 

| Name | Contacts | Contribution | 
| :---- | :---- | :---- |
| Pietro Monticone | [Mail](pietro.monticone@edu.unito.it) | Geospatial data exploration, selection and processing | 
|  | [GitHub](https://github.com/pitmonticone) | Contact data exploration, selection and processing | 
|  | [Twitter](https://twitter.com/PietroMonticone) | Mobility data exploration, selection and processing | 
|  |  | Epidemiological data exploration, selection and processing | 
|  |  | Policy data exploration, selection and processing | 
|  |  | Age-specific IFR calibration |
|  |  | Epidemiological module design and implementation (50%)|
|  |  | Surveillance module design and implementation |
|  |  | Contact-tracing module design and implementation |
|  |  | Geospatial static and dynamic visualization of simulated data |
|  |  | `DigitalEpidemiology.jl` package development (50%) |
| Davide Orsenigo | [Mail](davide.orsenigo@edu.unito.it) | Population data exploration, selection and processing | 
|  | [GitHub](https://github.com/daorse) | Diagnostic data exploration, selection and processing | 
|  | [Twitter](https://twitter.com/DavideOrsenigo) | Age-specific symptomatic fraction calibration | 
|  |  | Inter-compartment transition delays calibration |
|  |  | Epidemiological module design and implementation (50%)|
|  |  | Contact-tracing static and dynamic visualization of simulated data |
|  |  | `DigitalEpidemiology.jl` package development (50%) |

## Computational Framework

| Language  | Activity |
| :---- | :---- |
| [Python](https://www.python.org/) | Data collection | 
| | Data wrangling | 
|  | Data visualization | 
| [Julia](https://julialang.org) | Modelling | 
|  | Scenario Analysis | 

## Parameters

| Name | Value | Description | References | 
| :---- | :---- | :---- | :---- | 
| $y$ | $[1,6]$ | Range of "young" age groups |  | 
| $m$ | $[7,12]$ | Range of "middle" age groups |  | 
| $o$ | $[13,16]$ | Range of "old" age groups |  | 
|  |  |  |  | 
| $s_y$ | $$\sim \mathcal{N}(\mu=0.5,\sigma=0.1;[0,0.5])$$ | Symptomatic fraction on infection for "young" age groups|  
| $s_m$ | $0.5$ | Symptomatic fraction on infection  for "middle" age groups|  | 
| $s_o$ | $\sim \mathcal{N}(\mu=0.5,\sigma=0.1;[0.5,1])$ | Symptomatic fraction on infection for "old" age groups |  |
|  |  |  |  |
| $d_E$ | $\sim \mathcal{\Gamma}(\mu=3,k=4)$ | Incubation period |  |
| $d_P$ | $\sim \mathcal{\Gamma}(\mu=1.5,k=4)$ | Duration of infectiousness in days during the pre-symptomatic phase |  |
| $d_A$ | $\sim \mathcal{\Gamma}(\mu=3.5,k=4)$ | Duration of infectiousness in days during the a-symptomatic phase |  |
| $d_S$ | $\sim \mathcal{\Gamma}(\mu=5,k=4)$ | Duration of infectiousness in days during the symptomatic phase |  |

## Diagnostic Strategies

| Role | Region | Priority | Distribution | Contact-Tracing | 
| :---- | :---- | :---- | :---- | :----: |
| Passive | National | Random | Uniform | No |
|  |  |  |  | Yes |
|  |  | Targeted | Centrality-based | Yes |
|  |  | Targeted | Age-based / Ex-Ante IFR | No |
|  |  |  | | Yes |
|  |  |  | Symptom-based / Ex-Post IFR | No |
|  |  |  | | Yes |
|  | Regional | Random | Uniform | No |
|  |  |  |  | Yes |
|  |  | Targeted | Centrality-based | Yes |
|  |  | Targeted | Age-based / Ex-Ante IFR | No |
|  |  |  | | Yes |
|  |  |  | Symptom-based / Ex-Post IFR | No |
|  |  |  | | Yes |
|  | Provincial | Random | Uniform | No |
|  |  |  |  | Yes |
|  |  | Targeted | Centrality-based | Yes |
|  |  | Targeted | Age-based / Ex-Ante IFR | No |
|  |  |  | | Yes |
|  |  |  | Symptom-based / Ex-Post IFR | No |
|  |  |  | | Yes |
| Active | National | Random | Uniform | No |
|  |  |  |  | Yes |
|  |  | Targeted | Centrality-based | Yes |
|  |  | Targeted | Age-based / Ex-Ante IFR | No |
|  |  |  | | Yes |
|  |  |  | Symptom-based / Ex-Post IFR | No |
|  |  |  | | Yes |
|  | Regional | Random | Uniform | No |
|  |  |  |  | Yes |
|  |  | Targeted | Centrality-based | Yes |
|  |  | Targeted | Age-based / Ex-Ante IFR | No |
|  |  |  | | Yes |
|  |  |  | Symptom-based / Ex-Post IFR | No |
|  |  |  | | Yes |
|  | Provincial | Random | Uniform | No |
|  |  |  |  | Yes |
|  |  | Targeted | Centrality-based | Yes |
|  |  | Targeted | Age-based / Ex-Ante IFR | No |
|  |  |  | | Yes |
|  |  |  | Symptom-based / Ex-Post IFR | No |
|  |  |  | | Yes |

* All the above with behavioral module: endogenous, individual-based physical distancing (local and global)
* All the above with behavioral module: exogeneous, enforced physical distancing (local and global lockdown)
* **Special one**: Active, provincial, targeted, symptom-based, symptomatic-is-positive, contact-tracing, endogenous & exogenous distancing: assume all symptomatic patients to be **positive** ($I_s$) without testing them (accepting the uncertainty of the symptom-based MD diagnosis) in order to allocate more diagnostic resources to the active surveillance of exposed, asymptomatic, vulnerable patients.
