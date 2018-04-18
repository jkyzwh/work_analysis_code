#-------------------------------------------------------------------------------------------------
# 本程序用于北京冬奥会延庆赛区道路驾驶模拟试验数据分析
#0.0 获取当前脚本所在的目录名称----
# 便于加载位于同一目录下的其它文件
library(rstudioapi)    
file_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
OStype <- Sys.info()['sysname']

# 0.1 加载需要的程序包--------------------------------------------------------------------------
library(data.table)
library(outliers) #加载用于迪克逊检验的包
library(stringr)
library(ggplot2)
library(ggthemes)
library(devtools) #加载 source_url 函数
library(plyr)

# use R script file frome github
source_url("https://raw.githubusercontent.com/githubmao/RiohDS/master/DataInput.R") 

#加载位于上一级文件夹中的basicFun.R脚本文件，加载常用的基本函数，例如排序函数等
pass_off <- as.data.frame(str_locate_all(file_dir,"/"))
pass_off_2 <-pass_off$start[length(pass_off$start)]
source(paste(str_sub(file_dir,1,pass_off_2),"basicFun.R",sep = ''))
rm(pass_off,pass_off_2)

#根据操作系统类型，在不同路径加载数据集
if(OStype == "Windows"){datafolder <- "D:\\PROdata\\Data\\simlogSGH"}
if(OStype == "Linux"){datafolder <- "/home/zhwh/Data/Winter_Olympic_2020" }

# 0.2 加载原始数据-------------------------------------------------------------------------
# 查询数据目录下包含的所有csv文件，将文件名存入temp列表
data_file_Name <- list.files(path=datafolder ,pattern="*.csv") 
# 将文件名的扩展名去掉，即将文件名中的.csv替换为空，存入data_name列表
data_name = gsub('.csv','',data_file_Name) 
# 将所有原始数据导入一个基本数据库
allData_import<-data.frame()
for (i in 1:length(data_file_Name)){
  # 将每个读入csv生成的数据框赋值给对应的变量名
  oneSec_temp <- fread(file=paste(datafolder,data_file_Name[i],sep = '/'),
              header=T,sep=",",stringsAsFactors =FALSE )
  oneSec_temp <- oneSec_temp[,1:89]
  oneSec_temp <- RenameSimDataV12(oneSec_temp)
  oneSec_temp <- subset(oneSec_temp, select=c("logTime",           
  "disFromRoadStart",            
  "speedKMH",
  "yawAngle",
  "accZMS2",   #纵向加速度   
  "accXMS2",   #横向加速度     
  "laneOffset",    
  "appSteering",       
  "appBrake",
  "appGasPedal",
  "logitudinalSlope")
  )
  # 将文件名拆分为行驶方向（上山或下山）与驾驶人编号
  # 注释：直接使用split函数得到的结果是一个列表，如果希望得到一个向量，可以使用unlist函数
  oneSec_temp$direction <- unlist( strsplit(data_name[i], "_"))[1]
  oneSec_temp$driver_ID <- unlist( strsplit(data_name[i], "_"))[2]
  allData_import<-rbind(oneSec_temp,allData_import)
}
rm(oneSec_temp)

#1.0 利用累计频率筛选准则，筛选出现概率较小的异常值-----------------------------

#1.1. 定义函数fun_abnormalACC函数，计算加速和减速异常值标准-----------------------
fun_abnormalACC<-function(simdata,speed_col,group_col,acc_col,gas_col,brake_col,probs=0.95)
{
  simdata$acc <- as.numeric(simdata[[acc_col]])
  simdata$GasPedal <- as.numeric(simdata[[gas_col]])
  simdata$Brake <- as.numeric(simdata[[brake_col]])
  simdata$speed <- as.numeric(simdata[[speed_col]])
  simdata$group <- as.numeric(simdata[[group_col]])
  
  AAC <- subset(simdata,acc >0 & GasPedal > 0)
  DAC <- subset(simdata,acc <0 & Brake > 0)
  
  b1 <- subset(AAC,select = c("group","acc"))
  b1 <- ddply(b1,.(group),numcolwise(quantile),probs=c(probs),na.rm = TRUE)
  
  b2 <- subset(DAC,select = c("group","acc"))
  b2 <- ddply(abs(b2),.(group),numcolwise(quantile),probs=c(probs),na.rm = TRUE)
  
  names(b1) <- c("group","abnormal_aac")
  names(b2) <- c("group","abnormal_dac")
  c <- merge(b1,b2,all=T)
  c$speed_bottom <- 0
  c$speed_top <- 0
  
  for(i in 1:length(c$group)){
    d <- subset(simdata,group == i)
    c$speed_bottom[i] <- floor(min(d$speed))
    c$speed_top[i] <- ceiling(max(d$speed))
  }
  return(c)
}

#  1.1.0 数据分组与计算加速度异常值的测试代码--------
# test_data <- subset(allData_import,direction =="xiashan" & driver_ID == "S06")
# test_data <- subset(test_data,speedKMH >= 1)
# # 将数据集分成相同长度的组别.
# groupNum <- floor(length(test_data$speedKMH)/1000)
# #ceiling向上取整，确定步长（floor为向下取整)
# test_data$speedKMH <- as.numeric(test_data$speedKMH)
# stepLen <- ceiling((max(test_data$speedKMH)-min(test_data$speedKMH))/groupNum)
# test_data$group <- ceiling(test_data$speedKMH/stepLen)
# ab_acc <- fun_abnormalACC(test_data,"speedKMH","group","accZMS2","appGasPedal","appBrake",probs=0.95)

# 1.1.1 计算下山方向的加速度异常值判断标准-----------
all_downHill <- subset(allData_import,direction =="xiashan")
downHill_IDsplit<-split(all_downHill,list(all_downHill$driver_ID))#按照驾驶人ID分割数据
abnormal_acc<-data.frame()
for (i in 1:length(downHill_IDsplit))
{
  #选择一个驾驶人数据ID
  aa<-data.frame(downHill_IDsplit[i])
  #标准化数据框列名
  names(aa)<-colnames(all_downHill)
  # 将数据集分成相同长度的组别.
  groupNum <- floor(length(aa$speedKMH)/1000)
  #ceiling向上取整，确定步长（floor为向下取整)
  aa$speedKMH <- as.numeric(aa$speedKMH)
  stepLen <- ceiling((max(aa$speedKMH)-min(aa$speedKMH))/groupNum)
  aa$group <- ceiling(aa$speedKMH/stepLen)
  #调用函数计算加速和减速异常标准
  cc<-fun_abnormalACC(aa,"speedKMH","group","accZMS2","appGasPedal","appBrake",probs=0.95)
  cc$driver_ID<-aa$driver_ID[i] #增加驾驶人ID列
  abnormal_acc<-rbind(cc,abnormal_acc)
}
rm(cc,aa,i)




















