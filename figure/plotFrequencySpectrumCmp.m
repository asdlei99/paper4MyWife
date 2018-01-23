function plotFrequencySpectrumCmp(legendText,varargin)
%绘制多个数据的频谱
    count = 1;
    for i = 1:length(varargin)
        points = varargin{i};
        h(count) = plot(points(:,1),points(:,2));
        if(1 == count)
            hold on;
        end
        count = count + 1;
    end
    legend(h,legendText);
    xlabel('频率','FontSize',paperFontSize());
    ylabel('幅值','FontSize',paperFontSize());
    
end