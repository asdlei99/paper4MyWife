# 论文绘图程序

此文件夹包含所有绘图的基本程序，只包含基本程序而不是最终绘图的程序

目前尽量把所有程序进行细分和抽象，以达到合理复用

## 函数说明

- plotExpPressureWave 绘制实验测点的波形图

参数说明

> dataStructCells : 数据cell，对应普通压力数据  
Num:压力数据对应分组，一共1~5组  
MeasurePoint:测点  
dfield:可选,默认为'rawData',可选为：'subSpectrumData','saMainFreFilterStruct','incrementDenoisingStruct'
