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



[2] ssd_mean.R -- Compute the average trial duration, sample size and terminating event total based on the 1,000 simulations.

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


----------------------------------------- Folder Main&A&B --------------------------------------

Description: This folder contains model fitting programs for results in Section 3 as well as results in Appendices A&B. 

RE_php.R    -- R program calling "RE_php.rcpp" to fit the joint model to produce Figures 2&3&4&S1 and Tables 1&S1.

RE_php.rcpp -- Rcpp program called by "RE_php.R" to fit the joint model.

The ratios between sample size and terminating event total used in the paper for data generation can be found below:

| γ[2] | -0.1 | -0.15 | -0.2 | -0.3 | -0.4 | -0.45 | -0.5 | -0.6 | 0.02 | 0.04 | 0.06 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | 
| ratio | 3.1 | 3.15 | 3.2 | 3.3 | 3.41 | 3.45 | 3.5 | 3.6 | 2.99 | 2.97 | 2.95 |


----------------------------------------- Folder Dirichlet --------------------------------------

Description: This folder contains model fitting programs for results in Section 4. 

dirichlet.R      -- R program calling "dirichlet.rcpp" to fit the joint model with mixture of Dirichlet process to produce Table 2.

dirichlet.rcpp   -- Rcpp program called by "dirichlet.R" to fit the joint model with mixture of Dirichlet process.
