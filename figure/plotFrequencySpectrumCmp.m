function plotFrequencySpectrumCmp(legendText,varargin)
%���ƶ�����ݵ�Ƶ��
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
    xlabel('Ƶ��','FontSize',paperFontSize());
    ylabel('��ֵ','FontSize',paperFontSize());
    
end