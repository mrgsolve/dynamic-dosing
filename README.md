
# Tools for dynamic dosing

## Poster
**Simulating Adaptive Dosing Regimens from PK and PKPD Models Using mrgsolve**   
15th American Conference on Pharmacometrics  
Poster: W-007, Wednesday November 13, 2024  

## Content on this website

Platelet PKPD [model](https://ascpt.onlinelibrary.wiley.com/doi/10.1002/psp4.13201) code 

- Main model file is [here](https://github.com/mrgsolve/dynamic-dosing/blob/main/model/platelet.mod)
- Monitoring code is [here](https://github.com/mrgsolve/dynamic-dosing/blob/main/model/monitor.h)
- A simple [demonstration](https://github.com/mrgsolve/dynamic-dosing/blob/main/platelets-example.qmd) of invoking the platelet model with no dose adjustments (generates poster Figure 2)
- The [code](https://github.com/mrgsolve/dynamic-dosing/blob/main/platelets-adjust.R) used to generate poster Figure 3

A [vignette](https://mrgsolve.org/dynamic-dosing) showing ten examples of dose
regimen implementation inside your mrgsolve model

- The vignette source code is [here](https://github.com/mrgsolve/dynamic-dosing/blob/main/evtools.qmd)
- The full source code for all the models can be found [here](https://github.com/mrgsolve/dynamic-dosing/tree/main/model)



