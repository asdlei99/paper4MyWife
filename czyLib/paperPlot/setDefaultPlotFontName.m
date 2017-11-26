function setDefaultPlotFontName(fontName)
%绘图相关的默认设置
    set(groot,'defaultAxesFontName',fontName);
    set(groot,'defaultTextFontName',fontName);
    set(groot,'defaultLegendFontName',fontName);
    set(groot,'defaultColorbarFontName',fontName);
end

