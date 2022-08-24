# Stressor-Interaction-statistical-power-function

This project simulates data with user inputed expected values for biological responses in the classical factorial experimental set up to investigate the type of interaction between two stressors. It should be used as guidance for setting up real experiments where the user chooses plausible values for treatment means and standard deviations, and the function returns an estimate of the statistical power to reject the null model prediction for the interaction.

A tutorial (tutorial_for_interaction_power.pdf) is provided that runs through the basics of how to use the interaction_power function, and implements some simple examples. This code and function is used and discussed in the paper: 

Burgess, B.J., Jackson, M.C. and Murrell, D.J., 2022. Are experiment sample sizes adequate to detect biologically important interactions between multiple stressors? Ecology and Evolution (accepted)

Also included is code to reproduce Figures 4 and S1 in the same paper.

The user should also read the multiplestressR manual pages which is also required to run this code (see https://cran.r-project.org/web/packages/multiplestressR/index.html.) See also Benjamin J. Burgess, David J. Murrell (2022) multiplestressR: An R package to analyse factorial multiple stressor data using the additive and multiplicative null models. bioRxiv 2022.04.08.487622; doi: https://doi.org/10.1101/2022.04.08.487622 
