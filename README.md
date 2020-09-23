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
|  |  | Inter-compartmental transition delays calibration |
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
| *y* | 0-29 (1-6) | Range of "young" age groups | [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) | 
| *m* | 30-59 (7-12) | Range of "middle" age groups | [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) | 
| *o* | 60-80 (13-16) | Range of "old" age groups | [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) | 
|  |  |  |  | 
| *f_y* | 𝒩(μ=0.5,σ=0.1;[0,0.5]) | Symptomatic fraction on infection for "young" age groups| [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) |
| *f_m* | 0.5 | Symptomatic fraction on infection  for "middle" age groups| [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) | 
| *f_o* | 𝒩(μ=0.1,σ=0.023;[0.5,1]) | Symptomatic fraction on infection for "old" age groups | [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) |
|  |  |  |  |
| *s* | 𝒩(μ=0.5,σ=0.1;[0,+∞]) |Susceptibility to infection upon contact with infectious person | [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) |
|  |  |  |  |
| *d_E* | Γ(μ=3,k=4) | Incubation period | [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) |
| *d_P* | Γ(μ=1.5,k=4) | Duration of infectiousness in days during the pre-symptomatic phase | [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) |
| *d_A* | Γ(μ=3.5,k=4) | Duration of infectiousness in days during the a-symptomatic phase | [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) |
| *d_S* | Γ(μ=5,k=4) | Duration of infectiousness in days during the symptomatic phase | [Davies et al. (2020)](https://doi.org/10.1038/s41591-020-0962-9) |
|  |  |  |  |
| IFR(0,50) | 0 |  Infection fatality ratio for the 0-50 age group | [Poletti et al. (2020)](https://doi.org/10.2807/1560-7917.ES.2020.25.31.2001383) |
| IFR(50,60) | 0.46 | Infection fatality ratio for the 50-60 age group | [Poletti et al. (2020)](https://doi.org/10.2807/1560-7917.ES.2020.25.31.2001383) |
| IFR(60,70) | 1.42 | Infection fatality ratio for the 60-70 age group | [Poletti et al. (2020)](https://doi.org/10.2807/1560-7917.ES.2020.25.31.2001383) |
| IFR(70,80) | 6.87 | Infection fatality ratio for the 60-70 age group | [Poletti et al. (2020)](https://doi.org/10.2807/1560-7917.ES.2020.25.31.2001383) |
|  |  |  |  |
| FNR_S | *mean*(0.20,0.38) | False negative rate in symptomatic phase | [Kucirka et al. (2020)](https://doi.org/10.7326/M20-1495) |
| FNR_P | *mean*(0.38,0.67) | False negative rate in pre-symptomatic phase | [Kucirka et al. (2020)](https://doi.org/10.7326/M20-1495) |
| FNR_E | *mean*(0.67,1) | False negative rate in incubation phase | [Kucirka et al. (2020)](https://doi.org/10.7326/M20-1495) |

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
