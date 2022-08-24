# This code is used to generate figure S1 in Burgess, B.J., Jackson, M.C. and Murrell, D.J., 2022. Are experiment sample sizes adequate to detect biologically important interactions between multiple stressors?. Ecology and Evolution (accepted)

#The bee data is freely available frpm Siviter, H., Bailes, E. J., Martin, C. D., Oliver, T. R., Koricheva, J., Leadbeater, E., and Brown, M. J. 2021. 662 Agrochemicals interact synergistically to increase bee mortality. Nature, 596(7872), 389-392.

#Set Working Directory -needs to be set to where you have saved the bee data
#setwd("")

#Load in multiplestressR 
library(multiplestressR)
library(ggplot2)

#Load in data
df<-read.csv("bee_all.csv", na.strings = c("na","#VALUE!", "op"))

#Need to remove means which are <= 0 - due to logarithmic nature of the analysis
df <- subset(df, control_mean > 0 & stress_1_mean > 0 & stress_2_mean > 0 & crossed_mean > 0)

#Calculate additive effect size
df_mul <- effect_size_multiplicative(Control_N    = df$control_n,
                                     Control_SD   = df$control_sd,
                                     Control_Mean = df$control_mean,
                                     
                                     StressorA_N = df$stress_1_n,
                                     StressorA_SD = df$stress_1_sd,
                                     StressorA_Mean = df$stress_1_mean,
                                     
                                     StressorB_N = df$stress_2_n,
                                     StressorB_SD = df$stress_2_sd,
                                     StressorB_Mean = df$stress_2_mean,
                                     
                                     StressorsAB_N = df$crossed_n,
                                     StressorsAB_SD = df$crossed_sd,
                                     StressorsAB_Mean = df$crossed_mean,
                                     
                                     Significance_Level = 0.05)


#Remove rows where there is missing data
df_mul <- na.omit(df_mul)

#Classify interactions
#note that here we have removed directionality
df_mul <- classify_interactions(effect_size_dataframe = df_mul,
                                assign_reversals = TRUE,
                                remove_directionality = TRUE)

#generate summary plots
df_mul_plots <- summary_plots(df_mul,
                              Significance_Level = 0.05)

#show plots
df_mul_plots

#only show sample size / effect size plot
df_mul_plots[[2]]

#x axis on logarithmic scale (base 10)
df_mul_plots[[2]] + 
  scale_x_continuous(trans='log10')


#x axis on logarithmic scale (base 10) and
# legend shown without title
df_mul_plots[[2]] + 
  scale_x_continuous(trans='log10') +
  theme(legend.position="top",
        legend.title = element_blank())


