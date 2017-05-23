function c = getPlotColor(index)
%»ñÈ¡ÑÕÉ«
    color = [0,118,174;
        255,116,0;
        0,161,59;
        239,0,0;
        158,99,181;
        152,82,71;
        246,110,184;
        192,189,44];
    color = color ./ 255;
    colorCount = size(color,1);
    if index > colorCount
        index = mod(index,colorCount);
    end
    if index == 0
        index = colorCount;
    end
    c = color(index,:);
end

