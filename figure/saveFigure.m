function saveFigure(folderPath,figName)
%��ͼƬ����Ϊfig��png
    export_fig(fullfile(folderPath,sprintf('%s.fig',figName)));
    export_fig(fullfile(folderPath,sprintf('%s.png',figName)),'-r600','-transparent');
end

