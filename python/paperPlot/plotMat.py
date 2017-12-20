#-*-coding:UTF-8-*-
import matplotlib.pyplot as plt
import numpy as np
import random

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
		errorPlotType:
	Returns:

	"""
	ret = list()
	x = constExpMeasurementPointDistance()
	lengendTexts = map(lambda x: "line:{0}".format(x),range(1,len(combineData)+1))
	dataRang = range(0,13)
	errorPlotType = 'bar'
	if kwargs.han_key("x"):
		x = kwargs["x"]
		del kwargs["x"]
	if kwargs.han_key("lengendTexts"):
		lengendTexts = kwargs["lengendTexts"]
		del kwargs["lengendTexts"]
	if kwargs.han_key("dataRang"):
		dataRang = kwargs["dataRang"]
		del kwargs["dataRang"]
	if kwargs.han_key("errorPlotType"):
		errorPlotType = kwargs["errorPlotType"]
		del kwargs["errorPlotType"]

	for index,cmData in enumerate(combineData):
		y = cmData["mean"]
		y = map(lambda r:y[r],dataRang)
		h = plt.plot(x,y,**kwargs)
		if errorPlotType == 'bar':
			yerr = cmData["std"]
			yerr = map(lambda r:err[r],dataRang)
			plt.errorbar(x,y,yerr,elinewidth=3)
		
		ret.append(h)

	return ret

def plotVesselRang(rangX = [2,3],**kwargs):
	"""在gca下绘制缓冲罐区域
	=======
	rangX : [list] 缓冲罐区域的范围

	kwargs: plt.fill函数的属性 建议颜色facecolor='#F3264255'
	"""
	if not kwargs.han_key("facecolor"):
		kwargs["facecolor"] = '#F3264255'
	[xmin, xmax, ymin, ymax] = plt.axis()
	plt.fill([rangX[0],rangX[1],rangX[1],rangX[0],rangX[0]],[ymin,ymin,ymax,ymax,ymin],**kwargs)
	plt.xlim([xmin,xmax])
	plt.ylim([ymin,ymax])


if __name__ == "__main__":
    x = range(0,10)
    y = map(lambda x: random.random(),range(0,len(x)))
    yerr = np.array(y) * 0.05
    plt.plot(x,y)
    plt.errorbar(x,y,yerr,fmt='.k')
    plt.show()
