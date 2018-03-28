function paperPlotPulsatingSpectrumBar (isSaveFigure)
%���Ƹ���ǰ��ѹ������Ƶ��
%   
    dataPath = getDataPath();
%     mat = xlsread(fullfile(dataPath,'Ӧ���½�','������Ŀѹ������.xlsx'),1);
%     %���Ƹ���ǰ��ͼ
%     for i = 1:10
%         x = mat(1:7,(i-1)*2+2);
%         y = mat(1:7,(i-1)*2+1);
%         fh = figure;
%         paperFigureSet('small',5);
%         bar(x,y,'faceColor',getPlotColor(2));
%         xlim([2,18]);
%         ylim([0,30]);
%         xlabel('Ƶ��(Hz)','FontSize',paperFontSize());
%         ylabel('��ֵ(kPa)','FontSize',paperFontSize());
%         title(sprintf('�ڵ�%d',i));
%         if isSaveFigure
%             set(gca,'color','none');
%             saveFigure(fullfile(getPlotOutputPath(),'ch08'),sprintf('����ǰ-�ڵ�%dƵ��',i));
%             close(fh);
%         end
%     end
    
    mat = xlsread(fullfile(dataPath,'Ӧ���½�','������Ŀѹ������.xlsx'),2);
    %���Ƹ�����ͼ
    for i = 10
        x = mat(1:7,(i-1)*2+2);
        y = mat(1:7,(i-1)*2+1);
        fh = figure;
        paperFigureSet('small',5);
        bar(x,y,'faceColor',getPlotColor(1));
        xlim([2,18]);
        ylim([0,30]);
        xlabel('Ƶ��(Hz)','FontSize',paperFontSize());
        ylabel('��ֵ(kPa)','FontSize',paperFontSize());
        title(sprintf('�ڵ�%d',i));
        if isSaveFigure
            set(gca,'color','none');
            saveFigure(fullfile(getPlotOutputPath(),'ch08'),sprintf('�����-�ڵ�%dƵ��',i));
            close(fh);
        end
    end
end

