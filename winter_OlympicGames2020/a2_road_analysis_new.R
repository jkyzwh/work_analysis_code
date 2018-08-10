# 脚本说明----------------------------------------------------------------------------------------------
# 本程序用于北京冬奥会延庆赛区道路驾驶模拟试验数据分析
# 1. 对驾驶人群体，依据驾驶行为对驾驶人群体进行聚类
# 2. 异常驾驶行为路段提取
# 3. 分析结果的可视化
# ===

# 0.0安装包、路径的初始化------------------------------------------------------------------------

packages_needed <- c('outliers',
                     'rstudioapi',
                     'data.table',
                     'outliers',
                     'stringr',
                     'ggplot2',
                     'ggthemes',
                     'devtools',
                     'plyr',
                     'lubridate',
                     'psych',
                     'factoextra',
                     'proxy',
                     'cluster',
                     'rgl'
                     )
installed <- packages_needed %in% installed.packages()[, 'Package']
if (length(packages_needed[!installed]) >=1){
  install.packages(packages_needed[!installed])
}

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
# source_url("https://raw.githubusercontent.com/githubmao/RiohDS/master/DataInput.R") 

#加载位于上一级文件夹中的basicFun.R脚本文件，加载常用的基本函数，例如排序函数等
pass_off <- as.data.frame(str_locate_all(file_dir,"/"))
pass_off_2 <-pass_off$start[length(pass_off$start)]
source(paste(str_sub(file_dir,1,pass_off_2),"basicFun.R",sep = ''))
source(paste(str_sub(file_dir,1,pass_off_2),"DataInitialization.R",sep = ''))
rm(pass_off,pass_off_2)

#根据操作系统类型，在不同路径加载数据集
if(OStype == "Windows"){datafolder <- "D:\\PROdata\\Data\\2018Olympics\\Driver_Data\\up"}
if(OStype == "Linux"){datafolder <- "/home/zhwh/Data/2018Olympics/Driver_Data/up" }

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
  oneSec_temp$driver_ID <- i
  allData_import<-rbind(oneSec_temp,allData_import)
}
rm(oneSec_temp)

driverID <- unique(allData_import$driver_ID)

# 1.0========================================================================================
# 1.1 利用MDS方法对运行速度进行降维处理---------------------------------------------------
#  以10米为间距，生成所有驾驶人的速度序列
#  准备数据
Dis_step = 10
for (i in 1:length(driverID)){
  driver_temp <- subset(allData_import, driver_ID == driverID[i], select = c("disFromRoadStart", "speedKMH"))
  driver_temp <- Order.dis(driver_temp, 'disFromRoadStart', step = Dis_step)
  
  if (i == 1){mds_driverData <- driver_temp}
  else if (i >1){
    col_names <- c(as.character(i-1), as.character(i))
    print(col_names)
    mds_driverData <- merge(mds_driverData, driver_temp, by='disFromRoadStart', suffixes = col_names)
  }
  else{}
}


library(MASS)

mds_data.matrix<-t(as.matrix(mds_driverData[, c(-1)])) #将驾驶人特征数据框转化为矩阵

ID_dist<-mds_data.matrix %*% t(mds_data.matrix) #采用矩阵相乘的方式
#ID_dist<-(mds_data.matrix)  #不采用矩阵相乘的方式
ID_dist<-dist(ID_dist,method="euclidean" ) #计算欧式距离

#采用标准MDS分析,k是降维后数据的维度
ID_MDS<-cmdscale(ID_dist,k=2,eig=T) 
ID_MDS_3D<-cmdscale(ID_dist,k=3,eig=T) 
#ID_MDS<-isoMDS(ID_dist) #非参数iso分析


#这是为了检测能否用两个维度的距离来表示高维空间中距离，如果达到了0.8左右则表示是合适的。
sum(abs(ID_MDS$eig[1:2]))/sum(abs(ID_MDS$eig))
sum((ID_MDS$eig[1:2])^2)/sum((ID_MDS$eig)^2)

# 汇总mds降维分析的结果，作为聚类分析的基础
# 降维为2D
mds_result <- data.frame(ID_MDS$points[,1], ID_MDS$points[,2], driverID)
names(mds_result) <- c('dimension1', 'dimension2', 'driver_ID')
row.names(mds_result) <- mds_result$driver_ID

# 降维为3D
mds_result_3D <- data.frame(ID_MDS_3D$points[,1], ID_MDS_3D$points[,2], ID_MDS_3D$points[,3], driverID)
names(mds_result_3D) <- c('dimension1', 'dimension2', 'dimension3','driver_ID')
row.names(mds_result_3D) <- mds_result$driver_ID
# 方便制图，将驾驶人ID字段转化为因子类型
mds_result$driver_ID <- as.factor(mds_result$driver_ID)
mds_result_3D$driver_ID <- as.factor(mds_result_3D$driver_ID)

ggplot(data=mds_result,aes(x=dimension1, y=dimension2, group=driver_ID))+
  geom_point(shape=16,size=8, aes(colour=driver_ID))+
  geom_text(alpha=0.5,colour="black",size=4,aes(label=mds_result$driver_ID))+
  theme_gdocs()
# 绘制降维至三维空间的可视化展示
# library(rgl)
# plot3d(mds_result_3D$dimension1, mds_result_3D$dimension2, mds_result_3D$dimension3,
#        col = 'red', type="s", size=1.5, lit=FALSE, xlab = "X", ylab="Y", zlab = "Z")
# 
# surface3d(mds_result_3D$dimension1, mds_result_3D$dimension2, mds_result_3D$dimension3,
#           alpha=0.4, front="lines", back="lines")
# 
# movie3d(spin3d(axis=c(0,0,1),rpm=3),duration=10,fps=50)

# 2.0=================================================================================================
# 2.0使用聚类方法，将不同驾驶人的运行速度特征聚类为不同的驾驶人群体分类=============================

# 2.1计算相关系数矩阵------------------------------------------------------------------------------
data_cor <- mds_driverData[, c(-1)]
names(data_cor) <- as.character(driverID)
driver_speed_cor<-cor(data_cor)
rm(data_cor)

# 2.2 利用k聚类方法对驾驶人群体进行聚类======================================================================
library(proxy)
library(cluster)
library(factoextra)

# 对mds结果进行归一化处理

mds_result$dimension1 <- (mds_result$dimension1-min(mds_result$dimension1))/
  (max(mds_result$dimension1)-min(mds_result$dimension1))
mds_result$dimension2 <- (mds_result$dimension2-min(mds_result$dimension2))/
  (max(mds_result$dimension2)-min(mds_result$dimension2))

# 使用函数clusGap()来计算用于估计最优聚类数。函数fviz_gap_stat()用于可视化。
set.seed(123)
# 计算不同K值的效度
gap_stat <- clusGap(mds_result[1:2], FUN = kmeans, nstart = 5, K.max = 10, B = 500)
# 用折线图可视化K值效度变化趋势
fviz_gap_stat(gap_stat)
#K均值聚类函数
cluster_model <- kmeans(mds_result[1:2], centers=3, nstart = 5)
#用可视化方法分析聚类结果
fviz_cluster(cluster_model, mds_result[1:2])

# 利用增强聚类eclust函数调用层次聚类方法"hclust"进行聚类
res.km = eclust(mds_result[1:2],k = NULL, k.max = 10, FUNcluster="hclust")

# eclust聚类的可视化
fviz_gap_stat(res.km$gap_stat)
fviz_cluster(res.km,mds_result[1:2]) # scatter plot

mds_result$cluster <- res.km$cluster
cluster_result <- mds_result[, c(-1, -2)]

# 2.3 将聚类结果merge进导入的原始数据============================================
# 为了merge，将驾驶人ID转化为与导入原始数据框一致的整型数据
cluster_result$driver_ID <- as.numeric(as.character(cluster_result$driver_ID))
allData_clustered <- merge(allData_import, cluster_result, by='driver_ID',all = TRUE)
cluster_group <- unique(cluster_result$cluster)  # 聚类标签数组


# 3.0=============================================================================
# 3.1 按照聚类结果分别分析

cluster1 <- subset(allData_clustered, cluster == cluster_group[2])
cluste1_driverID <- unique(cluster1$driver_ID)

cluste1_step <- data.frame()
Dis_step = 1

for (i in 1:length(cluste1_driverID)){
  driver_temp <- subset(cluster1, driver_ID == cluste1_driverID[i],
                        select = c("disFromRoadStart", "speedKMH", 'driver_ID'))
  driver_temp <- Order.dis(driver_temp, 'disFromRoadStart', step = Dis_step)
  cluste1_step <- rbind(driver_temp,cluste1_step)
}
rm(driver_temp)

library(ggplot2)

allData_import_step$driver_ID <- as.factor(allData_import_step$driver_ID)


ggplot(data=cluste1_step, aes(x=disFromRoadStart,y=speedKMH, colour=driver_ID))+
  geom_point()+
  facet_wrap(~driver_ID,nrow=3)+
  labs(x="Location",y="speed(km/h)",title="speed - Dis")


# 4.0 求解同一类驾驶人，运行速度的安全标准



  
  
  












