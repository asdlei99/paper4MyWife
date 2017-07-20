function [fh,spectrogramData] = figureExpPressureSTFT(dataCells,meaPoint,Fs,varargin)
%绘制实验数据的短时傅立叶变换的普图
% dataCells：dataStructCells下的具体测量的数据dataStructCells{n,2}
% meaPoint:测点
% varargin可选属性：
% chartType：绘图类型，可选‘contour’（默认）或者‘plot3’
% baseField: 绘图数据类型，
pp = varargin;
varargin = {};
STFT.windowSectionPointNums = 1024;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'stft' %误差带的类型
        	STFT = val;
        otherwise
       		varargin{length(varargin)+1} = prop;
            varargin{length(varargin)+1} = val;
    end
end


fh.figure = figure
if 1 == length(meaPoint)
    paperFigureSet_normal();
    wave=dataCells.pressure(:,meaPoint);
    [fh.plotHandles,spectrogramData] = plotSTFT( wave,STFT,Fs,varargin{:});
    box on;
    xlim([0,50]);
    xlabel('频率(Hz)'); 
    ylabel('时间(s)');
    zlabel('幅值(kPa)');
else
    paperFigureSet_FullWidth(8)
    for i=1:length(meaPoint)
        fh.subplotHandles = subplot(1,length(meaPoint),i);
        wave=dataCells.pressure(:,meaPoint(i));
        [fh.plotHandles(i),spectrogramData] = plotSTFT( wave,STFT,Fs,varargin{:});
        colorbar('off');
        box on;
        xlim([0,50]);
%         xlabel('频率(Hz)'); 
%         ylabel('时间(s)');
%         zlabel('幅值(kPa)');
    end
    colorbar;
end
end

