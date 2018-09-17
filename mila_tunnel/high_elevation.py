# -*- coding: utf-8 -*-
"""
Created on Tue Jul 04 2018
本程序用于分析海拔高度与人生理指标与身体反馈能力
基本要点：
1. D:\PROdata\Data\mila_tunnel\1basic.csv :海拔与血压、血氧、脉搏的关系数据，30个测试样本
@author: Zhwh-notbook
"""

# ==============================================================================
'''
判断工作目录，操作系统，指定输入文件位置
'''
import sys
scrip_dir = sys.path[len(sys.path)-1]  # d当前脚本所在路径
# --------------------------------------------------
import platform
operation_system = platform.system()

if operation_system == 'Windows':
    elevation_oxygen_datapath = 'D:\\PROdata\\Data\\mila_tunnel\\1basic.csv'
elif operation_system == 'Linux':
    elevation_oxygen_datapath = '/home/zhwh/Data/mila_tunnel/1basic.csv'
else:
    pass

# ==============================================================================
# 导入海拔高度与人生理特征的数据
# ==============================================================================
import numpy as np
import pandas as pd
import math

'''
导入海拔与生心理若干指标的数据
'''
# --------------------------------------------------------------------
# 序号	被试编号	被试姓名	性别	设备参数	实际海拔	试验顺序	高压	低压	血氧	脉搏
col_names = ["serial_NO", "test_ID", "name", "sex", "equipment_para", "elevation", "test_order",
             "bloodpressure_high", 	 "bloodpressure_low", "oxygen", "plus"]
elevation_oxygen = pd.read_csv(elevation_oxygen_datapath,
                               header=None,
                               names=col_names,
                               skiprows=[0],
                               encoding="gbk")  # 支持中文字符集

ID_list = elevation_oxygen.drop_duplicates(['test_ID'])['test_ID']  # 获取所有的驾驶人ID列表

del(col_names, elevation_oxygen_datapath)
# ---------------------------------------------------------------------
'''
将生心理指标转化为相对于海拔为0时的倍数
'''
elevation = pd.DataFrame()
for i in range(len(ID_list)):
    ID = ID_list.iloc[i]
    temp_ID = elevation_oxygen[elevation_oxygen['test_ID'] == ID].copy()
    bloodpressure_h = temp_ID[temp_ID['elevation'] == 1]['bloodpressure_high'].iloc[0]
    bloodpressure_l = temp_ID[temp_ID['elevation'] == 1]['bloodpressure_low'].iloc[0]
    oxygen_0 = temp_ID[temp_ID['elevation'] == 1]['oxygen'].iloc[0]
    plus_0 = temp_ID[temp_ID['elevation'] == 1]['plus'].iloc[0]
    temp_ID['bloodpressure_hratio'] = temp_ID["bloodpressure_high"]/bloodpressure_h
    temp_ID['bloodpressure_lratio'] = temp_ID["bloodpressure_low"]/bloodpressure_l
    temp_ID['oxygen_ratio'] = temp_ID["oxygen"]/oxygen_0
    temp_ID['plus_ratio'] = temp_ID["plus"]/plus_0
    elevation = pd.concat([elevation, temp_ID], ignore_index=True, sort=False)  # 将所有数据合并
    print('正在处理第', i, '名被试数据')
elevation['oxygen_multi_plus'] = elevation['oxygen_ratio'] * elevation['plus_ratio']
del(ID, temp_ID, bloodpressure_h, bloodpressure_l, oxygen_0, plus_0)
'''
六个海拔水平对应的真实海拔高度
海拔	相对海拔	实际海拔（m）
0.5	1	162
3.5	2	1015
6.5	3	2146
8.5	4	3085
12	5	3962
6.5(K)	6	5100
替换海拔水平为真实海拔高度数值
'''
elevation_value = elevation.copy()
elevation_value['elevation'] = elevation_value['elevation'].replace(1, 162)
elevation_value['elevation'] = elevation_value['elevation'].replace(2, 1015)
elevation_value['elevation'] = elevation_value['elevation'].replace(3, 2146)
elevation_value['elevation'] = elevation_value['elevation'].replace(4, 3085)
elevation_value['elevation'] = elevation_value['elevation'].replace(5, 3962)
elevation_value['elevation'] = elevation_value['elevation'].replace(6, 5100)
'''
利用plotly进行可视化分析
'''
import plotly as py
import plotly.figure_factory as pyff
import plotly.graph_objs as pygo
pyplot = py.offline.plot

# # 定义一个多子图，分别显示不同被试的海拔水平和血氧关系图——海拔水平
# fig1 = py.tools.make_subplots(rows=len(ID_list), cols=1)
# # 利用循环增加每个被试的子图
# for i in range(len(ID_list)):
#     ID = ID_list.iloc[i]
#     temp_ID = elevation[elevation['test_ID'] == ID].copy()
#     trace_ID = pygo.Scatter(x=temp_ID["elevation"],
#                             y=temp_ID['oxygen_ratio'],
#                             mode='lines+markers',
#                             name=str(temp_ID['test_ID'].iloc[0]))
#     fig1.append_trace(trace_ID, i+1, 1)
# #  定义子图的高度、宽度和名称
# fig1['layout'].update(height=1000*len(ID_list), width=1000, title='被试海拔水平与血氧的关系图')
# pyplot(fig1, filename='每个被试海拔水平与血氧的关系.html')
# del(fig1, ID, temp_ID, trace_ID)
#
# # 定义一个多子图，分别显示不同被试的海拔数值和血氧关系图——真实海拔数值
# fig2 = py.tools.make_subplots(rows=len(ID_list), cols=1)
# # 利用循环增加每个被试的子图
# for i in range(len(ID_list)):
#     ID = ID_list.iloc[i]
#     temp_ID = elevation_value[elevation['test_ID'] == ID].copy()
#     trace_ID = pygo.Scatter(x=temp_ID["elevation"],
#                             y=temp_ID['oxygen_ratio'],
#                             mode='lines+markers',
#                             name=str(temp_ID['test_ID'].iloc[0]))
#     fig2.append_trace(trace_ID, i+1, 1)
# #  定义子图的高度、宽度和名称
# fig2['layout'].update(height=1000*len(ID_list), width=1000, title='被试海拔数值与血氧的关系图')
# pyplot(fig2, filename='每个被试海拔数值与血氧的关系.html')
# del(fig2, ID, temp_ID, trace_ID)

# 定义一个多子图，分别显示不同被试的海拔数值和血氧关系图——真实海拔数值
# 按照五行六列排列
fig2 = py.tools.make_subplots(rows=int(len(ID_list)/6+1), cols=6)
# 利用循环增加每个被试的子图
for i in range(len(ID_list)):
    ID = ID_list.iloc[i]
    temp_ID = elevation_value[elevation['test_ID'] == ID].copy()
    trace_ID = pygo.Scatter(x=temp_ID["elevation"],
                            y=temp_ID['oxygen_ratio'],
                            mode='lines+markers',
                            name=str(temp_ID['test_ID'].iloc[0]))
    row_num = math.ceil((i+1)/6)
    col_num = (i+1)-(row_num-1)*6
    fig2.append_trace(trace_ID, row_num, col_num)
#  定义子图的高度、宽度和名称
fig2['layout'].update(height=600*len(ID_list)/6, width=6000, title='被试海拔数值与血氧的关系图')
pyplot(fig2, filename='每个被试海拔数值与血氧的关系.html')
del(fig2, ID, temp_ID, trace_ID, row_num, col_num)

#  多个被试的数据聚合在一起的可视化
#  以海拔水平为横轴
trace_ID1 = pygo.Scatter(x=elevation["elevation"],
                         y=elevation['oxygen_ratio'],
                         mode='lines+markers')
py_data = [trace_ID1]
pyplot(py_data, filename='被试海拔水平与血氧的关系图.html')
del(trace_ID1, py_data)

#  以海拔真实数值为横轴
trace_ID2 = pygo.Scatter(x=elevation_value["elevation"],
                         y=elevation_value['oxygen_ratio'],
                         mode='lines+markers')
py_data = [trace_ID2]
pyplot(py_data, filename='被试海拔数值与血氧的关系图.html')
del(trace_ID2, py_data)

'''
构建被试不同海拔血氧变化率的矩阵，用于被试在不同海拔条件下特征的聚类分析
'''
test_feature = pd.DataFrame()
test_feature['test_ID'] = ID_list
test_feature['name'] = ''
test_feature['E_1'] = 0
test_feature['E_2'] = 0
test_feature['E_3'] = 0
test_feature['E_4'] = 0
test_feature['E_5'] = 0
test_feature['E_6'] = 0

for i in range(len(test_feature['test_ID'])):
    print('处理第', i, '名被试的试验数据')
    ID = test_feature['test_ID'].iloc[i]
    temp_ID = elevation[elevation['test_ID'] == ID].copy()
    test_feature['name'].iloc[i] = temp_ID['name'].iloc[0]
    test_feature['E_1'].iloc[i] = temp_ID['oxygen_ratio'].iloc[0]
    test_feature['E_2'].iloc[i] = temp_ID['oxygen_ratio'].iloc[1]
    test_feature['E_3'].iloc[i] = temp_ID['oxygen_ratio'].iloc[2]
    test_feature['E_4'].iloc[i] = temp_ID['oxygen_ratio'].iloc[3]
    test_feature['E_5'].iloc[i] = temp_ID['oxygen_ratio'].iloc[4]
    test_feature['E_6'].iloc[i] = temp_ID['oxygen_ratio'].iloc[5]
del(ID, temp_ID)
#  将数据输出为web表格
# feature_table = pyff.create_table(test_feature, index=True, index_title='Index')
# feature_table.layout.width = 1500
# pyplot(feature_table, filename='table.html')

'''
利用E_2~E_6，共五个特征值进行聚类分析
'''

#from sklearn.cluster import AffinityPropagation as AP
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score as lkxs    #计算聚类的轮廓系数

'''
AP聚类方法代码
ap = AP(preference=-10).fit(test_AP)
ap.cluster_centers_indices_
ap.labels_

n_clusters_ = len(cluster_centers_indices)    # 预测聚类中心的个数
'''
test_Kmean = test_feature[['E_1', 'E_2', 'E_3', 'E_4', 'E_5', 'E_6']]
test_Kmean = test_Kmean.values
'''
利用轮廓系数方法求解最合适的聚类数
'''
k_max = 0
lkxs_max = 0

for i in [3, 4, 5, 6]:
    K = KMeans(n_clusters=i)
    K.fit(test_Kmean)
    sc_score = lkxs(test_Kmean, K.labels_, metric='euclidean')
    if sc_score > lkxs_max:
        lkxs_max = sc_score
        k_max = i
    print('聚类数为', i, '  ;', '轮廓系数=', sc_score)
print('轮廓系数最高的聚类数为：',  k_max)

'''
利用内部度量Calinski-Harabasz系数选择最佳的聚类k值
'''
from sklearn import metrics
k_max = 0
ch_max = 0

for i in [3, 4, 5, 6]:
    K = KMeans(n_clusters=i)
    K.fit(test_Kmean)
    sc_score = metrics.calinski_harabaz_score(test_Kmean, K.labels_)
    if sc_score > ch_max:
        ch_max = sc_score
        k_max = i
    print('聚类数为', i, '  ;', '内部度量Calinski-Harabasz系数=', sc_score)
print('内部度量Calinski-Harabasz系数最高的聚类数为：',  k_max)

#  利用内部度量系数最高的聚类数进行后续的数据分析工作
K = KMeans(n_clusters=k_max)
K.fit(test_Kmean)
test_feature['cluster_labels'] = K.labels_
# 被试ID与聚类标签的对应
cluster = test_feature[['test_ID', 'cluster_labels']]
# 每类标签下被试的数量
cluster_len = [len(cluster[cluster['cluster_labels'] == 0]),
               len(cluster[cluster['cluster_labels'] == 1]),
               len(cluster[cluster['cluster_labels'] == 2])]
elevation_clustered = pd.merge(elevation_value, cluster, on='test_ID')

del(test_Kmean, cluster, k_max, ch_max, sc_score, K, lkxs_max)

'''
聚类结果的可视化
'''
cluster_1 = elevation_clustered[elevation_clustered['cluster_labels'] == 0]
trace_c1 = pygo.Scatter(x=cluster_1["elevation"],
                        y=cluster_1['oxygen_ratio'],
                        mode='lines+markers')
py_data = [trace_c1]
pyplot(py_data, filename='第一类被试海拔数值与血氧的关系图.html')

# 按照五行六列排列,绘制每个被试的特征数据
ID_list = cluster_1.drop_duplicates(['test_ID'])['test_ID']  # 获取所有的驾驶人ID列表
fig1 = py.tools.make_subplots(rows=int(cluster_len[0]/6+1),
                              cols=6
                              )
# 利用循环增加每个被试的子图

for i in range(cluster_len[0]):
    ID = ID_list.iloc[i]
    temp_ID = cluster_1[cluster_1['test_ID'] == ID].copy()
    trace_ID = pygo.Scatter(x=temp_ID["elevation"],
                            y=temp_ID['oxygen_ratio'],
                            mode='lines+markers',
                            name=str(temp_ID['test_ID'].iloc[0]))
    row_num = math.ceil((i+1)/6)
    col_num = (i+1)-(row_num-1)*6
    print(i, row_num, col_num)
    fig1.append_trace(trace_ID, row_num, col_num)

#  定义子图的高度、宽度和名称
fig1['layout'].update(height=600*int(cluster_len[0]/6+1), width=6000, title='被试海拔数值与血氧的关系图')
pyplot(fig1, filename='第一类被试海拔数值与血氧的关系.html')


# -----------------------
cluster_2 = elevation_clustered[elevation_clustered['cluster_labels'] == 1]
trace_c2 = pygo.Scatter(x=cluster_2["elevation"],
                        y=cluster_2['oxygen_ratio'],
                        mode='lines+markers')
py_data = [trace_c2]
pyplot(py_data, filename='第二类被试海拔数值与血氧的关系图.html')

# 按照五行六列排列,绘制每个被试的特征数据
ID_list = cluster_2.drop_duplicates(['test_ID'])['test_ID']  # 获取所有的驾驶人ID列表
fig1 = py.tools.make_subplots(rows=int(cluster_len[1]/6+1),
                              cols=6
                              )
# 利用循环增加每个被试的子图

for i in range(cluster_len[1]):
    ID = ID_list.iloc[i]
    temp_ID = cluster_2[cluster_2['test_ID'] == ID].copy()
    trace_ID = pygo.Scatter(x=temp_ID["elevation"],
                            y=temp_ID['oxygen_ratio'],
                            mode='lines+markers',
                            name=str(temp_ID['test_ID'].iloc[0]))
    row_num = math.ceil((i+1)/6)
    col_num = (i+1)-(row_num-1)*6
    print(i, row_num, col_num)
    fig1.append_trace(trace_ID, row_num, col_num)

#  定义子图的高度、宽度和名称
fig1['layout'].update(height=600*int(cluster_len[1]/6+1), width=6000, title='被试海拔数值与血氧的关系图')
pyplot(fig1, filename='第二类被试海拔数值与血氧的关系.html')

# ----------------------
cluster_3 = elevation_clustered[elevation_clustered['cluster_labels'] == 2]
trace_c3 = pygo.Scatter(x=cluster_3["elevation"],
                        y=cluster_3['oxygen_ratio'],
                        mode='lines+markers')
py_data = [trace_c3]
pyplot(py_data, filename='第三类被试海拔数值与血氧的关系图.html')

# 按照五行六列排列,绘制每个被试的特征数据
ID_list = cluster_3.drop_duplicates(['test_ID'])['test_ID']  # 获取所有的驾驶人ID列表
fig1 = py.tools.make_subplots(rows=int(cluster_len[2]/6+1),
                              cols=6
                              )
# 利用循环增加每个被试的子图

for i in range(cluster_len[2]):
    ID = ID_list.iloc[i]
    temp_ID = cluster_3[cluster_3['test_ID'] == ID].copy()
    trace_ID = pygo.Scatter(x=temp_ID["elevation"],
                            y=temp_ID['oxygen_ratio'],
                            mode='lines+markers',
                            name=str(temp_ID['test_ID'].iloc[0]))
    row_num = math.ceil((i+1)/6)
    col_num = (i+1)-(row_num-1)*6
    print(i, row_num, col_num)
    fig1.append_trace(trace_ID, row_num, col_num)

#  定义子图的高度、宽度和名称
fig1['layout'].update(height=600*int(cluster_len[2]/6+1), width=6000, title='被试海拔数值与血氧的关系图')
pyplot(fig1, filename='第三类被试海拔数值与血氧的关系.html')
del(cluster_1, cluster_2, cluster_3)
del(ID, ID_list, row_num, col_num, trace_ID, temp_ID, trace_c1, trace_c2, trace_c3)
del(fig1, py_data)

# -----------------------------------------------------------------------------------------------------
# 分析简单反应时数据
# -----------------------------------------------------------------------------------------------------
# 定义简单反应时数据的路径
if operation_system == 'Windows':
    simple_datapath = 'D:\\PROdata\\Data\\mila_tunnel\\2simple.csv'
elif operation_system == 'Linux':
    simple_datapath = '/home/zhwh/Data/mila_tunnel/2simple.csv'
else:
    pass
# 导入简单反应时数据
col_names = ["serial_NO", "test_ID", "name", "sex", "equipment_para", "elevation", "test_order",
             "1", "2", "3", "4", '5', '6', '7', '8', '9', '10',
             "11", "12", "13", "14", '15', '16', '17', '18', '19', '20',
             "21", "22", "23", "24", '25', '26', '27', '28', '29', '30']
simple = pd.read_csv(simple_datapath,
                               header=None,
                               names=col_names,
                               skiprows=[0],
                               encoding="gbk")  # 支持中文字符集
del(col_names, simple_datapath)

# 筛选一行观测值，去除异常值，求解统计量
simple['mean'] = 0
for index, row in simple.iterrows():
    origin = row[["1", "2", "3", "4", '5', '6', '7', '8', '9', '10',
                 "11", "12", "13", "14", '15', '16', '17', '18', '19', '20',
                 "21", "22", "23", "24", '25', '26', '27', '28', '29', '30']]
    print('正在处理index为', index, '的数据')
    origin = pd.to_numeric(origin)
    # 利用三倍方差做为标准，去除异常值
    ab_std1 = origin.mean() + 3*origin.std()
    ab_std2 = origin.mean() - 3*origin.std()
    no_abnormal = origin[origin < ab_std1]
    no_abnormal = no_abnormal[no_abnormal > ab_std2]
    simple['mean'].loc[index] = no_abnormal.mean()

# origin = simple.iloc[0]
# origin = origin[["1", "2", "3", "4", '5', '6', '7', '8', '9', '10',
#                  "11", "12", "13", "14", '15', '16', '17', '18', '19', '20',
#                  "21", "22", "23", "24", '25', '26', '27', '28', '29', '30']]
# origin = pd.to_numeric(origin)
# # 利用三倍方差做为标准，去除异常值
# ab_std1 = origin.mean() + 3*origin.std()
# ab_std2 = origin.mean() - 3*origin.std()
# no_abnormal = origin[origin < ab_std1]
# no_abnormal = no_abnormal[no_abnormal > ab_std2]
ID_list = simple.drop_duplicates(['test_ID'])['test_ID']  # 获取所有的驾驶人ID列表
simple_mean = pd.DataFrame()
for i in range(len(ID_list)):
    ID = ID_list.iloc[i]
    temp_ID = simple[simple['test_ID'] == ID].copy()
    mean_0 = temp_ID[temp_ID['elevation'] == 1]['mean'].iloc[0]
    temp_ID['mean_ratio'] = temp_ID["mean"]/mean_0
    simple_mean = pd.concat([simple_mean, temp_ID], ignore_index=True, sort=False)  # 将所有数据合并
    print('正在处理第', i+1, '名被试数据')
simple_mean = simple_mean[["test_ID", "name", "sex", "elevation", 'mean', 'mean_ratio']]
del(ID, temp_ID, mean_0)

# 将简单反应时数据与血氧数据融合

# 被试ID与血氧特征聚类标签的对应
simple_mean['oxygen_ratio'] = elevation_clustered['oxygen_ratio']
simple_mean['oxygen'] = elevation_clustered['oxygen']
simple_mean['elevation_value'] = elevation_clustered['elevation']
cluster = test_feature[['test_ID', 'cluster_labels']]
simple_clustered = pd.merge(simple_mean, cluster, on='test_ID')
# 每类标签下被试的数量
cluster_len = [len(cluster[cluster['cluster_labels'] == 0]),
               len(cluster[cluster['cluster_labels'] == 1]),
               len(cluster[cluster['cluster_labels'] == 2])]
simple_cluster1 = simple_clustered[simple_clustered['cluster_labels'] == 0]

'''
可视化海拔与简单反应时的关系
'''

# 按照五行六列排列,绘制每个被试的特征数据
ID_list = simple_cluster1.drop_duplicates(['test_ID'])['test_ID']  # 获取所有的驾驶人ID列表
fig1 = py.tools.make_subplots(rows=int(len(ID_list)/6+1),
                              cols=6
                              )
# 利用循环增加每个被试的子图

for i in range(len(ID_list)):
    ID = ID_list.iloc[i]
    temp_ID = simple_cluster1[simple_cluster1['test_ID'] == ID].copy()
    trace_ID = pygo.Scatter(x=temp_ID['elevation_value'],
                            y=temp_ID['mean_ratio'],
                            mode='lines+markers',
                            name=str(temp_ID['test_ID'].iloc[0]))
    row_num = math.ceil((i+1)/6)
    col_num = (i+1)-(row_num-1)*6
    print(i, row_num, col_num)
    fig1.append_trace(trace_ID, row_num, col_num)

#  定义子图的高度、宽度和名称
fig1['layout'].update(height=(800*len(ID_list)/6+1), width=6000, title='被试海拔数值与血氧的关系图')
pyplot(fig1, filename='第一类被试海拔高度与简单反应时变化的关系.html')

'''
可视化血氧与简单反应时的关系
'''

# 按照五行六列排列,绘制每个被试的特征数据
ID_list = simple_cluster1.drop_duplicates(['test_ID'])['test_ID']  # 获取所有的驾驶人ID列表
fig1 = py.tools.make_subplots(rows=int(len(ID_list)/6+1),
                              cols=6
                              )
# 利用循环增加每个被试的子图

for i in range(len(ID_list)):
    ID = ID_list.iloc[i]
    temp_ID = simple_cluster1[simple_cluster1['test_ID'] == ID].copy()
    trace_ID = pygo.Scatter(x=temp_ID['oxygen'],
                            y=temp_ID['mean_ratio'],
                            mode='lines+markers',
                            name=str(temp_ID['test_ID'].iloc[0]))
    row_num = math.ceil((i+1)/6)
    col_num = (i+1)-(row_num-1)*6
    print(i, row_num, col_num)
    fig1.append_trace(trace_ID, row_num, col_num)

#  定义子图的高度、宽度和名称
fig1['layout'].update(height=(800*len(ID_list)/6+1), width=6000, title='被试海拔数值与血氧的关系图')
pyplot(fig1, filename='第一类被试血氧与简单反应时变化的关系.html')
