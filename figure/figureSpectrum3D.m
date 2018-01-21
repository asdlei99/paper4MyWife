function [fh,clX1,clY1,clX2,clY2] = figureSpectrum3D(dataCell,varargin)
%绘制频谱
%   此处显示详细说明
    %LineStyle = 'none';
    pp = varargin;
    input_args = {};
    rang = 1:13;
    clX1 = [];
    clY1 = [];
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'rang'
                rang = val;
            otherwise%参数透传
           		input_args{length(input_args)+1} = prop;
                input_args{length(input_args)+1} = val;   
        end
    end
   
    for i = 1:length(rang)
        index = rang(i);
        fre = dataCell.Fre(:,index);
        mag = dataCell.Mag(:,index);
        if i >= 2
            hold on;
        end
        fh.plotHandle(i) = plotSpectrum3(fre,mag,index,input_args{:});
        [clY1(i),clX1(i),tmp] = closeLargeValue(fre,mag,14,0.5);
        [clY2(i),clX2(i),tmp] = closeLargeValue(fre,mag,14*2,0.5);
        clear tmp;
    end
    axis tight;
    xlabel('频率(Hz)','FontSize',paperFontSize());
    ylabel('测点','FontSize',paperFontSize());
    zlabel('幅值','FontSize',paperFontSize());
    fh.mark1 = plot3(clX1,rang,clY1,'-b','Marker','.');
    fh.mark2 = plot3(clX2,rang,clY2,'-b','Marker','.');
end

