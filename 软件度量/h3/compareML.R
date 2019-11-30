library(mlr)

setwd("C:/Users/zhc/Documents/软件度量/软件度量3次作业/")

data <- read.csv(file = "xalan-2.4.csv")
features<-data[,4:9]
bugs<-data[,24]


generate_performance<-fuction()
{
  label<-NULL
  for(i in bugs ){
    if(i>0)
      label<-c(label,as.integer(1))
    else
      label<-c(label,as.integer(0))
  }
  
  train_data<-features
  train_data$bugs<-label#把bugs加入到训练的数据集中
  
  
  classif.task = makeClassifTask(data = train_data, target = "bugs")
  learner_names = C("classif.randomForest",#随机森林
                    "classif.mlp",#多层感知机
                    "classif.naiveBayes",#朴素贝叶斯
                    "classif.nnet",#神经网络
                    "classif.svm",#支持向量机
                    "classif.multinom",#多元回归
                    "classif.probit",#单位几率回归
                    "classif.lda",#线性判别分析
                    "classif.ksvm",#支持向量机
                    "classif.mlp"#多层感知机
  )
  
  n = getTaskSize(classif.task)
  
  
  #folds
  final.data <- NULL
  classif.task = makeClassifTask(data = train_data, target = "bugs")
  for(j in 1:10){
    learner = learner_names[j]
    print(learner)
    classif.lrn = makeLearner(learner, predict.type = "prob")#prob为预测概率
    for(k in 1:10){
      #将数据切成十份
      folds<-caret::createFolds(y=train_data$bugs,k=10)
      for(i in 1:10){
        test.set <-folds[[i]]#输入的值为integer
        train.set<-setdiff(1:n, test.set)
        #train
        mod = mlr::train(classif.lrn,classif.task,subset=train.set)
        #predict
        task.pred = predict(mod, task = classif.task, subset = test.set)
        res = performance(task.pred, measures = list(mmce,auc ))  
        model_auc = unname(res['auc'])
        model_ce = (m_auc - 0.5) / 0.5
        new.data <- data.frame(learner,model_auc, model_ce)
        final.data <- rbind(final.data, new.data)
        #print(model_auc)
        #print(model_ce)
        #auc = unname(pre['auc'])
        #ce =  (auc - 0.5) / 0.5  #random的AUC为0.5，最优的为1
      }
    }
    
  }
  
  #names(final.data) <- c('model_name', 'model_auc', 'model_ce')
  print(final.data)
  write.csv(final.data,"model_per.csv")
}

#generate_performance()

read_data<-function()
{
  model_data <- read.csv(file = "model_per.csv")
  auc<-array(model_data$model_auc, dim = c(100, 10))#需要将数组转化为数据帧
  model_auc<-data.frame(auc)
  names(model_auc)<-c('rForest','mlp','nBayes','nnet','svm','mul','probit','lda','ksvm','mlp')
  model_auc
}
per_data<-read_data()
per_data
#######################################################################################
library(ggplot2)
library(Rgraphviz)
library(plotrix)
library(scmamp)
#作CD图比较统计差别
graph_cd <- function(data) {
  png(file = "CD.png")
  plotCD(data, alpha=0.05, cex=1.25)
  dev.off()
}
graph_cd(per_data)

#作algorithm图比较统计差别
graph_algorithm <- function(data) {
  data <- filterData(data, remove.cols=10)  #his method is only available for 9 or less algorithms
  r.means <- colMeans(rankMatrix(data))
  pv.matrix <- friedmanAlignedRanksPost(data, control=NULL)
  pv.adj <- adjustBergmannHommel(pv.matrix)
  png(file = "algorithm.png")
  drawAlgorithmGraph(pvalue.matrix=pv.adj , mean.value=r.means, alpha=0.05)
  dev.off()
}
graph_algorithm(per_data)

#作heatmap图比较统计差别
library(plotrix)
graph_heatmap <- function(data) {
  m <- as.matrix(data)
  png(file = "heatmap.png")
  heatmap(m) #m 矩阵
  dev.off()
}
graph_heatmap(per_data)

