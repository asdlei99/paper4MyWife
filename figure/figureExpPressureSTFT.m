function [fh,spectrogramData] = figureExpPressureSTFT(dataCells,meaPoint,Fs,varargin)
%绘制实验数据的短时傅立叶变换的普图
% dataCells：dataStructCells下的具体测量的数据dataStructCells{n,2}
% meaPoint:测点
% varargin可选属性：
% chartType：绘图类型，可选‘contour’（默认）或者‘plot3’
% baseField: 绘图数据类型，
pp = varargin;
chartType = 'contour';
baseField = 'rawData';
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
        case 'charttype'
            chartType = val;
        case 'basefield'
            baseField = val;
        otherwise
       		error('参数错误%s',prop);
    end
end

figure
paperFigureSet_normal();
wave=dataCells.pressure(:,meaPoint);
[fh,spectrogramData] = plotSTFT( wave,SIFT,Fs,varargin )
xlabel('frequency(Hz)'); 
ylabel('time(s)');
zlabel('amplitude');

end

