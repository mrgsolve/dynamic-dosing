
# Tools for dynamic dosing with mrgsolve

## Poster
**Simulating Adaptive Dosing Regimens from PK and PKPD Models Using mrgsolve**   
15th American Conference on Pharmacometrics  
Poster: [W-007](https://cdmcd.co/GwEMgX ), Wednesday November 13, 2024  
PDF: [docs/poster.pdf](docs/poster.pdf)


More info on `evtools` in the [user guide](https://mrgsolve.org/user-guide/plugins.html#sec-plugin-evtools).

## Content in this repository

Platelet PKPD model code and outputs

- Reference: Fukae M, Baron K, Tachibana M, Mondick J, Shimizu T. 
  _Population pharmacokinetics of total and unbound valemetostat and platelet dynamics in healthy volunteers and patients with non-Hodgkin lymphoma_. 
  CPT Pharmacometrics Syst Pharmacol. 2024; 13: 1641-1654. 
  [doi:10.1002/psp4.13201](https://doi.org/10.1002/psp4.13201)  
- Main [PKPD model](https://github.com/mrgsolve/dynamic-dosing/blob/main/model/platelet.mod) file contains
  both the valemetostat PK model and the platelet dynamic model
- Code to implement [platelet monitoring](https://github.com/mrgsolve/dynamic-dosing/blob/main/model/monitor.h) 
  is a C++ header file that gets included into the PKPD model file
- A simple [demonstration](https://github.com/mrgsolve/dynamic-dosing/blob/main/platelets-example.qmd) of invoking the 
  platelet model with no dose adjustments; generates poster 
  [Figure 2](https://github.com/mrgsolve/dynamic-dosing/blob/main/platelets-example.pdf)
- The [R code](https://github.com/mrgsolve/dynamic-dosing/blob/main/platelets-adjust.R) used 
  to generate poster [Figure 3](https://github.com/mrgsolve/dynamic-dosing/blob/main/platelets-adjust.pdf)

A [vignette](https://mrgsolve.org/dynamic-dosing) showing ten examples of dose
regimen implementation inside your mrgsolve model

- The vignette source code is [here](https://github.com/mrgsolve/dynamic-dosing/blob/main/evtools.qmd)
- The full source code for all the models can be found [here](https://github.com/mrgsolve/dynamic-dosing/tree/main/model)



