import scipy.io as sciio
import numpy as np
import os

def loadExpMatData(folderName):
    """加载目录下的实验mat文件
    
    加载目录下的实验mat文件
    
    Arguments:
        folderName {[string]} -- 目录路径
    """ 
    result = dict()
    matDataFilePath = os.path.join(folderName, "combineDataStruct.mat")
    if os.path.exists(matDataFilePath):
        matDict = sciio.loadmat(matDataFilePath)
        result["combineDataStruct"] = matDict

    matDataFilePath = os.path.join(folderName, "dataStructCells.mat")
    if os.path.exists(matDataFilePath):
        matDict = sciio.loadmat(matDataFilePath)
        result["dataStructCells"] = matDict

    matDataFilePath = os.path.join(folderName, "sigmaPlusValue.mat")
    if os.path.exists(matDataFilePath):
        matDict = sciio.loadmat(matDataFilePath)
        result["sigmaPlusValue"] = matDict
    #返回
    return result

def loadSimMatData(folderName):
    """加载目录下的模拟mat文件
    
    加载目录下的模拟mat文件
    
    Arguments:
        folderName {[stringtype]} -- 目录路径
    """
    MAT_DATA_FILE_PATH = os.path.join(folderName, "simulationDataStruct.mat")
    if os.path.exists(MAT_DATA_FILE_PATH):
        matDict = sciio.loadmat(MAT_DATA_FILE_PATH)
        result = dict()
        result["simulationDataStruct"] = matDict
    return result

def getCombineDataStruct(combineDataStructMatData, fieldName):
    """获取CombineDataStruct的对应field的值
    
    获取CombineDataStruct的对应field的值
    
    Arguments:
        folderName {[string]} -- 文件夹
        fieldName {[string]} -- 对应键值
    """
    result = combineDataStructMatData["combineDataStruct"]["rawData"]
    result = result[0][0][0][0][fieldName]
    return result

def getCombineDataStructFieldInfo(combineDataStructMatData, fieldName):
    """获取CombineDataStruct的对应field的统计信息值
    
    获取CombineDataStruct的对应field的统计信息值
    
    Arguments:
        folderName {[string]} -- 文件夹
        fieldName {[string]} -- 对应键值
    Returns:
        dict{均值=array,最大值=array,最小值=array,方差=array}
    """
    result = getCombineDataStruct(combineDataStructMatData, fieldName)
    #计算均值
    res = dict();
    res["mean"] = meanVal = np.mean(result, axis=0)
    #计算方差
    res["std"] = np.std(result, axis=0)
    #计算最大值
    res["max"] = np.max(result, axis=0)
    #计算最小值
    res["min"] = np.min(result, axis=0)
    #返回
    return res

