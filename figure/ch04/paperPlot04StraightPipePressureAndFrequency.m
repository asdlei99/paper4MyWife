function paperPlot04StraightPipePressureAndFrequency(dataCells,isSavePlot)
%绘制压力和频谱
	if nargin < 2
		isSavePlot = 0;
	end
	rang = 1:13;
	count = 1;
	for i = rang
		figure
		paperFigureSet('full',6);
		fre = dataCells.Fre(:,i);
		mag = dataCells.Mag(:,i);
		fh{count} = plotOnePressureAndFrequency(dataCells.pressure(:,i),fre,mag,sprintf('测点%d',i));
		if isSavePlot
			saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('直管波形频谱-测点%d',i));
		end
		count = count + 1;
	end
end

function h = plotOnePressureAndFrequency(pressure,fre,mag,label)
	subplot(1,5,1)
	%绘制频率统计
	colorFill = [49,103,185]./255;
	[n,xout] = hist(pressure);
	h.barHadnle = barh(xout,n,'color',colorFill);
	xlabel('频次');
	ylabel('压力(kPa)');
	set(gca,'color','none');
	box on;
	title(label,'FontSize',paperFontSize());
	axis tight;
	
	%波形
	subplot(1,5,[2,3])
	index = sigmaOutlierDetection(pressure,1.8);
	pressure(index) = [];
	x = 1:length(pressure);
    x = x.*(1/fs);
	h.waveHadnle = plot(x,pressure,'-b');
	set(gca,'color','none');
	xlabel('时间(s)');
	ylabel('压力(kPa)');
	box on;
	
	%频谱
	lineColor = [229,49,75]./255;
	subplot(1,5,[4,5])
	h.spectrumHadnle = plotSpectrum(fre,mag,'isMarkPeak',1,'lineColor',lineColor);
	set(gca,'color','none');
	xlabel('频率(Hz)');
	ylabel('幅值(kPa)');
	box on;
end