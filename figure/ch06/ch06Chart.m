%% 第六章绘图
function ch06Chart
%第六章画图的参数设置
errorType = 'ci';
dataPath = getDataPath();
%% 加载中间孔管缓冲罐数据
orificCombineDataPath = fullfile(dataPath,'\实验原始数据\内置孔板\缓冲罐内置孔板0.5D罐中间\开机420转带压_combine.mat');
%% 图6-6 中间孔管缓冲罐压力脉动及抑制率
st = load(orificCombineDataPath,'combineDataStruct');
orificCombineData = st.combineDataStruct;
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