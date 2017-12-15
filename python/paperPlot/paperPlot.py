import matplotlib.pyplot as plt

g_default_paper_font_dict = {
		'family': 'serif',
		'weight': 'normal',
		'size': 10,
		'color': 'black',
		}

def defaultPaperFigureFontDict():
    """默认字体字典
	
	默认字体字典
	
	Returns:
		[dict] -- 默认的字体字典
	"""
	return g_default_paper_font_dict

def paperFigure(sizeType='normal',height=4):
	"""替代plt.figure的函数，可以根据论文的固定格式生成figure
	
	替代plt.figure的函数，可以根据论文的固定格式生成figure
	
	Arguments:
		sizeType {[string]} -- 定义图的大小样式可用'normal','large','fullWidth'
		height {[double]} -- 定义图的高度
	"""
	figsize = 
	if sizeType.lower() is 'normal':
    	figsize=(3.5433071,height)
	else if sizeType.lower() is 'large':
    	figsize=(5.511811,height)
	else if sizeType.lower() is 'fullWidth':
    	figsize=(7.480315,height)

	fig = plt.figure(figsize=figsize)
	return fig