function paperPlot04StraightPipeSweepFrequency(isSavePlot)
	%ֱ��ɨƵ����
	sweepResult = loadExperimentPressureData(fullfile(dataPath,'ʵ��ԭʼ����\'));
    STFT.windowSectionPointNums = 512;
	STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
    STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
    Fs = 100;
    indexs = [1,13];
	
	
	%Ƶ��ͶӰ��ʱ��ͶӰ
    figure;
    paperFigureSet('full',6);
    subplot(1,2,1)
    [fh,X,Y,Z] = plotSweepFrequencyDistributionFre(sweepResult,Fs,'STFT',STFT...
        ,'charttype','contourf','LevelStep',100,'ShowText','off','TextStep',60,'LineStyle','-');
    title('(a)','FontSize',paperFontSize());
    set(gca,'color','none');
    gcaA = gca;
    %��ֵͶӰ
    subplot(1,2,2)
    plotSweepFrequencyDistributionAmp(sweepResult,Fs,'STFT',STFT...
        ,'charttype','contourf','LevelStep',80,'ShowText','off','TextStep',60,'LineStyle','-');
    title('(b)','FontSize',paperFontSize());
    set(gca,'color','none');
    h = colorbar('Position',...
    [0.919112096709723 0.147410714285715 0.031183034764756 0.771071428571429]);
    set(h,'Ticks',{});
    gcaB = gca;
	
	
	%ɨƵ
	titleLabel = {'a','b','c','d','e','f','g','h','i','j','k','l','m'};
    for i = 1:length(indexs)
        index = indexs(i);
        pressure = sweepResult(:,index);
        if 0
			figHandle = figure;
			paperFigureSet('normal',7);
            fh = plotSweepFrequency(pressure,Fs,'STFT',STFT);
            view(-45,48);
            xlabel('Ƶ��(Hz)','FontSize',paperFontSize());
            ylabel('ʱ��(s)','FontSize',paperFontSize());
            zlabel('��ֵ','FontSize',paperFontSize());
            title(labelText{i},'FontSize',paperFontSize());
            box on;
            if isSavePlot
				set(gca,'color','none');
                saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('ֱ��ɨƵ����-���%d',indexs(i)));
            end
        end
    end
end