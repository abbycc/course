library(moments)
calculate<-function(data){
  final.data <- NULL
  for ( i in 1:length(metrics) ) {
    #summary(data[,i])
    max <- max(data[,i])
    min <- min(data[,i])
    mean <- mean(data[,i])
    median <- median(data[,i])
    QL <- quantile(data[,i], probs = 0.25)
    QU <- quantile(data[,i], probs = 0.75)
    skew <- skewness(data[,i])      
    kurt <- kurtosis(data[,i]) - 3  
   
    new.data <- data.frame(metrics[i], min, unname(QL), median, unname(QU), max, mean, skew, kurt)
    final.data <- rbind(final.data, new.data)
  }
  names(final.data) <- c('name', 'min', 'QL', 'median', 'QU', 'max', 'mean', 'skewness', 'kurtosis')
  print(final.data)
  write.csv(final.data,"description.csv")
}


calculate_bug<-function(data,bug){
  final.data <- NULL
  n <- length(metrics)
  for( i in 1:length(metrics) )
  {
    spear <-cor(data[,i],bug,method="spearman")
    spearT <- spear*(sqrt(n-2))/sqrt(1-spear^2)
    pear <- cor(data[,i],bug,method="pearson")
    pearT <- pear*(sqrt(n-2))/sqrt(1-pear^2)
    new.data <- data.frame(metrics[i],spear,spearT,pear,pearT)
    final.data <- rbind(final.data, new.data)
  }
  names(final.data) <- c('name', 'Spearman','Spearman.T', 'Pearson','Pearson.T')
  print(final.data)
  write.csv(final.data,"coefficient.csv")
  }

setwd("C:/Users/zhc/Documents/软件度量/软件度量3次作业/")
read_datas <- read.csv(file = "xalan-2.4.csv")
#read_datas
data <- read_datas[,4:9] 
bug <- read_datas[,24]
metrics <- c('wmc', 'dit', 'noc', 'cbo', 'rfc', 'lcom') 

#calculate(data)
calculate_bug(data,bug)