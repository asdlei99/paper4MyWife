﻿import os.path
from itertools import cycle
#----
import matplotlib.pyplot as plt  
from matplotlib.widgets import Cursor
from matplotlib import colors
from matplotlib import lines
from matplotlib import mlab
from matplotlib.lines import Line2D
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.collections import PolyCollection
from matplotlib.colors import colorConverter
#----
import numpy as np
#----
from czy import signal as czySignal
from czy import detectPeaks as dp


LINE_STYLES = lines.lineStyles.keys()
LineCycler = cycle(LINE_STYLES)

LINE_MARKERS = []
for m in Line2D.markers:
    try:
        if m != ' ' and len(m)==1:
            LINE_MARKERS.append(m)
    except TypeError:
        pass
LineMarksCycler = cycle(LINE_MARKERS)

LINE_COLORS = ['b','g','r','c','m','k','y']
LineColorCycler = cycle(LINE_COLORS)


def plotWave(wave,fs,ax=None,color='r',**kwargs):
    '''绘制一个压力图形
    Args:
        wave:numpy.array 波形
        fs:int 采样率
        ax:matplotlib.ax 绘图坐标系
        color:str or rgb 绘图颜色
        **kwargs:matplotlib.axes.plot的**kwargs参数
    Returns:
        [x,[fig,ax]]:list
            x值，[fig,ax]
    '''
    x = czySignal.getXByFs(len(wave),fs)
    fig=None
    if ax is None:
        fig,ax = plt.subplots(1, 1, figsize=(8, 4))
    lineHandle = ax.plot(x,wave,color,**kwargs)
    ax.set_xlim([x[0],x[-1]])
    if not fig is None:
        fig.set_facecolor('w')
    return lineHandle,x,[fig,ax]



def plotFrequencySpectrum(wave,fs,ax=None,fftN = -1,isShowPeaks = True,markPeaksNum = 5,scale = 'amp',**otherSet):
    '''绘制频谱图
    Args:
        wave:numpy.array 
            波形
        fs:int 
            采样率
        ax:matplotlib object
            绘图用坐标轴
        fftN:int 
            fft的数量，-1为自动寻找下个2基，0为当前长度，其他为自定义
        isShowPeaks:bool
            是否捕获峰值
        scale:string
            幅值处理方式：amp幅值Amplitude,ampDB为幅值加上分贝,mag为幅度谱，只是对fft结果取模
        peaksMarkStyle:string
            标记极值点的样式，默认为'or'
    Returns:
        [[fre,mag,ppd],[fig,ax]]:list
            [[频率，幅值，峰值索引],[fig,ax]]
    '''

    ppd = None
    fig = None
    peaksMarkStyle = 'or'
    if 'peaksMarkStyle' in otherSet:
        markStyle = otherSet['peaksMarkStyle']
    fre,mag = czySignal.spectrum(wave,fs,fftSize=fftN,scale=scale)
    if ax is None:
        fig,ax = plt.subplots(1, 1, figsize=(8, 4))
        fig.set_facecolor('w')
    lineHandle = ax.plot(fre,mag,**otherSet)
    ax.set_xlim([fre[0],fre[-1]])
    if isShowPeaks:
        if ppd is None:
            ppd = detectPeaks(mag,markPeaksNum)
            #ppd = dp.detectPeaks(mag,sorting = True,edge='falling')
            #ppdShow = ppd[0:markPeaksNum if len(ppd)>markPeaksNum else len(ppd)]
        ppLineHandle = ax.plot(fre[ppd],mag[ppd],peaksMarkStyle)
    return lineHandle,[fre,mag,ppd],[fig,ax],ppLineHandle

def plotSpectrum(x,ax = None,fig = None, NFFT=None, Fs=None, Fc=None, detrend=None,plotType = None
                 , window=None, noverlap=None, cmap=None, xextent=None
                 , pad_to=None, sides=None, scale_by_freq=None, mode=None, scale=None, vmin=None, vmax=None, **kwargs):
    """
    进行短时傅里叶变换
    和plt.specgram一样但可以进行标准幅值计算amplitude，此时mode为amplitude，其他参数与plt.specgram一致
    type:string
        绘图样式，None为谱图，'3d'为三维线图-waterfall
    spectrum: 2-D array
        columns are the periodograms of successive segments
    freqs: 1-D array
        The frequencies corresponding to the rows in spectrum
    t: 1-D array
        The times corresponding to midpoints of segments (i.e the columns in spectrum).
    """
    im = None
    if fig is None:
        fig = plt.figure()
        fig.set_facecolor('w')
    
    if Fc is None:
        Fc = 0

    if mode == 'complex':
        raise ValueError('Cannot plot a complex specgram')

    if scale is None or scale == 'default':
        if mode in ['angle', 'phase']:
            scale = 'linear'
        else:
            scale = 'dB'
    elif mode in ['angle', 'phase'] and scale == 'dB':
        raise ValueError('Cannot use dB scale with angle or phase mode')

    #edgecolors = None
    #facecolors = None
    #edgeAlpha = 0.9
    #faceAlpha = 0.2
    sameColor = None
    ##防止传入污染的dict
    #if 'edgecolors' in kwargs:
    #    edgecolors = kwargs.pop('edgecolors')
    #if 'facecolors' in kwargs:
    #    facecolors = kwargs.pop('facecolors')
    #if 'edgeAlpha' in kwargs:
    #    edgeAlpha = kwargs.pop('edgeAlpha')
    #if 'faceAlpha' in kwargs:
    #    faceAlpha = kwargs.pop('faceAlpha')
    if 'sameColor' in kwargs:
        sameColor = kwargs.pop('sameColor')

    is2Amp = False
    if mode.lower() == 'amplitude':
        mode = 'magnitude'
        is2Amp = True
    spec, freqs, t = mlab.specgram(x=x, NFFT=NFFT, Fs=Fs,
                                    detrend=detrend, window=window,
                                    noverlap=noverlap, pad_to=pad_to,
                                    sides=sides,
                                    scale_by_freq=scale_by_freq,
                                    mode=mode)
    Z = spec
    if is2Amp:
        Z[0] = spec[0]/NFFT
        Z[1:-1] = spec[1:-1]*(2.0/NFFT)
        Z[-1] = spec[-1]/NFFT
    if scale == 'linear':
        Z = spec
    elif scale == 'dB':
        if mode is None or mode == 'default' or mode == 'psd':
            Z = 10. * np.log10(spec)
        else:
            Z = 20. * np.log10(spec)
    else:
        raise ValueError('Unknown scale %s', scale)
    freqs += Fc
    if plotType == '3d':
        if ax is None:
            ax = fig.gca(projection='3d')
        x = []
        for index in range(0,len(t)):
            x.append(freqs)
        Z = np.transpose(Z)
        _plotWaterFall(x,Z,orders = t,ax=ax,fig=fig,color=sameColor
,**kwargs)
    else:
        if ax is None:
            ax = fig.gca()
        Z = np.flipud(Z)
        if xextent is None:
            xextent = 0, np.amax(t)
        xmin, xmax = xextent
        extent = xmin, xmax, freqs[0], freqs[-1]
        im = ax.imshow(Z, cmap, extent=extent, vmin=vmin, vmax=vmax,
                            **kwargs)
        if im is not None:
            plt.colorbar(im,ax = ax)


    #im = None
    #if ax is None:
    #    fig,ax = plt.subplots(1, 1, figsize=(8, 4))
    #    fig.set_facecolor('w')
    #if mode.lower() == 'amplitude':
    #    spectrum,freqs,t = mlab.specgram(x,NFFT=NFFT,Fs=Fs,detrend=detrend,window=window,noverlap=noverlap
    #                        ,pad_to=pad_to,sides=sides,scale_by_freq=scale_by_freq,mode='magnitude')
    #    spectrum[0] = spectrum[0]/NFFT
    #    spectrum[1:-1] = spectrum[1:-1]*(2.0/NFFT)
    #    spectrum[-1] = spectrum[-1]/NFFT
    #    if scale == 'dB':
    #        spectrum = 20. * np.log10(spectrum)
    #    spectrum = np.flipud(spectrum)#用imshow函数需要对数据进行上下翻转
    #    if xextent is None:
    #        xextent = 0, np.amax(t)
    #    xmin, xmax = xextent
    #    if Fc is not None:
    #        freqs += Fc
    #    extent = xmin, xmax, freqs[0], freqs[-1]
    #    im = ax.imshow(spectrum, cmap, extent=extent, vmin=vmin, vmax=vmax,**kwargs)
    #    #im = ax.contourf(t,freqs,spectrum)
    #else:
    #    spectrum, freqs, t, im = ax.specgram(x,NFFT=NFFT,Fs=Fs,Fc=Fc,detrend=detrend,window=window,noverlap=noverlap,cmap=cmap,xextent=xextent
    #                        ,pad_to=pad_to,sides=sides,scale_by_freq=scale_by_freq,mode=mode,scale=scale,vmin=vmin,vmax=vmax,**kwargs)
    
    
    return (Z, freqs, t, im),(fig,ax)



def isDigit(s):
    try:
        int(s)
    except ValueError:
        return False
    return True

def makeSubPlot(row,colum,datas,x=None,xs = None,titles = None,figsize=(8, 4),colors = None,isSameColor = False):
    """绘制多个子图
    Args:
    row: int
        绘制子图的分割行数
    column: int
        绘制子图分割的列数
    x: array_like
        x轴的值 所有子图公用一个x轴值,如果x是不同值，可以设置xs
    xs: list
        每个subplot的x值，如果公用一个x轴值,可以设置x，若都不设置，自动从1递增
    datas: list
        y轴的值，datas的长度不超过row*column
    titles: list
        给每个图添加的标题


    """
    fig,axs = plt.subplots(row,colum,figsize=figsize)
    if isSameColor:
        sameclr = next(LineColorCycler)
    index = 0
    for r in range(0,row):
        for c in range(0,colum):
            print(next(LineColorCycler))
            if index < len(datas):
                xData = list(range(1,len(datas[index])+1))
                if not x is None:
                    xData = x
                elif not xs is None:
                    xData = xs[index]
                axs[r][c].plot(xData,datas[index]
                        ,color = sameclr if isSameColor else next(LineColorCycler))
                if not titles is None:
                    axs[r][c].set_title(titles[index])
            else:
                break
            index+=1
    fig.set_facecolor('w')
    

def plot3(x,y,z,ax=None,fig=None,**otherSet):
    if fig is None:
        fig = plt.figure()
        fig.set_facecolor('w')
    if ax is None:      
        ax = fig.gca(projection='3d')
    ax.plot(x,y,z,**otherSet)
    return [fig,ax]

def plotWaterFall(xs,ys,orders=None,ax=None,fig=None
                    ,type = 'line',**otherSet):
    '''绘制瀑布图
    Args:
        xs: list
            x轴数据list,，每个元素是需要绘制的x轴数据
        ys: list
            y轴数据list,，每个元素是需要绘制的y轴数据,
            ！！注意：这里的y，会以z轴绘制
        type:string
            type = 'line'以曲线形式绘制waterfall，type='poly'或者非line，以填充形状形式绘制
        fig: matplotLib.figure
            绘图容器，若传入，而没有ax，会以它生成ax
        ax:
            坐标系，默认为None,会自动生成
        order: list
            每个x,y对应的序号,如果设置，从1开始自增到len(x)
        edgecolors:
            边界线颜色
            (0,0,0,0):int,int,int,int:R,G,B,A
        facecolors:
            填充颜色
            (0,0,0,0):int,int,int,int:R,G,B,A
        edgeAlpha:int
            边界线的透明度，默认0.9
        faceAlpha:int
            填充色的透明度，默认0.2
        sameColor:
            设置在type='line'时，颜色一致
            (0,0,0,0):int,int,int,int:R,G,B,A
    Return:
        [fig,ax] : list
            返回fig和ax，若指定，返回原样，若没指定将生成新的
    '''
    if fig is None:
        fig = plt.figure()
        fig.set_facecolor('w')
    if ax is None:
        ax = fig.gca(projection='3d')
    if orders is None:
        orders = range(1,min([len(xs),len(ys)])+1)
    edgecolors = None
    facecolors = None
    edgeAlpha = 0.9
    faceAlpha = 0.2
    sameColor = None
    #防止传入污染的dict
    if 'edgecolors' in otherSet:
        edgecolors = otherSet.pop('edgecolors')
    if 'facecolors' in otherSet:
        facecolors = otherSet.pop('facecolors')
    if 'edgeAlpha' in otherSet:
        edgeAlpha = otherSet.pop('edgeAlpha')
    if 'faceAlpha' in otherSet:
        faceAlpha = otherSet.pop('faceAlpha')
    if 'sameColor' in otherSet:
        sameColor = otherSet.pop('sameColor')
    if type == 'line':          
        for index,z in enumerate(ys):
            x = xs[index]
            y = np.ones(len(z))*orders[index]
            if sameColor is None:
                _plot3(x,y,z,ax = ax,fig = fig,**otherSet)
            else:
                _plot3(x,y,z,ax = ax,fig = fig,color=sameColor,**otherSet)

    #序号,如果不指定，那么就是以1：N
    else:

        verts = []
    
        for i,z in enumerate(orders):
            verts.append(list(zip(xs[i], ys[i])))

        if facecolors is None:
            facecolors = []
            for z in orders:
                facecolors.append(colorConverter.to_rgba('r',alpha=faceAlpha))#默认为红色
        if edgecolors is None:
            edgecolors = []
            for z in orders:
                edgecolors.append(colorConverter.to_rgba('r',alpha=edgeAlpha))
        #生成轮廓
        poly = PolyCollection(verts,edgecolors=edgecolors, facecolors=facecolors)
        #poly.set_alpha(0.95)

        minxs = np.min(list(map(np.min,xs)))
        maxxs = np.max(list(map(np.max,xs)))
        minys = np.min(list(map(np.min,ys)))
        maxys = np.max(list(map(np.max,ys)))
        ax.add_collection3d(poly, zs=orders, zdir='y')
        ax.set_xlim3d(minxs,maxxs)
        ax.set_ylim3d(np.min(orders),np.max(orders))
        ax.set_zlim3d(minys,maxys)       
    return [fig,ax]


def plotTrend(xdatas,ydatas,names,ax = None,isShow = False):
    '''绘制趋势图
        趋势图是指数据量不大，用于显示趋势的图形
    Args:
        datas:list
            数据，多个列表则绘制多个对比图
        names:list/str
            每个图形对应的名字
        ax:matplotlib.ax
        isShow:bool
            是否显示图形
    Returns
    '''
    if ax is None:
        fig,ax = plt.subplots(1, 1, figsize=(8, 4))
    for i,y in enumerate(ydatas):
        ax.plot(xdatas[i],y,color=next(LineColorCycler),)
    fig.set_facecolor('w')
    if isShow:
        plt.show()

def markPoints(ax,xs,ys,text=None,autoType='y'):
    '''
    标记数据在图表上
    Args
        ax:matplotlib->axes
            坐标系
        xs:list
            要标记数据的x值
        ys:list
            要标记数据的y值
        text:list
            要标记数据的内容，如果没有，则标记数据的x,y或者x，或者y，具体由autoType控制
        autoType:string
            自动标记的类型，如果为y，表示标记y值，x表示标记x值，xy表示标记x，y值        
    '''
    for (x,y) in zip(xs,ys):
        if autoType == 'y':
            label = '%g'%(y)
        elif autoType == 'x':
            label = '%g'%(x)
        else:
            label = '%g,%g'%(x,y)
        ax.annotate(label,xy=(x,y),xycoords='data'
            ,xytext=(-20, 20), textcoords='offset points'
            ,arrowprops=dict(arrowstyle="->"))
    
def detectPeaks(data,peakNums = 10,mpd = 1,sorting = True,edge = 'rising'):
    '''
    获取峰值，默认降序，投一个为最大的峰值索引
    Args:
        data:
            数据
        peakNums:int
            要获取的峰值数量，default:10
        mpd:int
            positive integer, optional (default = 1)
            detect peaks that are at least separated by minimum peak distance (in
            number of data).
        sorting:bool
            是否排序，默认为True
        edge:string
            排序方式，默认为falling，可以为{None, 'rising', 'falling', 'both'}, 
            for a flat peak, keep only the rising edge ('rising'), only the
            falling edge ('falling'), both edges ('both'), or don't detect a
            flat peak (None).

    '''
    ppd = dp.detectPeaks(data,mpd = mpd,sorting = sorting,edge=edge)
    return ppd[0:peakNums if len(ppd)>peakNums else len(ppd)]
