#The package multiplestressR is required to run this code
#Code written by David John Murrell is written for clarity rather than speed or efficiency

#To install run the next line
#install.packages('mulitplestressR')

library(multiplestressR)

# This function takes input values for 
#			treatment means X_C, X_A, X_B, X_I
#			treatment standard deviations S_C, S_A, S_B, S_I
#			treatment samples sizes N_C, N_A, N_B, N_I
# Subscripts 
#			C: control, A: stressor A only,
#			B: stressor B only, I: interaction treatment
#
# The above parameters all need parameters. Those below give user options.
#
# alpha is the statistical level, defaulted to 0.05
#
# sims is the number of experiments to simulate (default is 1000)
#
# model: set to "A" for additive null model, "M" for multiplicative null model
# default option is additive 
#
# Output is a dataframe that gives the power (% of simulations that reject the null model predicted interaction)
# and the mean effect size, averaged across all simulations


interaction_power = function(	X_C, X_A, X_B, X_I, 
								S_C, S_A, S_B, S_I, 
								N_C, N_A, N_B, N_I,
								alpha=0.05,
								sims=1000, model="A")
{

sim_data<-matrix(ncol=12, nrow=sims)

for(i in 1:sims)
	{
#We now sample observations from Gaussian distributions set by our parameters
	
	C <- rnorm(N_C, mean=X_C, sd=S_C)
	A <- rnorm(N_A, mean=X_A, sd=S_A)
	B <- rnorm(N_B, mean=X_B, sd=S_B)
	I <- rnorm(N_I, mean=X_I, sd=S_I)

#Now compute the sampled means and standard deviations
	sim_data[i,1] <- mean(C)
	sim_data[i,2] <-sd(C)
	sim_data[i,3] <-N_C
	
	sim_data[i,4]<- mean(A)
	sim_data[i,5] <-sd(A)
	sim_data[i,6] <-N_A

	sim_data[i,7]<- mean(B)
	sim_data[i,8] <-sd(B)
	sim_data[i,9] <-N_B

	sim_data[i,10]<- mean(I)
	sim_data[i,11] <-sd(I)
	sim_data[i,12] <-N_I	
	}
	
 #Estimate effect sizes using the additive or multiplicative null models... 
 
	if(model == "A")
		{
		df_model <- effect_size_additive(	Control_N = sim_data[,3],
										Control_SD = sim_data[,2],
										Control_Mean = sim_data[,1],

										StressorA_N = sim_data[,6],
										StressorA_SD = sim_data[,5],
										StressorA_Mean = sim_data[,4],
									
										StressorB_N = sim_data[,9],
										StressorB_SD = sim_data[,8],
										StressorB_Mean = sim_data[,7],
									
										StressorsAB_N = sim_data[,12],
										StressorsAB_SD = sim_data[,11],
										StressorsAB_Mean = sim_data[,10],
							
										Significance_Level = 0.05)
										
		df1 <- classify_interactions(	effect_size_dataframe = df_model,
										assign_reversals = TRUE,
										remove_directionality = TRUE)								
		}
	else if(model == "M")
		{
		df_model <- effect_size_multiplicative(	Control_N = sim_data[,3],
										Control_SD = sim_data[,2],
										Control_Mean = sim_data[,1],

										StressorA_N = sim_data[,6],
										StressorA_SD = sim_data[,5],
										StressorA_Mean = sim_data[,4],
									
										StressorB_N = sim_data[,9],
										StressorB_SD = sim_data[,8],
										StressorB_Mean = sim_data[,7],
									
										StressorsAB_N = sim_data[,12],
										StressorsAB_SD = sim_data[,11],
										StressorsAB_Mean = sim_data[,10],
							
										Significance_Level = 0.05)
										
		df1 <- classify_interactions(	effect_size_dataframe = df_model,
										assign_reversals = TRUE,
										remove_directionality = TRUE)	
			
		}
	
	
	
#We collect the mean effect sizes across all simulated experiments
mean_ES<-mean(df1$Interaction_Effect_Size)

#We also sum the number of times the null model was rejected
pp <- subset(df1, df1$Interaction_Classification != "Null")
pp <- length(pp$Interaction_Classification )/sims

#Output is power and mean effect size
res<-data.frame(power=pp, mean_effect_size=mean_ES)

return(res)
	
}
