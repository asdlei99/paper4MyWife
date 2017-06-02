# 数据加载函数集

此文件夹函数主要用于加载实验、模拟、理论的计算结果

## 函数说明

- loadExpPressureDatas  加载实验的所有压力数据

> dataStrcutCells：数据cells，对应普通压力数据  
 Num： 压力数据对应分组，一共1~5组  
 dataField: 加载的结构字段，可选,默认为'rawData',可选为：'subSpectrumData','saMainFreFilterStruct','incrementDenoisingStruct'

 