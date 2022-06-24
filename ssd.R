
#######################################

generation = function(seed, v, k = 3, p = 5, q = 5, Sp = c(12.0,56.5,179.0,418.0), Sq = c(128.5,260.5,488.0,791.5),
                      p0 = c(0.5,0.5), beta = c(0.479323,0.257430), gamma = c(-0.7,-0.7),
                      theta = 1.5, eta = 0.065978, r.eta = 365, censorp = 0.05, censor = 2200, max = 5000, 
                      llambda = c(-8.061864905,
                                  -7.898015823,
                                  -8.296852361,
                                  -8.221191967,
                                  -8.489544281),
                      lr = c(-5.312222982,
                             -5.950230406,
                             -6.714389664,
                             -6.871748954,
                             -7.258060494)){
  
  ### set up ###
  set.seed(seed)
  ss = floor(k*v)
  r0 = runif(ss,0,r.eta)
  mu = rgamma(ss,1/theta,scale = theta)
  set.seed(seed)
  nu = rgamma(ss,1/eta,scale = eta)
  
  ### create empty datasets ###
  dataS = matrix(NA, 0, 8) 
  dataL = matrix(NA, 0, 7)
  
  new.Sq = c(0,Sq)
  inf.q = c(Sq,10^10)
  new.Sp = c(0,Sp)
  inf.p = c(Sp,10^10)
  
  for (m in 1:ss){
    
    z = rbinom(1,1,p0[1])
    sex = rbinom(1,1,p0[2])
    
    ####### simulate terminating data #######
    phi.lambda = z*gamma[2]+sex*beta[2]
    
    inv.q = function(s){
      temp1.q = log(s)/(mu[m]*exp(phi.lambda+llambda))
      temp2.q = exp(llambda[-q])*(Sq-new.Sq[-q])
      temp3.q = cumsum(c(0,temp2.q))
      i = 0
      repeat{
        i = i+1
        t = new.Sq[i]-temp1.q[i]-temp3.q[i]/exp(llambda[i])
        if ((new.Sq[i]<t && t<=inf.q[i]) || i>q){
          break
        }
      }
      t
    }
    u = runif(1,0,1) 
    D = inv.q(u)
    
    ### apply censorship ###
    c = runif(1,0,censor)
    cp = rbinom(1,1,censorp)
    if (cp == 0){
      c = 10^10
    }
    t.star = min(max,c)
    ind.star = 0
    if (!is.na(D) && D<=min(max,c)){
      t.star = D
      ind.star = 1
    }
    T0 = t.star + r0[m]
    
    ####### simulate recurrent data #######
    phi.r = z*gamma[1]+sex*beta[1]
    t.r = {}
    w = 0
    
    repeat{
      
      w = w + 1
      
      inv.p = function(s){
        temp1.p = log(s)/(mu[m]*nu[m]*exp(phi.r+lr))
        temp2.p = exp(lr[-p])*(Sp-new.Sp[-p])
        temp3.p = cumsum(c(0,temp2.p))
        j = 0
        repeat{
          j = j+1
          t.re = new.Sp[j]-temp1.p[j]-temp3.p[j]/exp(lr[j])
          if ((new.Sp[j]<t.re && t.re<=inf.p[j]) || j>p){
            break
          }
        }
        t.re
      }
      v = runif(1,0,1) 
      t.r[w] = inv.p(v)
      
      if ( sum(t.r)>=t.star || is.na(t.r[w]) ){
        break
      }
    }
    
    ### add up jump times ###
    t.cum = cumsum(t.r)
    if (is.na(t.cum[length(t.cum)])){
      t.cum[length(t.cum)] = max+1
    }
    
    # ### apply censorship ###
    ind = sum(ifelse(t.cum<t.star,1,0))
    if (ind == 0){
      t.cum = t.star
      ind.re = 0
    }else{
      t.cum = c(t.cum[1:ind],t.star)
      ind.re = c(rep(1,ind),0)
    }
    
    re0 = r0[m] + t.cum 
    
    ### save dataset ###
    dataS = rbind(dataS,t(c(m,t.star,T0,r0[m],ind.star,z,sex,seed)))
    temp.row = cbind(m,t.cum,ind.re,z,re0,sex,seed)
    dataL = rbind(dataL,temp.row)
  }
  nameS = c("ID","t.star","T0","r0","censorship","trt","gender","sim")
  nameL = c("ID","time","censor","trt","toltime","gender","sim")
  colnames(dataS) = nameS
  colnames(dataL) = nameL
  datas <<- dataS
  datal <<- dataL
}


################################################


  v = 100
   
  for (idx in 1:1000){
  generation(idx,v)
  
  ###### control number of events ######
  datas.1 = datas[order(datas[,3]),]
  datas.2 = datas.1[which(datas.1[,5]==1),]
  
  if (nrow(datas.2)<v){
    cutoff = datas.2[nrow(datas.2),3]
  }else{
    cutoff = datas.2[v,3]
  }
  
  datas.3 = datas[order(datas[,4]),]
  min = datas.3[1,4]
  
  datas.new = datas[which(datas[,4]<cutoff),]
  for (j in 1:nrow(datas.new)){
    if (datas.new[j,3] > cutoff){
      datas.new[j,2] = cutoff - datas.new[j,4]
      datas.new[j,5] = 0
      datas.new[j,3] = cutoff
    }
  }
  
  mean_dur = cutoff-min
  sample = nrow(datas.new)
  event = sum(datas.new[,5])
  means = c(idx,mean_dur,sample,event)

  fname2 = paste("/pine/scr/j/i/jiawei/proj2/sim_test/ssd/data/ssd",idx,".csv",sep = "")
  write.table(means,file = fname2, sep = ",",col.names = F,row.names = F)
}


