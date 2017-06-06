# 管道传递矩阵

此文件夹存放基本传递矩阵

## 函数说明

- straightPipeTransferMatrix 直管传递矩阵

![straightPipeTransferMatrix](https://github.com/czyt1988/paper4MyWife/blob/master/transferMatrix/doc/straightPipeTransferMatrix.png)

> 输入L:管长(m)  
可变参数:  
's':截面  
'd':管道直径  
'k':波数  
'oumiga':圆频率  
'f':脉动频率  
'a':声速  
'acousticvelocity':声速,'acoustic':声速  
'isdamping':是否包含阻尼  
'coeffdamping':阻尼系数,'damping':阻尼系数  
'friction':管道摩擦系数，计算阻尼系数时使用,'coefffriction':管道摩擦系数，计算阻尼系数时使用  
'meanflowvelocity':平均流速，计算阻尼系数时使用,'flowvelocity':平均流速，计算阻尼系数时使用  
'mach':马赫数，加入马赫数将会使用带马赫数的公式计算 | 'm'  
'notmach':不适用马赫  
'calcway2':第二种计算方法  
'dynvis':动力学粘度pa-s，'dynviscosity':动力学粘度pa-s  
'density':密度  


