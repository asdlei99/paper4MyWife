import matplotlib.pyplot as plt

def defaultPaperFigureFontDict():
	font = {'family':'serif'
	,'weight':'normal'
	,'size':10
	,'color':'black'}
	return font

def paperFigure(figsize=(8,6)):
	"""
	"""
	fig = plt.figure(figsize=figsize)
	return fig