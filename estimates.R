n = 20
power = 0
est_all = matrix(NA,n,16)
pmp_all = matrix(NA,n,4)

for (i in 101:120){
  #name = paste("/pine/scr/j/i/jiawei/proj2/sim_test/means/php",i,".csv",sep = "")
  name = paste("C:/Users/zoro3/OneDrive/Desktop/PHP/means/php",i,".csv",sep = "")
  est = read.csv(name,header = F)
  power = power+ifelse(1-est[1,1]>0.95,1,0)
  pmp_all[i-100,] = est[5:8,1]/sum(est[5:8,1])
  est_all[i-100,] = est[,2]
}
powers = power/n
ests = colMeans(est_all)
pmps = colMeans(pmp_all)

all = c(powers,ests)
write.table(all,file = "/pine/scr/j/i/jiawei/proj2/sim_test/programs/power.csv", sep = ",",col.names = F,row.names = F)
