# options(echo=TRUE) # if you want see commands in output file
# args <- commandArgs(trailingOnly = TRUE)
# node.idx = as.numeric(args[1])
node.idx = 1

#fname = paste("/pine/scr/j/i/jiawei/proj2/survival_eg/data/general",node.idx,".csv",sep = "")
fname = paste("C:/D/project2/rcpp/longleaf/data",node.idx,".csv",sep = "")
data = read.csv(file = fname,header = F)
names = c("ID","time","censor","trt","gender","sim","t.star","T0","r0","censorship","t.start","gap")
colnames(data) = names

###############################

x = as.matrix(cbind(data$trt,data$gender))  # covariate matrix for both events
xP = x
xQ = x
Nobs = nrow(data)                                                   # number of observations
Ngroups = length(unique(data$ID))                                   # number of patients

P = 5
Q = 5
pcutpoints = c(0,12.0,56.5,179.0,418.0,5000)
group = data$ID
qcutpoints = c(0,128.5,260.5,488.0,791.5,5000)
index = match(unique(data$ID),data$ID)

time = data$t.star                            # time-to-event times
censorship = data$censorship               # time-to-event censor
gap = data$gap                             # recurrent gap times
censor = data$censor                       #  recurrent gap censor

init.theta = list()
init.theta[[1]] = c(-0.826252661,-0.7075668742)     # beta1, gamma1
init.theta[[2]] = c(-0.772260947,-0.6014532585)     # beta2, gamma2
init.theta[[3]] = c(1.3469263991,0.7)        # theta, eta
#init.theta[[3]] = c(1.3469263991,0.7) 
init.theta[[4]] = c(-4.797012, -5.444727, -6.209842, -6.365601, -6.747644)
init.theta[[5]] = c(-7.749583, -7.582338, -7.977300, -7.893266, -8.155407)

#lower_limits = rep( -10,ncol(xP)+ncol(xQ)+2 ) 
lower_limits = c( rep( -10,ncol(xP)+ncol(xQ) ), 0,0 )
upper_limits = rep( 10,ncol(xP)+ncol(xQ)+2 )
slice_widths = rep( 1,ncol(xP)+ncol(xQ)+2 )

sigma_norm = 5
sigma_gammaB = 0.1
sigma_gammaR = 1.1

xi.r0 = xi.lambda0 = 0

prior.M = rep(1/4,4)

########################################

#setwd("/pine/scr/j/i/jiawei/proj2/sim_rcpp/programs")
setwd("C:/D/project2/rcpp/longleaf")
source("RE_php.rcpp")

set.seed(node.idx)
pmpH = JM(Nobs, Ngroups, xP, xQ, time, censorship, gap, censor, P, Q, pcutpoints, group, qcutpoints, index, init.theta,
         lower_limits, upper_limits, slice_widths, sigma_norm, sigma_gammaB, sigma_gammaR, xi.r0, xi.lambda0, prior.M, 
         nBI = 100, nMC = 100)

php = pmpH$PHP
pmp = pmpH$PMP
prob = pmpH$Prob
ests = pmpH$estimates
margin = pmpH$margin

pmp.php = c(php, margin, prob)
all = cbind(pmp.php,ests)
fname1 = paste("/pine/scr/j/i/jiawei/proj2/joint_model/means/php",node.idx,".csv",sep = "")
write.table(all,file = fname1, sep = ",",col.names = F,row.names = F)

