# 数据加载函数集

此文件夹函数主要用于加载实验、模拟、理论的计算结果

## 函数说明

- getExpDataStrcutCellsData  加载实验数据dataStrcutCells的最后一层数据

相当于dataStrcutCells{dataNumIndex,2}.dataField.innerField

> 参数说明:  
 dataStrcutCells: 总体的数据cell  
 dataNumIndex: 获取的数据索引：1~5  
 dataField: 对应的field  
 innerField: 键值  

- loadExpPressureDatas  加载实验的所有压力数据

> dataStrcutCells 总体的数据cell  
 dataNumIndex 获取的数据索引：1~5  
 dataField 对应的field，'rawData','subSpectrumData','saMainFreFilterStruct',若不指定，为rawData

 返回所有测点的压力数据矩阵，列号对应测点号

- loadExpFreMagData  加载实验的所有测点的压力频谱(频率和幅值)

> dataStrcutCells 总体的数据cell  
 dataNumIndex 获取的数据索引：1~5  
 dataField 对应的field，'rawData','subSpectrumData','saMainFreFilterStruct',若不指定，为rawData

 返回两个矩阵，一个是对应的频率矩阵和对应的幅值矩阵

 - loadExpMultFreMagDatas  加载实验数据的压力的倍频信息

加载实验数据的压力的倍频信息，[频率，幅值]

> dataStrcutCells 总体的数据cell  
 dataNumIndex 获取的数据索引：1~5  
 freTimes 倍频信息，可输入：0.5,1,1.5,2,2.5,3  
 dataField 对应的field，'rawData','subSpectrumData','saMainFreFilterStruct',若不指定，为rawData

返回[measurePointFre,measurePointMag]都是1XN向量，N是测点数  

- loadExpPressureMeanData 加载实验压力数据的均值

加载实验压力数据的均值

> dataStrcutCells 总体的数据cell  
 dataNumIndex 获取的数据索引：1~5  
 dataField 对应的field，'rawData','subSpectrumData','saMainFreFilterStruct',若不指定，为rawData