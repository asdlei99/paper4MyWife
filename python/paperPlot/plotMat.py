#-*-coding:UTF-8-*-
import matplotlib.pyplot as plt
import numpy as np

def constExpMeasurementPointDistance():
	"""获取第二次实验的x测点对应的距离
	"""
	return [2.5,3,4.78,5.28,5.78,6.28,7.53,8.03,8.53,9.05,9.53,10.03,10.53]

def plotCombineMatData(*combineData,**kwargs):
	"""绘制combineData的图
	绘制combineData的曲线图
	Arguments:
		combineData : 联合数据的list
		kwargs {} 
		x:设置的x值,default:constExpMeasurementPointDistance()
		dataRang:取变量的范围，combineData变量有16个，默认只取13个
	Returns:

	"""
	ret = dict()
	x = constExpMeasurementPointDistance()
	lengendTexts = filter(lambda x: "line:{0}".format(x),range(1,len(combineData)+1))
	dataRang = range(1,14)
	if kwargs.han_key("x"):
		x = kwargs["x"]
		del kwargs["x"]
	if kwargs.han_key("lengendTexts"):
		lengendTexts = kwargs["lengendTexts"]
		del kwargs["lengendTexts"]
	if kwargs.han_key("dataRang"):
		dataRang = kwargs["dataRang"]
		del kwargs["dataRang"]

	for index,cmData in enumerate(combineData):
		y = cmData["mean"]
		h = plt.plot(x,y,**kwargs)
		if index < len(lengendTexts):
			ret[lengendTexts[index]] = h
		else:
			ret["line:{0}".format(index)] = h


if __name__ == "__main__":
    d={"x":1,"y":2,"z":3}
    for key in d:
        print("key:{0}".format(key))
    for key,val in d.items():
        print("{0}:{1}".format(key,val))
