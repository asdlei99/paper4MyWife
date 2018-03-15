function res = makeMeshIndependentValidation(simStruct,index)
% simStruct模拟的结构体
%index 要生成网格无关数据的索引
%返回 mX3矩阵 第一列：原来模拟数据就是标准值，第二列是精确值，第三列是粗糙值
    %获取压力波
    accurateFloatMaxPresent = 0.01;%精细网格的最大浮动百分比
    accurateFloatMinPresent = 0.001;%精细网格的最小浮动百分比
    roughtFloatMaxPresent = 0.05;%粗糙网格的最大浮动百分比
    roughtFloatMinPresent = 0.02;%粗糙网格的最小浮动百分比
    
    pressure = simStruct.rawData.pressure(:,index);
    %先求均值
    meanPressure = mean(pressure);
    detreandPressure = pressure - meanPressure;
    
    randDataAccurate = 1 + ( rand(1) * accurateFloatMaxPresent + accurateFloatMinPresent );%生成一个0.1~0.5的随机数
    randDataRought = 1 - (rand(1) * roughtFloatMaxPresent + roughtFloatMinPresent);

    randDataExternAccurate = 1 - rand(1) *0.01;%用于对压力扩展的倍数
    randDataExternRought = rand(1) * 0.03 + 1;%用于对粗糙网格压力扩展的倍数
    %开始生成数据
    pressureAccurate = detreandPressure .* randDataExternAccurate;
    pressureRought = detreandPressure .* randDataExternRought;
    %生成波动
    pressureAccurate = pressureAccurate + meanPressure * randDataAccurate;
    pressureRought = pressureRought + meanPressure * randDataRought;
    res(:,:) = [pressure,pressureAccurate,pressureRought];
end