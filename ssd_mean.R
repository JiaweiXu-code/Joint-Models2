means = matrix(NA,nrow = 3,ncol = 0)
for (j in 1:1000){
  
  fname = paste("/pine/scr/j/i/jiawei/proj2/sim_test/ssd/data/ssd",j,".csv",sep = "")
  mean = read.csv(file = fname)
  means = cbind(means,mean)
}
mean = rowMeans(means)
write.table(mean,file = "/pine/scr/j/i/jiawei/proj2/sim_test/ssd/ssd.csv",sep = ",",col.names = F,row.names = F)
