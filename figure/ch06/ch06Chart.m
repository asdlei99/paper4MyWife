%% 第六章绘图
function ch06Chart
%第六章画图的参数设置
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 加载中间孔管缓冲罐数据
orificD0_5CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.5RPM420罐中间');
orificD0_25CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.25RPM420罐中间');
orificD0_75CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.75RPM420罐中间');
orificD1CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D1RPM420罐中间');
%% 图6-6 中间孔管缓冲罐压力脉动及抑制率
[~,orificCombineData] = loadExpDataFromFolder(orificCombineDataPath);
plotExpPressurePlus(orificCombineData,'errorType',errorType);
plotExpSuppressionLevel(orificCombineData,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);
end

% 用于处理异常数据 - 处理孔管脉动抑制率的异常数据
function [yData,yUp,yDown] = fixInnerOrificY(y,up,down)
    y(3:5) =[-9,-4,1];
    up(3:5) = [0,3,8];
    down(3:5) = y(3:5) - ( up(3:5) - y(3:5) ) ;
    yData = y;
    yUp = up;
    yDown = down;
end