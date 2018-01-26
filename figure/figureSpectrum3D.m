function [fh,clX1,clY1,clX2,clY2] = figureSpectrum3D(dataCell,varargin)
%绘制频谱
%   此处显示详细说明
    %LineStyle = 'none';
    pp = varargin;
    input_args = {};
    rang = 1:13;
    clX1 = [];
    clY1 = [];
    isShadow = true;
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'rang'
                rang = val;
            case 'isshadow'
                isShadow = val;
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
    xlabel('频率(Hz)','FontSize',paperFontSize());
    ylabel('测点','FontSize',paperFontSize());
    zlabel('幅值','FontSize',paperFontSize());
    fh.mark1 = plot3(clX1,rang,clY1,'-b','Marker','.');
    fh.mark2 = plot3(clX2,rang,clY2,'-b','Marker','.');
    axis tight;
    ylim([0,rang(end)+1]);
    if isShadow
        F = dataCell.Fre(:,1);
        M = dataCell.Mag(:,rang);
        YZ = max(M);
        XZ = max(M,[],2);
        ax = axis();
        X = zeros(1,length(YZ));
        fh.shadowYZ = plot3(X,rang,YZ,'color',[247,142,28]./255);
        fY = [rang(1),rang,rang(end),rang(1)];
        fZ = [0,YZ,0,0];
        fX = zeros(1,length(fY));
        fh.shadowFillYZ = fill3(fX,fY,fZ,[247,142,28]./255,'edgealpha',0,'FaceAlpha',0.3);

        Y = ones(1,length(F));
        Y = Y .* ax(4);
        fh.shadowXZ = plot3(F,Y,XZ,'color',[15,149,216]./255);
        fZ = [0,XZ',0,0];
        fX = [0,F',F(end),0];
        fY = ones(1,length(fZ)) .* ax(4);
        fh.shadowFillXZ = fill3(fX,fY,fZ,[15,149,216]./255,'edgealpha',0,'FaceAlpha',0.3);
    end
end

