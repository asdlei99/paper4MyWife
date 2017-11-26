function resetDefaultPlotFontName()
%绘图相关的默认设置
    set(groot,'defaultAxesFontName',paperFontName());
    set(groot,'defaultTextFontName',paperFontName());
    set(groot,'defaultLegendFontName',paperFontName());
    set(groot,'defaultColorbarFontName',paperFontName());
end

