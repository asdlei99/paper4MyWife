#-*-coding:UTF-8-*-
import paperDataLoad.loadMatData as paperLoad
import numpy as np
import paperPlot.paperPlot as paperPlt
import paperDataLoad.loadDsfData as dsf
import matplotlib.pyplot as plt
import czy.dataPlot as dp

[header,wave] = dsf.loadDsfData("e:/netdisk/shareCloud/【大论文】/[04]数据/振动数据/北区科技园数据整理1-7测点/8.29/1空罐/300r 0.1Mpa/H1.dsf")
fig,axs = plt.subplots(2,1,figsize=paperPlt.figureSize('normal',3))
fs = header['SampleFre']

lineHandle = dp.plotWave(wave,fs,ax=axs[0])
print(lineHandle)
lineHandle = lineHandle[0][0]
lineHandle.set_linewidth(0.5)
axs[0].set_xlabel('time(s)')
axs[0].set_ylabel('amplute(m/s)')

lineHandle = dp.plotFrequencySpectrum(wave,fs,ax=axs[1],fftN=8192)
lineHandle = lineHandle[0][0]
lineHandle.set_linewidth(0.5)
axs[1].set_xlabel('time(s)')
axs[1].set_ylabel('frequency(Hz)')
plt.show()