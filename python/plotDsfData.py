#-*-coding:UTF-8-*-
import numpy as np
import struct as st
import array
import os
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import paperDataLoad.loadDsfData as dsf
import czy.dataPlot as dp
import czy.signal as czyS


def plotDsfData(filePath,type='f',isshowvalue=False):
    """绘制dsf文件
    type = 'f' 频谱 'p' 相位 'd'功率谱 
    """
    

    fileName = os.path.basename(filePath)
    headerDict,wave = dsf.loadDsfData(filePath)
    fs = headerDict['SampleFre']
    row = len(type)+1
    fig,axs = plt.subplots(row,1,figsize=(5, 5))
    
    waveSize = len(wave)
    nFFT = czyS.nextpow2(waveSize)
    waveHandle = dp.plotWave(wave,fs,ax=axs[0],linewidth=0.5)
    waveHandle = waveHandle[0][0]
    axs[0].set_xlabel('time(s)')
    axs[0].set_ylabel('amplute(m/s)')
    phaseHandle = None
    spectrumHandle = None
    row = 1;

    fre = None
    mag = None
    if -1 != type.find('f'):
        res = dp.plotFrequencySpectrum(wave,fs,ax=axs[row],fftN=nFFT,scale='amp',linewidth=0.5)
        spectrumHandle = res[0][0]
        print(res)
        res = res[1]
        fre = res[0]
        mag = res[1]
        ppValueIndex = res[2]
        fre = fre[ppValueIndex]
        mag = mag[ppValueIndex]
        axs[row].set_xlabel('frequency(Hz)')
        axs[row].set_ylabel('amplute')
        row+=1;
    
    if -1 != type.find('p'):
        phaseHandle = axs[row].phase_spectrum(wave, Fs=fs)
        axs[row].set_xlabel('frequency(Hz)')
        axs[row].set_ylabel('amplute')
        row+=1;

    if -1 != type.find('d'):
        phaseHandle = axs[row].psd(wave,nFFT,fs,linewidth=0.5,detrend=mlab.detrend_mean)
        axs[row].set_xlabel('frequency(Hz)')
        axs[row].set_ylabel('PSD')
        row+=1;
    if isshowvalue:
        plt.subplots_adjust(hspace=0.77,right=0.7)
        plt.figtext(0.75,0.95,'name:%s' % fileName)
        if fre is not None:
            for i,f in enumerate(fre):
                plt.figtext(0.75,0.9-i*0.05,'%d.fre:%g' % (i+1,f))
    else:
        plt.subplots_adjust(hspace=0.77)
        plt.figtext(0.45,0.95,'name:%s' % fileName)
    
    return waveHandle,spectrumHandle,phaseHandle

if __name__ == '__main__':
    plotDsfData('e:\\netdisk\\shareCloud\\【大论文】\\[04]数据\\振动数据\\北区科技园数据整理1-7测点\\9.10\\6直进侧出（出口离入口近）\\420r 0.05Mpa\\V13.dsf'
    ,type='fd',isshowvalue=True)
    plt.show()