#-*-coding:UTF-8-*-
import numpy as np
import struct as st
import array
import os
import matplotlib.pyplot as plt
import paperDataLoad.loadDsfData as dsf
import czy.dataPlot as dp

def plotDsfData(filePath,type='f'):
	"""绘制dsf文件
	type = 'f' 只有频谱 'fp' 频谱和相位
	"""
	headerDict,wave = dsf.loadDsfData(filePath)
	fs = headerDict['SampleFre']
	row = 2
	if len(type) > 1:
		row = 3
	fig,axs = plt.subplots(row,1,figsize=(7, 7))
	
	waveHandle = dp.plotWave(wave,fs,ax=axs[0],linewidth=0.5)
	waveHandle = waveHandle[0][0]
	axs[0].set_xlabel('time(s)')
	axs[0].set_ylabel('amplute(m/s)')
	phaseHandle = None
	spectrumHandle = None
	row = 1;
	if -1 != type.find('f'):
		spectrumHandle = dp.plotFrequencySpectrum(wave,fs,ax=axs[row],fftN=-1,scale='amp',linewidth=0.5)
		spectrumHandle = spectrumHandle[0][0]
		axs[row].set_xlabel('frequency(Hz)')
		axs[row].set_ylabel('amplute')
		++row;
	
	if -1 != type.find('p'):
		phaseHandle = axs[row].phase_spectrum(wave, Fs=fs)
		axs[row].set_xlabel('frequency(Hz)')
		axs[row].set_ylabel('amplute')
		++row;

	return waveHandle,spectrumHandle,phaseHandle

if __name__ == '__main__':
	plotDsfData('/mnt/hgfs/VMShare/振动数据/H1.dsf',type='fp')
	plt.show()