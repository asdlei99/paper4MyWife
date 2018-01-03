function paperPlot04StraightPipeSweepFrequency(sweepResult,isSavePlot)
	%直管扫频分析
    STFT.windowSectionPointNums = 512;
	STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
    STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
    Fs = 100;
    indexs = 10:13;
	
	
	%频率投影和时间投影
    figHandle = figure;
    paperFigureSet('full',6);
    subplot(1,2,1)
    plotSweepFrequencyDistributionFre(sweepResult,Fs,'STFT',STFT...
        ,'charttype','contourf');%,'LevelStep',100,'ShowText','off','TextStep',60,'LineStyle','-'
    title('(a)','FontSize',paperFontSize());
    set(gca,'color','none');
    
    %幅值投影
    subplot(1,2,2)
    plotSweepFrequencyDistributionAmp(sweepResult,Fs,'STFT',STFT...
        ,'charttype','contourf');%,'LevelStep',80,'ShowText','off','TextStep',60,'LineStyle','-'
    title('(b)','FontSize',paperFontSize());
    set(gca,'color','none');
    h = colorbar('Position',[0.919112096709723 0.147410714285715 0.031183034764756 0.771071428571429]);
    set(h,'YTick',[]);

	if isSavePlot
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'直管扫频分析-时间频率投影');
		close(figHandle);
	end
	
	%扫频
	titleLabel = {'a','b','c','d','e','f','g','h','i','j','k','l','m'};
    for index = indexs
        pressure = sweepResult(:,index);

		figHandle = figure;
		paperFigureSet('normal',7);
		plotSweepFrequency(pressure,Fs,'STFT',STFT);
		view(-45,48);
		xlabel('频率(Hz)','FontSize',paperFontSize());
		ylabel('时间(s)','FontSize',paperFontSize());
		zlabel('幅值','FontSize',paperFontSize());
		title(titleLabel{index},'FontSize',paperFontSize());
		box on;
		if isSavePlot
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch04'),sprintf('直管扫频stft分析-测点%d',index));
			close(figHandle);
		end

    end
end