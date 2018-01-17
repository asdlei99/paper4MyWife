#-*-coding:UTF-8-*-
import matplotlib.pyplot as plt
import numpy as np

"""默认字体字典
	默认字体字典
"""
DEFAULT_PAPER_FONT_DICT = {
		'family': 'serif',
		'weight': 'normal',
		'size': 10,
		'color': 'black',
		}

"""默认的线形
默认的线形
"""
LINE_STYLE_STR = ['-','--','-.',':']

"""默认的线形
默认的线形
"""
LINE_STYLE_STR = ['-','--','-.',':']

"""默认的标记
默认的标记
"""
LINE_MARKER_STR = ['.','o','v','^','<','1','>','2','s','3','p','4','*','8','h','+','x','D','H','d']

def show():
    plt.show()

def figureSize(sizeType='normal',height=3):
	"""获取绘图的size

	Keyword Arguments:
		height {[type]} -- [description] (default: {3})
	"""

	fs = (3.5433071,height)
	if sizeType.lower() == 'normal':
		fs = (3.5433071,height)
	elif sizeType.lower() == 'large':
		fs = (5.511811,height)
	elif sizeType.lower() == 'fullWidth':
		fs = (7.480315,height)
	return fs

def paperFigure(sizeType='normal',height=3):
	"""替代plt.figure的函数，可以根据论文的固定格式生成figure
	
	替代plt.figure的函数，可以根据论文的固定格式生成figure
	
	Arguments:
		sizeType {[string]} -- 定义图的大小样式可用'normal','large','fullWidth'
		height {[double]} -- 定义图的高度
	"""
	fs = (3.5433071,height)
	if sizeType.lower() == 'normal':
		fs = (3.5433071,height)
	elif sizeType.lower() == 'large':
		fs = (5.511811,height)
	elif sizeType.lower() == 'fullWidth':
		fs = (7.480315,height)

	fig = plt.figure(figsize=fs)
	return fig

def getLineStyle(index):
	"""用于索引线形，索引号无限制
	用于索引线形，索引号无限制
	Arguments:
		index {[int]} -- 索引号
	"""
	index = (index) % len(LINE_STYLE_STR)
	return LINE_STYLE_STR[index]

def getLineMarker(index):
	"""用于索引标记，索引号无限制
	用于索引标记，索引号无限制
	Arguments:
		index {[int]} -- 索引号
	"""
	index = (index) % len(LINE_MARKER_STR)
	return LINE_MARKER_STR[index]

def showMarkerStyleFigure(isCreateFigure = True):
	"""显示marker样式
	显示marker样式
	"""
	fig = None
	if isCreateFigure:
		fig = paperFigure()
	for i in range(0,len(LINE_MARKER_STR)):
		x = range(1,10)
		y = np.ones(len(x))
		y = y * i
		plt.plot(x,y,marker=getLineMarker(i))
		plt.text(x[-1]+0.5,y[-1],LINE_MARKER_STR[i])
	return [fig]

def showLineStyleFigure(isCreateFigure = True):
	"""显示LineStyle样式
	显示LineStyle样式
	"""
	fig = None
	if isCreateFigure:
		fig = paperFigure()
	for i in range(0,len(LINE_STYLE_STR)):
		x = range(1,10)
		y = np.ones(len(x))
		y = y * i
		plt.plot(x,y,linestyle=getLineStyle(i))
		plt.text(x[-1],y[-1],LINE_STYLE_STR[i])

def showLineAndMarkStyle():
	"""显示LineStyle和marker样式
	
	此函数是showMarkerStyleFigure()和showLineStyleFigure()的结合
	"""
	fig = paperFigure(sizeType = "large")
	plt.subplot(121)
	showLineStyleFigure(isCreateFigure = False)
	plt.subplot(122)
	showMarkerStyleFigure(isCreateFigure = False)

if __name__ == "__main__":
	showLineAndMarkStyle()
	plt.show()