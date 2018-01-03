function paperPlot04StraightPipePressureAndFrequency(dataCells,isSavePlot)
%绘制压力和频谱
	if nargin < 2
		isSavePlot = 0;
	end
	rang = 1:13;
	count = 1;
    Fs = 100;
	for i = rang
		fighandle = figure;
		paperFigureSet('full',6);
		fre = dataCells.Fre(:,i);
		mag = dataCells.Mag(:,i);
		fh{count} = plotOnePressureAndFrequency(dataCells.pressure(:,i),fre,mag,Fs,sprintf('测点%d',i));
		count = count + 1;
		if isSavePlot
			saveFigure(fullfile(getPlotOutputPath(),'ch04'),sprintf('直管波形频谱-测点%d',i));
			close(fighandle);
		end
	end
end

function h = plotOnePressureAndFrequency(pressure,fre,mag,Fs,label)
	ax1 = subplot(2,4,1);
	%绘制频率统计
	colorFill = [49,103,185]./255;
	[n,xout] = hist(pressure,50);
	h.barHadnle = barh(xout,n,'FaceColor',colorFill,'EdgeAlpha',0,'EdgeColor',colorFill);
	xlabel('频次','FontSize',paperFontSize());
	ylabel('压力(kPa)','FontSize',paperFontSize());
	set(gca,'color','none');
	box on;
	title(label,'FontSize',paperFontSize());
	axis tight;
    set(ax1,'Position',[0.107664233576642 0.626506024096384 0.166058394160584 0.291833962917022]);
	
	%波形
	ax2 = subplot(2,4,[2,4]);
	index = sigmaOutlierDetection(pressure,1.8);
	pressure(index) = [];
	x = 1:length(pressure);
    x = x.*(1/Fs);
	h.waveHadnle = plot(x,pressure,'-b');
	set(gca,'color','none');
	xlabel('时间(s)','FontSize',paperFontSize());
	ylabel('压力(kPa)','FontSize',paperFontSize());
	box on;
    axis tight;
    set(ax2,'Position',[0.377054597701149 0.626506024096384 0.577324964342646 0.298493975903614]);
	
	
    %频谱
	lineColor = [229,49,75]./255;
	ax3 = subplot(2,4,[5,8]);
	h.spectrumHadnle = plotSpectrum(fre,mag,'isMarkPeak',1,'color',lineColor...
        ,'markCount',3,'isMarkData',1,'markDataStyle','num');
	set(gca,'color','none');
	xlabel('频率(Hz)','FontSize',paperFontSize());
	ylabel('幅值(kPa)','FontSize',paperFontSize());
	box on;
    grid off;
    set(ax3,'Position',[0.102189781021898 0.172690763052209 0.848540145985401 0.278472027645466]);
end