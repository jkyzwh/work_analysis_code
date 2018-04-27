#----------------------------------------------------------------------------------------------
# 本程序用于利用基于密度的LOF异常值识别算法
#LOF（局部异常因子）是用于识别基于密度的局部异常值的算法。
#使用LOF，一个点的局部密度会与它的邻居进行比较。
#如果前者明显低于后者（有一个大于1 的LOF值），该点位于一个稀疏区域，
#对于它的邻居而言，这就表明，该点是一个异常值。LOF的缺点就是它只对数值数据有效。
#lofactor()函数使用LOF算法计算局部异常因子，它在DMwR和dprep包中是可用的。
#lofactor()函数中，k是用于计算局部异常因子的邻居数量。
##################

# 安装需要的包
if (!require('DMwR')){ install.packages('DMwR')}
if (!require('rstudioapi')){ install.packages('rstudioapi')}

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
library(lubridate)

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

# 1.0 使用LOF算法提取异常值
driverID <- unique(allData_import$driver_ID)
a <- subset(allData_import,driver_ID == driverID[1])
a$accZMS2 <- as.numeric(a$accZMS2)

a <- subset(a,accZMS2<0 & direction == "xiashan")

b <- lofactor(as.numeric(a$accZMS2),k=5)

plot(density(b))
c<- order(b,decreasing = T)[1:10]
d <- a[c,]


         