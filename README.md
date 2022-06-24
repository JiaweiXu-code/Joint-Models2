# Software for paper "Bayesian Design of Clinical Trials Using Joint Models for Recurrent and Terminating Events" by Xu et al.

-------------------------------------------------------------------------------------------------------------------------------------

All programs are setup to be executed on a Linux computing cluster using R (3.6.0). The paths referenced in all programs will need to be updated for the code to work. Once all paths are updated, one can use the SLURM scheduler shell scripts to submit jobs on a SLURM-based computing cluster. 


--------------------------------------------------- RUN ORDER ------------------------------------------------

[1] ssd.sh -- Determine the desired sample size such that a specified number of terminating events is obtained in a specified interval of time on average. This process is performed based on massive (e.g., 1,000) simulations and calls the R program "ssd.R" which performs a single simulation. The "ssd.R" code requires the following inputs:

   (1)  integer      - seed     - seed for a single simulation (e.g., 1-1,000 for sample size determination and 1-4,000 for data generation)
   
   (2)  integer      - v        - number of terminating events 
   
   (3)  double       - k        - ratio between number of enrolled patients and terminating event total 
   
   (4)  integer      - p        - number of intervals for piecewise constant baseline of recurrent hazard function
   
   (5)  interger     - q        - number of intervals for piecewise constant baseline of terminating hazard function
   
   (6)  vector (dbl) - Sp       - knots placement for piecewise constant baseline of recurrent hazard function 

   (7)  vector (dbl) - Sq       - knots placement for piecewise constant baseline of terminating hazard function 
   
   (8)  vector (dbl) - p0        - allocation probabilities for treatment and baseline covariates 
   
   (9)  vector (dbl) - beta     - regression coefficients of baseline covariates in recurrent and terminating event processes
   
   (10) vector (dbl) - gamma    - regression coefficients of treatment indicators in recurrent and terminating event processes 
   
   (11) double       - r.eta    - period of time (years) for patient enrollment 
   
   (12) double       - eta      - variance of the frailty that accounts for the dependence between the recurrent and terminating event processe
   
   (13) double       - r.eta    - variance of the frailty that accounts for dependence between recurrent event time
       
   (14) double       - censorp  - dropout probability 
   
   (15) double       - censor   - period of time (years) for dropout 
   
   (16) double       - max      - maximum follow-up time (years) under ideal cases (i.e., no dropout or censoring)
   
   (17) vector (dbl) - llambda  - piecewise constant baseline of terminating hazards in log scale
   
   (18) vector (dbl) - lr       - piecewise constant baseline of recurrent hazards in log scale
   
OUTPUTS: Seed, trial duration, sample size, event total



[2] mean.R -- Compute the average trial duration, sample size and terminating event total based on the 1,000 simulations.

[3] data_array.R -- Simulate the recurrent and terminating event data by calling the R program "data_gen.R" which performs a single simulation and fit the joint models to the corresponding dataset by calling R program "RE_php.R". The "data_gen.R" code requires the same inputs as for "ssd.R". 

OUTPUTS (from "data_gen.R" of simulated data):

   (1)  integer - ID         - patient ID

   (2)  double  - time       - accumulative follow-up time (years) for recurrent event since enrollment
   
   (3)  binary  - censor     - indicator for censoring (1 = recurrent event, 0 = censored) for recurrent event process

   (4)  binary  - trt        - treatment indicator (1 = treated, 0 = control)
   
   (5)  binary  - genber     - baseline covariate (1 = female, 0 = male)
   
   (6)  integer - sim        - ID for simulated data
   
   (7)  double  - t.star     - follow-up time (years) for terminating event since enrollment
  
   (8)  double  - T0         - follow-up time (years) for terminating event since trial started

   (9)  double  - r0         - enrollment time (years)

   (10) binary  - censorship - indicator for censoring (1 = terminating event, 0 = censored) for terminating event process
   
   (11) double  - t.start    - start time of current follow-up for recurrent event
   
   (12) double  - gap        - gap time of recurrent event
    
   
[4] estimates.R -- Estimate the Bayesian type I error rate or power under different priors as well as the parameters based on joint models.


----------------------------------------- Folder MainResults --------------------------------------

Description: This folder contains data generation and model fitting programs for results in Section 3. 

RE_php.rcpp -- The Rcpp program called by "RE_php.R" to fit the joint model to produce Figures 2&3&4 and Tables 1&2.

The ratios between sample size and terminating event total used in the paper for data generation can be found below:

| γ[2] | -0.1 | -0.15 | -0.2 | -0.3 | -0.4 | -0.45 | -0.5 | -0.6 | 0.02 | 0.04 | 0.06 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | 
| ratio | 3.1 | 3.15 | 3.2 | 3.3 | 3.4 | 3.45 | 3.5 | 3.6 | 2.99 | 2.97 | 2.95 |


----------------------------------------- Folder Trajectory-Misspecification --------------------------------------

Description: This folder contains data generation and model fitting programs for results in Section 3.2. 

dataset-leveloff.R  -- Simulate data where the trajectory for treated group increases initially but levels off over time. A 6-component piecewise linear trajectory is assumed.

dataset-concave.R   -- Simulate data where the trajectory for treated group increases initially and subsequently decreases. A 6-component piecewise linear trajectory is assumed.

JM3.sas             -- Fit a joint model with random intercept. A 3-component piecewise linear trajectory is assumed.

JM6.sas             -- Fit a joint model with random intercept. A 6-component piecewise linear trajectory is assumed.

SJM3.sas            -- Fit a simplified joint model without random effects. A 3-component piecewise linear trajectory is assumed.

SJM6.sas            -- Fit a simplified joint model without random effects. A 6-component piecewise linear trajectory is assumed.

Trajectory-curves.R -- Compute the correct and average fitted trajectories for treated and control groups.

Note: Patient-level heterogeneity is based on a random intercept. A 5-component piecewise constant baseline hazard function is used for both data generation and model fitting.


--------------------------------------------- Folder RE-Misspecification ------------------------------------------

Description: This folder contains data generation and model fitting programs for results in Section 3.3. 

dataset.R  -- Simulate data where patient-level heterogeneity is based on a random intercept and a random slope. The two random effects are assumed to be independent. Ratio between standard deviations of random slope and random intercept "mk" varies in {0.25,0.50}.

JM.sas     -- Fit a joint model with a random intercept.

SJM.sas    -- Fit a simplified joint model without random effects.

TrueJM.sas -- Fit a joint model with a random intercept and a random slope.

Note: A 4-component piecewise linear trajectory and a 5-component piecewise constant baseline hazard function is used for both data generation and model fitting.


--------------------------------------------- Folder DropoutProb-AppendixB ----------------------------------------

Description: This folder contains data generation and model fitting programs for results in Appendix B of the Supplementary Materials. 

dataset.R  -- Simulate data where patient-level heterogeneity is based on a random intercept. The dropout probability "censorp" varies in {0.05,0.10,0.20}.

JM.sas     -- Fit a joint model with a random intercept.

SJM.sas    -- Fit a simplified joint model without random effects.

Note: A 4-component piecewise linear trajectory and a 5-component piecewise constant baseline hazard function is used for both data generation and model fitting.


------------------------------------------- Folder SurvivalCurves-AppendixD ---------------------------------------

Description: This folder contains programs to plot Figure2 in Appendix D of the Supplementary Materials. 

survival_curves.R -- Compute the estimated survival curves based on parameter estimates from proposed joint model.

Surv_plot.sas     -- Plot survival curves for treated and control groups using the estimated survival probabilities from "survival_curves.R".


------------------------------------------- Folder Heterogeneity-AppendixE ----------------------------------------

Description: This folder contains data generation and model fitting programs for results in Appendix E of the Supplementary Materials. 

dataset.R     -- Simulate data where patient-level heterogeneity is based on a random intercept. The standard deviation of random intercept varies in {0.000,0.356,0.712}.

JM.sas        -- Fit a joint model with a random intercept.

SJM.sas       -- Fit a simplified joint model without random effects.

estimates.sas -- Compute the average parameter estimates based on the joint models. 

Note: A linear time trajectory and constant baseline hazard function is used for both data generation and model fitting.


--------------------------------------------- Folder Overfitting-AppendixF ----------------------------------------

Description: This folder contains data generation and model fitting programs for results in Appendix F of the Supplementary Materials. 

dataset.R          -- Simulate data where patient-level heterogeneity is based on a random intercept. A linear time trajectory and constant baseline hazard function is assumed.

JM-none.sas        -- Fit a joint model with a random intercept. A linear trajectory and a constant baseline hazard function is used. 

JM-BL.sas          -- Fit a joint model with a random intercept. A linear trajectory and a piecewise constant baseline hazard function is used. 

JM-trajectory.sas  -- Fit a joint model with a random intercept. A piecewise linear trajectory and a constant baseline hazard function is used. 

JM-both.sas        -- Fit a joint model with a random intercept. A piecewise linear trajectory and a piecewise constant baseline hazard function is used. 

SJM-none.sas       -- Fit a simplified joint model without random effects. A linear trajectory and a constant baseline hazard function is used. 

SJM-BL.sas         -- Fit a simplified joint model without random effects. A linear trajectory and a piecewise constant baseline hazard function is used. 

SJM-trajectory.sas -- Fit a simplified joint model without random effects. A piecewise linear trajectory and a constant baseline hazard function is used. 

SJM-both.sas       -- Fit a simplified joint model without random effects. A piecewise linear trajectory and a piecewise constant baseline hazard function is used. 
