options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
node.idx = as.numeric(args[1])

fname = paste("/pine/scr/j/i/jiawei/p2-rev/power/33/data400/data",node.idx,".csv",sep = "")
#fname = paste("C:/D/project2/Revision/programs/data50.csv",sep = "")
data.all = read.csv(file = fname,header = F)
data = data.all
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

group.new = group
for (i in 2:Nobs){
  if (group[i] == group[i-1]){
    group.new[i] = group.new[i-1]
  }else{
    if (group.new[i] - group.new[i-1] > 1){
      group.new[i] = group.new[i-1] + 1
    }else if (group[i] == group[i-1]){
      group.new[i] = group.new[i-1]
    }
  }
}

qcutpoints = c(0,128.5,260.5,488.0,791.5,5000)
index = match(unique(data$ID),data$ID)
Nindex = c(index,Nobs+1)

time = data$t.star                         # time-to-event times
censorship = data$censorship               # time-to-event censor
gap = data$gap                             # recurrent gap times
censor = data$censor                       #  recurrent gap censor

init.theta = list()
init.theta[[1]] = c(-0.826252661,-0.7075668742)     # beta1, gamma1
init.theta[[2]] = c(-0.772260947,-0.6014532585)     # beta2, gamma2
#init.theta[[3]] = c(1.3469263991,0.07)        # theta, eta
#init.theta[[3]] = log( c(1.3469263991,0.07) )
init.theta[[3]] = c(-4.797012, -5.444727, -6.209842, -6.365601, -6.747644)
init.theta[[4]] = c(-7.749583, -7.582338, -7.977300, -7.893266, -8.155407)

#lower_limits = rep( -10,ncol(xP)+ncol(xQ)+2 ) 
lower_limits = rep( -10,ncol(xP)+ncol(xQ) )
upper_limits = rep( 10,ncol(xP)+ncol(xQ) )
slice_widths = rep( 1,ncol(xP)+ncol(xQ) )

sigma_normB = 5
delta1 = -0.3
rho = 2
sigma_normT = abs(delta1)*rho
meanT = 0
sigma_gammaB = 0.1
theta = 1.269
eta = 0.046
M = 100

xi.r0 = xi.lambda0 = 0

pi = 1/3
prior.M = c((1-pi)^2,pi*(1-pi),pi*(1-pi),pi^2)

########################################

setwd("/pine/scr/j/i/jiawei/p2-rev/M/M500/programs")
#setwd("C:/D/project2/Revision/programs/troubleshoot")
source("dirichlet.rcpp")

set.seed(node.idx)
pmpH = JM(Nobs, Ngroups, xP, xQ, time, censorship, gap, censor, P, Q, pcutpoints, group.new, qcutpoints, Nindex, 
          init.theta, lower_limits, upper_limits, slice_widths, sigma_normB, meanT, sigma_normT, theta, eta, M, 
          sigma_gammaB, xi.r0, xi.lambda0, prior.M, nBI = 5000, nMC = 30000)


php = pmpH$PHP
pmp = pmpH$PMP
prob = pmpH$Prob
ests = pmpH$estimates
margin = pmpH$margin

ests2 = pmpH$estimates2
ests3 = pmpH$estimates3

pmp.php = c(php, margin, prob,pmp)
est = c(ests,ests2,ests3)

trace = pmpH$sample_w
#all = cbind(pmp.php,ests,est)
#fname1 = paste("/pine/scr/j/i/jiawei/p2-rev/php",node.idx,".csv",sep = "")
#write.table(all,file = fname1, sep = ",",col.names = F,row.names = F)


fname1 = paste("/pine/scr/j/i/jiawei/p2-rev/M/M100/means/php",node.idx,".csv",sep = "")
write.table(pmp.php,file = fname1, sep = ",",col.names = F,row.names = F)
