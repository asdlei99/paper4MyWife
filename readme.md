# 实验及理论、模拟的程序

## 文件夹及代码说明

### 文件夹说明

- czyLib

通用程序库，包含了一些常用的操作

- dataProcess

数据处理程序集，用于进行实验，模拟的数据处理

- path

路径相关的定义，一些常用路径的定义在此

### 本目录代码说明

- dataProcessCombineDataStructCells

处理预处理的dataStructCells,可以把dataStructCells里的n组数据合并,主要用combineExprimentMatFile.m进行数据的合并，详细可见combineExprimentMatFile的说明

- dataProcessForCombineStruct

数据预处理 - 处理一个已经进行预处理的联合数据(dataStructCells)，就是后缀带combine的数据结构体，此处理需要在缓冲罐数据已经处理完成的情况下进行，处理过程会和缓冲罐的数据进行结合，计算和单一缓冲罐的比值

- dataProcessForOneExpFile

处理一个实验excel数据，处理的结果将在数据文件夹下生成和excel文件同名的mat文件，此文件包含所有excel数据信息和预处理结果

- **dataProcessForOneFolderExpFileAndCombine**

处理一个文件夹下的所有excel数据，并把所有的结果合并为combine数据,combine数据文件名后面都带有**combine**,combine数据把这个文件夹下的所有实验excel进行了整合，因此，不要把非此次实验的数据放在一个文件夹下

