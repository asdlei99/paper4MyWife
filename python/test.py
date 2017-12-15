import paperDataLoad.loadMatData as paperLoad
import numpy as np
dit = paperLoad.loadExpMatData("e:/netdisk/shareCloud/【大论文】/[04]数据/实验原始数据/无内件缓冲罐/单罐直进直出420转0.05mpaModify/")
# if "combineDataStruct" in dit:
#     rawData = dit["combineDataStruct"]["combineDataStruct"]["rawData"]
#     rawData = rawData[0][0]
#     print(rawData.dtype)
#     print(rawData[0]["multFreMag1"])
multFreMag1 = paperLoad.getCombineDataStructFieldInfo(dit["combineDataStruct"], "multFreMag1")
multFreMag2 = paperLoad.getCombineDataStructFieldInfo(dit["combineDataStruct"], "multFreMag2")
multFreMag3 = paperLoad.getCombineDataStructFieldInfo(dit["combineDataStruct"], "multFreMag3")
print(multFreMag1)

