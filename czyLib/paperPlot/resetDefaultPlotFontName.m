function resetDefaultPlotFontName()
%��ͼ��ص�Ĭ������
    set(groot,'defaultAxesFontName',paperFontName());
    set(groot,'defaultTextFontName',paperFontName());
    set(groot,'defaultLegendFontName',paperFontName());
    set(groot,'defaultColorbarFontName',paperFontName());
end

