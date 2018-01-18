function paperPlot04StraightPipePressureAndFrequency(dataCells,isSavePlot)
%绘制压力和频谱
	if nargin < 2
		isSavePlot = 0;
    end
    type = 'two';
	rang = 1:13;
	count = 1;
    Fs = 100;
    if strcmpi(type,'two')
        for i = 1:2:length(rang)
            index1 = rang(i);
            if i+1 <= length(rang)
                index2 = rang(i+1);
            else
                index2 = nan;
            end
            label = {};
            fighandle = figure;
            paperFigureSet('full',7);
            fre1 = dataCells.Fre(:,index1);
            mag1 = dataCells.Mag(:,index1);
            pressure1= dataCells.pressure(:,index1);
            label{1} = sprintf('测点%d',index1);
            if isnan(index2)
                fre2 = [];
                mag2 = [];
                pressure2 = [];
            else
                fre2 = dataCells.Fre(:,index2);
                mag2 = dataCells.Mag(:,index2);
                pressure2= dataCells.pressure(:,index2);
                label{2} = sprintf('测点%d',index2);
            end
            plotTwoPressureAndFrequency(pressure1,pressure2,fre1,mag1,fre2,mag2,Fs,label);
            if isSavePlot
                if isnan(index2)
                    saveFigure(fullfile(getPlotOutputPath(),'ch04'),sprintf('直管波形频谱-测点%d',index1));
                else
                    saveFigure(fullfile(getPlotOutputPath(),'ch04'),sprintf('直管波形频谱-测点%d-%d',index1,index2));
                end
                close(fighandle);
            end
        end
    else
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

function h = plotTwoPressureAndFrequency(pressure1,pressure2,fre1,mag1,fre2,mag2,Fs,label)
    %波形1
	ax1 = subplot(2,8,[1,3]);
    index = sigmaOutlierDetection(pressure1,1.8);
	pressure1(index) = [];
	x = 1:length(pressure1);
    x = x.*(1/Fs);
	h.waveHadnle = plot(x,pressure1,'-b');
	set(ax1,'color','none');
	xlabel('时间(s)','FontSize',paperFontSize());
	ylabel('压力(kPa)','FontSize',paperFontSize());
    title(label{1},'FontSize',paperFontSize());
    box on;
    axis tight;
    

	%绘制频率统计1
    ax2 = subplot(2,8,4);
	colorFill = [49,103,185]./255;
	[n,xout] = hist(pressure1,50);
	h.barHadnle = barh(xout,n,'FaceColor',colorFill,'EdgeAlpha',0,'EdgeColor',colorFill);
	xlabel('频次','FontSize',paperFontSize());
    set(ax2,'YTickLabel',{});
	set(ax2,'color','none');
	box on;
	axis tight;
    
	
	
    %频谱1
	lineColor = [229,49,75]./255;
	ax3 = subplot(2,8,[9,12]);
    peaks = [];
	[h.spectrumHadnle,tmp,tmp,tmp,peaks] = plotSpectrum(fre1,mag1,'isMarkPeak',1,'color',lineColor...
        ,'markCount',3,'isMarkData',1,'markDataStyle','num');
    clear tmp;
    fprintf('%g,%g,%g\n',peaks(1),peaks(2),peaks(3));
	set(ax3,'color','none');
	xlabel('频率(Hz)','FontSize',paperFontSize());
	ylabel('幅值(kPa)','FontSize',paperFontSize());
	box on;
    grid off;
    
    
    set(ax1,'Position',[0.0935 0.584 0.265 0.34]);
    set(ax2,'Position',[0.361552028218695 0.584 0.136 0.34]);
    set(ax3,'Position',[0.0935 0.162 0.403880070546737 0.256603773584906]);
    %波形2
    if isempty(pressure2)
        return;
    end
	ax4 = subplot(2,8,[5,7]);
    index = sigmaOutlierDetection(pressure2,1.8);
	pressure2(index) = [];
	x = 1:length(pressure2);
    x = x.*(1/Fs);
	h.waveHadnle = plot(x,pressure2,'-b');
	set(ax4,'color','none');
	xlabel('时间(s)','FontSize',paperFontSize());
	ylabel('压力(kPa)','FontSize',paperFontSize());
    title(label{2},'FontSize',paperFontSize());
    box on;
    axis tight;
    
    %绘制频率统计2
    ax5 = subplot(2,8,8);
	colorFill = [49,103,185]./255;
	[n,xout] = hist(pressure2,50);
	h.barHadnle = barh(xout,n,'FaceColor',colorFill,'EdgeAlpha',0,'EdgeColor',colorFill);
	xlabel('频次','FontSize',paperFontSize());
	set(ax5,'color','none');
    set(ax5,'YTickLabel',{});
	box on;
	axis tight;
    
    %频谱2
	lineColor = [229,49,75]./255;
	ax6 = subplot(2,8,[13,16]);
	[h.spectrumHadnle,tmp,tmp,tmp,peaks] = plotSpectrum(fre2,mag2,'isMarkPeak',1,'color',lineColor...
        ,'markCount',3,'isMarkData',1,'markDataStyle','num');
    clear tmp;
    fprintf('%g,%g,%g\n',peaks(1),peaks(2),peaks(3));
	set(ax6,'color','none');
	xlabel('频率(Hz)','FontSize',paperFontSize());
	ylabel('幅值(kPa)','FontSize',paperFontSize());
    grid off;
    box on;
    set(ax4,'Position',[0.586 0.584 0.265 0.34]);
    set(ax5,'Position',[0.855 0.584 0.136 0.34]);
    set(ax6,'Position',[0.586 0.162 0.403880070546737 0.256603773584906]);
   
	
end