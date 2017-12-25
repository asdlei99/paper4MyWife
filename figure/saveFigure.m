function saveFigure(folderPath,figName)
%把图片保存为fig和png
    export_fig(fullfile(folderPath,sprintf('%s.fig',figName)));
    export_fig(fullfile(folderPath,sprintf('%s.png',figName)),'-r600','-transparent');
end

