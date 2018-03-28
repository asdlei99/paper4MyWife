function paperPlotPulsatingSpectrumBar (isSaveFigure)
%绘制改造前后压力脉动频谱
%   
    dataPath = getDataPath();
%     mat = xlsread(fullfile(dataPath,'应用章节','兰州项目压力数据.xlsx'),1);
%     %绘制改造前棒图
%     for i = 1:10
%         x = mat(1:7,(i-1)*2+2);
%         y = mat(1:7,(i-1)*2+1);
%         fh = figure;
%         paperFigureSet('small',5);
%         bar(x,y,'faceColor',getPlotColor(2));
%         xlim([2,18]);
%         ylim([0,30]);
%         xlabel('频率(Hz)','FontSize',paperFontSize());
%         ylabel('幅值(kPa)','FontSize',paperFontSize());
%         title(sprintf('节点%d',i));
%         if isSaveFigure
%             set(gca,'color','none');
%             saveFigure(fullfile(getPlotOutputPath(),'ch08'),sprintf('改造前-节点%d频谱',i));
%             close(fh);
%         end
%     end
    
    mat = xlsread(fullfile(dataPath,'应用章节','兰州项目压力数据.xlsx'),2);
    %绘制改造后棒图
    for i = 10
        x = mat(1:7,(i-1)*2+2);
        y = mat(1:7,(i-1)*2+1);
        fh = figure;
        paperFigureSet('small',5);
        bar(x,y,'faceColor',getPlotColor(1));
        xlim([2,18]);
        ylim([0,30]);
        xlabel('频率(Hz)','FontSize',paperFontSize());
        ylabel('幅值(kPa)','FontSize',paperFontSize());
        title(sprintf('节点%d',i));
        if isSaveFigure
            set(gca,'color','none');
            saveFigure(fullfile(getPlotOutputPath(),'ch08'),sprintf('改造后-节点%d频谱',i));
            close(fh);
        end
    end
end

