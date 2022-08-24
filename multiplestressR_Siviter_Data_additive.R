
#Set Working Directory
setwd("/Users/david/Dropbox (UCL)/Ben Burgess/Manuscript2/bee_data")

#Load in multiplestressR 
library(multiplestressR)
library(ggplot2)

#Load in data
df<-read.csv("bee_all.csv", na.strings = c("na","#VALUE!", "op"))
df<-read.csv("bee_survival.csv", na.strings = c("na","#VALUE!", "op"))

#Calculate additive effect size
df_add <- effect_size_additive(Control_N    = df$control_n,
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
                               
                               Small_Sample_Correction = TRUE,
                               Significance_Level = 0.05)


#Remove rows where there is missing data
df_add <- na.omit(df_add)

#Classify interactions
#note that here we have removed directionality
df_add <- classify_interactions(effect_size_dataframe = df_add,
                                assign_reversals = TRUE,
                                remove_directionality = TRUE)

#generate summary plots
df_add_plots <- summary_plots(df_add,
                              Small_Sample_Correction = TRUE,
                              Significance_Level = 0.05)

#show plots
df_add_plots

#only show sample size / effect size plot
df_add_plots[[2]]

#x axis on logarithmic scale (base 10)
df_add_plots[[2]] + 
  scale_x_continuous(trans='log10')


pdf("fig2.gcb.opinion.pdf")
#x axis on logarithmic scale (base 10) and
# legend shown without title
df_add_plots[[2]] + 
  scale_x_continuous(trans='log10') +
  theme(legend.position="top",
        legend.title = element_blank())

dev.off()

library(metafor)

rma(df_add$Interaction_Effect_Size, df_add$Interaction_Variance, weighted=T)