%% 第六章绘图
errorType = 'std';
dataPath = getDataPath();
%% 加载中间孔管缓冲罐数据
orificCombineDataPath = fullfile(dataPath,'\实验原始数据\内置孔板\缓冲罐内置孔板0.5D罐中间\开机420转带压_combine.mat');
%% 图6-6 中间孔管缓冲罐压力脉动及抑制率
st = load(orificCombineDataPath,'combineDataStruct');
orificCombineData = st.combineDataStruct;
plotExpOrificPressurePlus(orificCombineData,'errorType',errorType);
plotyy