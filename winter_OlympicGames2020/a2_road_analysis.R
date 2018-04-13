# 本程序用于北京冬奥会延庆赛区道路驾驶模拟试验数据分析

#0.0 获取当前脚本所在的目录名称----
# 便于加载位于同一目录下的其它文件
library(rstudioapi)    
file_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)

# 0.1 加载需要的程序包--------------------------------------------------------------------------
library(data.table)
library(ggplot2)
library(ggthemes)

# 0.2 调用函数以及程序过程中不变的常量-------------------------------------------------------------------------
datafolder <- "D:/Data/Winter_Olympic_2020"  # 包含数据文件的文件夹
temp <- list.files(path=datafolder ,pattern="*.csv")#查询数据目录下包含的所有csv文件，将文件名存入temp列表
#source(paste(file_dir, "driver_character_fun_ver0.1.R",sep="/"))

data_name = gsub('.csv','',temp)#将文件名的扩展名去掉，即将文件名中的.csv替换为空，存入data_name列表
all_data<-data.frame()
for (i in 1:length(temp)){
  #将每个读入csv生成的数据框赋值给对应的变量名
  aa<- fread(file=paste(datafolder,temp[i],sep = '/'),header=T,sep=",",stringsAsFactors =FALSE )
  #aa<- get(data_name[i])
  #aa<- fun_rename_data(aa)
  #aa<- subset(aa, select=c("Time",           
  "Dis",            
  "Speed",
  # "Direction_x",
  # "Direction_y",
  # "Direction_z",
  "Yaw",
  "Pitch",
  # "Yaw_speed",
  "Acc_surge",      
  "Acc_sway",       
  "Lane_offset",    
  "Steering",       
  "Brake_pedal",
  "Longitudinal_slope")
)
# 增加ID列，将文件名的前两位（被试编号）赋值给ID
aa$ID<-data_name[i]
aa$Speed<-aa$Speed*3.6
all_data<-rbind(aa,all_data)
# 将调整过的aa重新赋值给data_name对应的变量
#assign(data_name[i],aa)
}
rm(aa)