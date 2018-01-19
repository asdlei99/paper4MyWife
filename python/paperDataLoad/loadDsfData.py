#-*-coding:UTF-8-*-
import numpy as np
import struct as st
import array
import os
import matplotlib.pyplot as plt

def loadDsfData(filePath):
    """加载目录下的dsf文件
    Descripe:
		filePath [string] 文件路径
	Return:
		headerDict : dict 文件头的字典 {'KindOfData':int
										,'RMSValue':float
										,'PpValue':float
										,'KurValue':float
										,'SampleLen':int
										,'SampleFre':int
										,'Gain':short
										,'Filter':short
										,'OutTrigger':short
										,'Integral':short}
		wave : list 波形
    """
    with open(filePath,mode='rb') as fld:
        fld.seek(0)
        headerDict = dict();
        byteBuffer = fld.read(4)
        nType = st.unpack('i',byteBuffer)
        nType = nType[0]
        if 100 == nType:
            # 读文件头
            fld.seek(608)
            byteBuffer = fld.read(32)
            res = st.unpack('ifffiihhhh',byteBuffer)
            headerDict['KindOfData'] = res[0]
            headerDict['RMSValue'] = res[1]
            headerDict['PpValue'] = res[2]
            headerDict['KurValue'] = res[3]
            headerDict['SampleLen'] = res[4]
            headerDict['SampleFre'] = res[5]
            headerDict['Gain'] = res[6]
            headerDict['Filter'] = res[7]
            headerDict['OutTrigger'] = res[8]
            headerDict['Integral'] = res[9]
            # 读波形
            fld.seek(640)
            ar = array.array('f')
            ar.fromfile(fld,headerDict['SampleLen'])
            wave = ar.tolist()
            return headerDict,wave


	


if __name__ == '__main__':
	print('__main__')