function paperPlot04StraightPipeSweepFrequency(sweepResult,isSavePlot)
	type = 'small';
	STFT.windowSectionPointNums = 512;
	STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
    STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
    Fs = 100;
    indexs = 1:13;
	if strcmpi(type,'large')
		plotLargePlot(sweepResult,isSavePlot,STFT,Fs,indexs);
	else
		plotSmallPlot(sweepResult,isSavePlot,STFT,Fs,indexs);
	end
	plotShadow(sweepResult,isSavePlot,STFT,Fs);
end

function plotShadow(sweepResult,isSavePlot,STFT,Fs)
	%Ƶ��ͶӰ��ʱ��ͶӰ
    figHandle = figure;
    paperFigureSet('full',6);
    subplot(1,2,1)
    plotSweepFrequencyDistributionFre(sweepResult,Fs,'STFT',STFT...
        ,'charttype','contourf');%,'charttype','contourf'plot3
    title('(a)','FontSize',paperFontSize());
    set(gca,'color','none');
    
    %��ֵͶӰ
    subplot(1,2,2)
    plotSweepFrequencyDistributionAmp(sweepResult,Fs,'STFT',STFT...
        ,'charttype','contourf');%,'LevelStep',80,'ShowText','off','TextStep',60,'LineStyle','-'
    title('(b)','FontSize',paperFontSize());
    set(gca,'color','none');
    h = colorbar('Position',[0.919112096709723 0.147410714285715 0.031183034764756 0.771071428571429]);
    set(h,'YTick',[]);

	if isSavePlot
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'ֱ��ɨƵ����-ʱ��Ƶ��ͶӰ');
		close(figHandle);
	end
end

function plotLargePlot(sweepResult,isSavePlot,STFT,Fs,indexs)
	%ɨƵ
    for index = indexs
        pressure = sweepResult(:,index);

		figHandle = figure;
		paperFigureSet('normal',7);
		plotSweepFrequency(pressure,Fs,'STFT',STFT);
		view(-45,48);
		xlabel('Ƶ��(Hz)','FontSize',paperFontSize());
		ylabel('ʱ��(s)','FontSize',paperFontSize());
		zlabel('��ֵ','FontSize',paperFontSize());
		title(sprintf{'���%d',index},'FontSize',paperFontSize());
		box on;
		if isSavePlot
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch04'),sprintf('ֱ��ɨƵstft����-���%d',index));
			close(figHandle);
		end
    end
end

function plotSmallPlot(sweepResult,isSavePlot,STFT,Fs,indexs)
%ɨƵ
    for index = indexs
        pressure = sweepResult(:,index);

		figHandle = figure;
		paperFigureSet('small',6);
		fh = plotSweepFrequency(pressure,Fs,'STFT',STFT);
        set(gca,'XTick',0:10:50);
		view(-35,36);
		xlabel('Ƶ��(Hz)','FontSize',paperFontSize());
		ylabel('ʱ��(s)','FontSize',paperFontSize());
		zlabel('��ֵ','FontSize',paperFontSize());
		title(sprintf('���%d',index),'FontSize',paperFontSize());
		box on;
		if isSavePlot
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch04'),sprintf('ֱ��ɨƵstft����-���%d',index));
			close(figHandle);
		end
    end
end