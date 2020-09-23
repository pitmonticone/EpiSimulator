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

| Role | Scale | Priority | Distribution | Contact-Tracing | 
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

## References 

### Data
#### Geospatial
* ISTAT, [Confini delle unità amministrative a fini statistici al 1° Gennaio 2020](https://www.istat.it/it/archivio/222527). (2020)
* OpenPolis. [Limits of Italian Provinces](https://github.com/openpolis/geojson-italy/blob/master/geojson/limits_IT_provinces.geojson). *GitHub* (2019)
#### Population
* ISTAT, [Resident Population by Sex, Age and Marital Status](http://demo.istat.it/pop2020/index_e.html) (2020).
* ISTAT, [Population census data](http://dati.istat.it/Index.aspx?QueryId=18460) (2020).
#### Social
* Mossong J, Hens N, Jit M, Beutels P, Auranen K, Mikolajczyk R, et al. (2008) [Social Contacts and Mixing Patterns Relevant to the Spread of Infectious Diseases](https://doi.org/10.1371/journal.pmed.0050074). *PLoS Med* 5(3): e74. 
* Prem K, Cook AR, Jit M (2017). [Projecting social contact matrices in 152 countries using contact surveys and demographic data](https://doi.org/10.1371/journal.pcbi.1005697). *PLoS Comput Biol* 13(9).
* Kiesha Prem et al. (2020). [Projecting contact matrices in 177 geographical regions: an update and comparison with empirical data for the COVID-19 era](https://doi.org/10.1101/2020.07.22.20159772). *medRxiv pre-print*. 
#### Mobility 
* Pepe, E., Bajardi, P., Gauvin, L. et al. [COVID-19 outbreak response, a dataset to assess mobility changes in Italy following national lockdown](https://doi.org/10.1038/s41597-020-00575-2). *Scientific Data* 7, 230 (2020).
#### Diagnostic
* ECDC, [Diagnostic testing and screening for SARS-CoV-2](https://www.ecdc.europa.eu/en/covid-19/latest-evidence/diagnostic-testing), 2020
* ECDC, [Testing strategies](https://www.ecdc.europa.eu/en/covid-19/surveillance/testing-strategies), 2020
* European Commission (EC). [Current performance of COVID-19 test methods and devices and proposed performance criteria](https://ec.europa.eu/docsroom/documents/40805) (16 April 2020). Brussels: EC; [21 April, 2020]. 
* Jessica Watson et al. [Interpreting a covid-19 test result](https://doi.org/10.1136/bmj.m1808). *BMJ*, 2020.
* Edward C.Stites, Craig B.Wilen. [The Interpretation of SARS-CoV-2 Diagnostic Tests](https://doi.org/10.1016/j.medj.2020.08.001), *Med* (2020).
* Sethuraman N, Jeremiah SS, Ryo A. [Interpreting Diagnostic Tests for SARS-CoV-2](https://doi.org/10.1001/jama.2020.8259). *JAMA*. 2020;323(22):2249–2251.
* Diagnostics Committee of the Infectious Diseases Society of America (IDSA), [Molecular Testing for Acute Respiratory Tract Infections: Clinical and Diagnostic Recommendations From the IDSA’s Diagnostics Committee](https://doi.org/10.1093/cid/ciaa508), *Clinical Infectious Diseases*, , ciaa508
* [False Negative Tests for SARS-CoV-2 Infection — Challenges and Implications](https://doi.org/10.1056/NEJMp2015897) *N Engl J Med* 2020; 383:e38
* [Saliva or Nasopharyngeal Swab Specimens for Detection of SARS-CoV-2](https://doi.org/10.1056/NEJMc2016359) 
* Lisboa Bastos Mayara, Tavaziva Gamuchirai, Abidi Syed Kunal, Campbell Jonathon R, Haraoui Louis-Patrick, Johnston James C et al. [Diagnostic accuracy of serological tests for covid-19: systematic review and meta-analysis](https://doi.org/10.1136/bmj.m2516) *BMJ* 2020; 370 :m2516
* Kucirka, Lauren M., et al. [Variation in false-negative rate of reverse transcriptase polymerase chain reaction–based SARS-CoV-2 tests by time since exposure](https://doi.org/10.7326/M20-1495). *Annals of Internal Medicine* (2020).
* ISTAT, [First results of the SARS-CoV-2 seroprevalence study](https://www.istat.it/it/files//2020/08/ReportPrimiRisultatiIndagineSiero.pdf) (2020)
#### Epidemiological
* Our World in Data, [Data on COVID-19](https://github.com/owid/covid-19-data/tree/master/public/data).
* COVID-19 Routes, [Data Fetching for Italy](https://github.com/COVID-19-routes/data-model).
* PCM-DPC, [COVID-19 Data for Italy](https://github.com/pcm-dpc/COVID-19).
* ISS, [COVID-19 Integrated Surveillance](https://www.epicentro.iss.it/en/coronavirus/sars-cov-2-integrated-surveillance-data).
* Davies, N.G., Klepac, P., Liu, Y. et al. [Age-dependent effects in the transmission and control of COVID-19 epidemics](https://doi.org/10.1038/s41591-020-0962-9). *Nature Medicine* 26, 1205–1211 (2020). 
* Kiesha Prem et al. (2020). [Projecting contact matrices in 177 geographical regions: an update and comparison with empirical data for the COVID-19 era](https://doi.org/10.1101/2020.07.22.20159772). *medRxiv pre-print*. 
* Khalili, M., Karamouzian, M., Nasiri, N., Javadi, S., Mirzazadeh, A., & Sharifi, H. (2020). [Epidemiological characteristics of COVID-19: A systematic review and meta-analysis](https://doi.org/10.1017/S0950268820001430). *Epidemiology and Infection*, 148, E130. 
* Oxford University Clinical Research Unit COVID-19 Research Group, [The Natural History and Transmission Potential of Asymptomatic Severe Acute Respiratory Syndrome Coronavirus 2 Infection](https://doi.org/10.1093/cid/ciaa711), *Clinical Infectious Diseases*, ciaa711
* ISTAT, [First results of the SARS-CoV-2 seroprevalence study](https://www.istat.it/it/files//2020/08/ReportPrimiRisultatiIndagineSiero.pdf) (2020)
* Luca Ferretti et al. [The timing of COVID-19 transmission](https://doi.org/10.1101/2020.09.04.20188516). *medRxiv pre-print* (2020)
* Poletti Piero et al. [Age-specific SARS-CoV-2 infection fatality ratio and associated risk factors, Italy, February to April 2020](https://doi.org/10.2807/1560-7917.ES.2020.25.31.2001383). *Euro Surveill.* 2020;25(31):pii=2001383. 
* Poletti, Piero, et al. [Probability of symptoms and critical disease after SARS-CoV-2 infection](https://arxiv.org/abs/2006.08471). *arXiv pre-print* arXiv:2006.08471 (2020).
* Andrew T. Levin et al. [Assessing the Age Specificity of Infection Fatality Rates for COVID-19: Systematic Review, Meta-Analysis, and Public Policy Implications](https://doi.org/10.1101/2020.07.23.20160895). *medRxiv pre-print* (2020)
* Biggerstaff M, Cowling BJ, Cucunubá ZM, Dinh L, Ferguson NM, Gao H, et al., for the *WHO COVID-19 Modelling Parameters Group*. [Early insights from statistical and mathematical modeling of key epidemiologic parameters of COVID-19](https://doi.org/10.3201/eid2611.201074). *Emerg Infect Dis* (2020.
#### Policy 
* Desvars-Larrive, A., Dervic, E., Haug, N. et al. [A structured open dataset of government interventions in response to COVID-19](https://doi.org/10.1038/s41597-020-00609-9). *Scientific Data* 7, 285 (2020).
### Modelling
#### Conceptual
* Vespignani, A., Tian, H., Dye, C. et al. [Modelling COVID-19](https://doi.org/10.1038/s42254-020-0178-4). Nat Rev Phys 2, 279–281 (2020)
* Metcalf et al. [Mathematical models to guide pandemic response](https://doi.org/10.1126/science.abd1668). *Science Perspective* (2020).
* Ernesto Estrada. [COVID-19 and SARS-CoV-2. Modeling the present, looking at the future](https://doi.org/10.1016/j.physrep.2020.07.005). *Physics Reports* (2020).
* Bjørnstad, O.N., Shea, K., Krzywinski, M. et al. [The SEIRS model for infectious disease dynamics](https://doi.org/10.1038/s41592-020-0856-2). *Nature Methods* 17, 557–558 (2020). 
#### Metapopulation
* Alun Lloyd, Vincent Jansenc. [Spatiotemporal dynamics of epidemics: synchrony in metapopulation models](https://doi.org/10.1016/j.mbs.2003.09.003). *Mathematical Biosciences* (2004).
* Duncan J. Watts et al. [Multiscale, resurgent epidemics in a hierarchical metapopulation model](https://doi.org/10.1073/pnas.0501226102). *PNAS* (2005)
* Vittoria Colizza, Alessandro Vespignani. [Epidemic modeling in metapopulation systems with heterogeneous coupling pattern: Theory and simulations](https://doi.org/10.1016/j.jtbi.2007.11.028). *Journal of Theoretical Biology* (2008).
* Balcan, Duygu, Vittoria Colizza, Bruno Gonçalves, Hao Hu, José J. Ramasco, and Alessandro Vespignani. [Multiscale mobility networks and the spatial spreading of infectious diseases](https://doi.org/10.1073/pnas.0906910106). *Proceedings of the National Academy of Sciences* 106, no. 51 (2009): 21484-21489.
* Balcan, Duygu, Bruno Gonçalves, Hao Hu, José J. Ramasco, Vittoria Colizza, and Alessandro Vespignani. [Modeling the spatial spread of infectious diseases: The GLobal Epidemic and Mobility computational model](https://doi.org/10.1016/j.jocs.2010.07.002). *Journal of Computational Science* 1, no. 3 (2010): 132-145
* Ross JV, House T, Keeling MJ [Calculation of Disease Dynamics in a Population of Households](https://doi.org/10.1371/journal.pone.0009666). *PLoS ONE* (2010)
* Salathé M, Jones JH (2010) [Dynamics and Control of Diseases in Networks with Community Structure](https://doi.org/10.1371/journal.pcbi.1000736). *PLoS Comput Biol* 6(4): e1000736
* Apolloni, A., Poletto, C., Ramasco, J.J. et al. [Metapopulation epidemic models with heterogeneous mixing and travel behaviour](https://doi.org/10.1186/1742-4682-11-3). *Theor Biol Med Model* 11, 3 (2014)
* Daniela Calvetti et al. [Metapopulation Network Models for Understanding, Predicting, and Managing the Coronavirus Disease COVID-19](https://doi.org/10.3389/fphy.2020.00261). *Front. Phys.*, 2020
* Hassan S, Mughal BJ, Siwiak M, Yasin Z. [A modified SEIR meta-population transmission based Modeling and Forecasting of the COVID-19 pandemic in Pakistan](https://doi.org/10.1101/2020.06.03.20121517). *medRxiv*, 2020
* Stephen J Beckett et al. [Spread of COVID-19 through Georgia, USA. Near-term projections and impacts of social distancing via a metapopulation model](https://doi.org/10.1101/2020.05.28.20115642). *medRxiv pre-print* (2020)
#### Calibration
* Hazelbag CM, Dushoff J, Dominic EM, Mthombothi ZE, Delva W (2020) [Calibration of individual-based models to epidemiological data: A systematic review](https://doi.org/10.1371/journal.pcbi.1007893). *PLoS Comput Biol* 16(5): e1007893
* Biggerstaff M, Cowling BJ, Cucunubá ZM, Dinh L, Ferguson NM, Gao H, et al., for the *WHO COVID-19 Modelling Parameters Group*. [Early insights from statistical and mathematical modeling of key epidemiologic parameters of COVID-19](https://doi.org/10.3201/eid2611.201074). *Emerg Infect Dis* (2020.
#### Surveillance 
* Daniel B Larremore et al. [Test sensitivity is secondary to frequency and turnaround time for COVID-19 surveillance](https://doi.org/10.1101/2020.06.22.20136309), *medRxiv* (2020)
* Yang Liu et al. [A Modelling Study for Designing a Multi-layered Surveillance Approach to Detect the Potential Resurgence of SARS-CoV-2](https://doi.org/10.1101/2020.06.27.20141440), *medRxiv* (2020)
* Frank G Sandmann, Peter J White, Mary Ramsay, Mark Jit, [Optimizing Benefits of Testing Key Workers for Infection with SARS-CoV-2: A Mathematical Modeling Analysis](https://doi.org/10.1093/cid/ciaa901), *Clinical Infectious Diseases*,  ciaa901
* Colman E, Holme P, Sayama H, Gershenson C (2019) [Efficient sentinel surveillance strategies for preventing epidemics on networks](https://doi.org/10.1371/journal.pcbi.1007517). *PLoS Comput Biol* 15(11): e1007517. 
* Grassly NC, Pons-Salort M, Parker EPK, et al. [Comparison of molecular testing strategies for COVID-19 control: a mathematical modelling study](https://doi.org/10.1016/S1473-3099(20)30630-7). *Lancet Infect Dis* 2020
* Ted Bergstrom, Carl Bergstrom, Haoran Li [Frequency and accuracy of proactive testing for COVID-19](https://doi.org/10.1101/2020.09.05.20188839), *medRxiv* (2020)
#### Interventions
* Josh A Firth, Joel Hellewell, Petra Klepac, Stephen M Kissler et al. [Combining fine-scale social contact data with epidemic modelling reveals interactions between contact tracing, quarantine, testing and physical distancing for controlling COVID-19](https://cmmid.github.io/topics/covid19/tracing-network-local.html), *CMMID pre-print* (2020)
*  Akira Endo et al. [Implication of backward contact tracing in the presence of overdispersed transmission in COVID-19 outbreaks](https://cmmid.github.io/topics/covid19/backwardtracing.html), *CMMID pre-print* (2020)
* Giordano, G., Blanchini, F., Bruno, R. et al. [Modelling the COVID-19 epidemic and implementation of population-wide interventions in Italy](https://doi.org/10.1038/s41591-020-0883-7). Nat Med 26, 855–860 (2020) 
* Marino Gatto et al. [Spread and dynamics of the COVID-19 epidemic in Italy: Effects of emergency containment measures](https://doi.org/10.1073/pnas.2004978117). *PNAS* (2020)
* Bertuzzo, E., Mari, L., Pasetto, D. et al. [The geography of COVID-19 spread in Italy and implications for the relaxation of confinement measures](https://doi.org/10.1038/s41467-020-18050-2). Nat Commun 11, 4264 (2020)
* Aleta, A., Martín-Corral, D., Pastore y Piontti, A. et al. [Modelling the impact of testing, contact tracing and household quarantine on second waves of COVID-19](https://doi.org/10.1038/s41562-020-0931-9). Nat Hum Behav (2020)
#### Behavioral 
* Perra N, Balcan D, Gonçalves B, Vespignani A (2011) [Towards a Characterization of Behavior-Disease Models](https://doi.org/10.1371/journal.pone.0023084). *PLoS ONE* 6(8): e23084. 
* Verelst Frederik, Willem Lander and Beutels Philippe (2016) [Behavioural change models for infectious disease transmission: a systematic review (2010–2015)](http://doi.org/10.1098/rsif.2016.0820) *J. R. Soc.* Interface.1320160820
* Granell C, Gómez S, Arenas A. (2013) [Dynamical Interplay between Awareness and Epidemic Spreading in Multiplex Networks](https://doi.org/10.1103/PhysRevLett.111.128701). *Phys Rev Lett.* 2013;111: 128701.
* Massaro E, Bagnoli F. (2014) [Epidemic spreading and risk perception in multiplex networks: A self-organized percolation method](https://doi.org/10.1103/PhysRevE.90.052817). *Phys Rev E—Stat Nonlinear, Soft Matter Phys.* 2014;90: 53–64. 
* Abdulkareem SA, Augustijn E-W, Filatova T, Musial K, Mustafa YT (2020) [Risk perception and behavioral change during epidemics: Comparing models of individual and collective learning](https://doi.org/10.1371/journal.pone.0226483). *PLoS ONE* 15(1): e0226483.
* Hunter E, Mac Namee B, Kelleher J (2018) [An open-data-driven agent-based model to simulate infectious disease outbreaks](https://doi.org/10.1371/journal.pone.0208775). *PLoS ONE* 13(12): e0208775. 
#### Mortality 
* WHO, [Estimating mortality from COVID-19](https://www.who.int/news-room/commentaries/detail/estimating-mortality-from-covid-19), *Scientific Brief* (2020)
