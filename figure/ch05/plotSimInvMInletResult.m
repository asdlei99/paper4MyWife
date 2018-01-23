dataPath = getDataPath();
simAxisPath = fullfile(dataPath,'模拟数据','单罐轴向进出闭口-逆M序列进口边界','simulationDataStruct.mat');
simDiameterPath = fullfile(dataPath,'模拟数据','单罐轴向进径向出闭口-逆M序列进口边界','simulationDataStruct.mat');
simAxisDataCell = loadSimDataStructCell(simAxisPath);
simDiameterDataCell = loadSimDataStructCell(simDiameterPath);

measurePoint = 3;
dataSimAxis = [simAxisDataCell.rawData.Fre(:,measurePoint),simAxisDataCell.rawData.Mag(:,measurePoint)];
dataSimDiameter = [simDiameterDataCell.rawData.Fre(:,measurePoint),simDiameterDataCell.rawData.Mag(:,measurePoint)];

figure
legendText = {'轴向排气','径向排气'};
plotFrequencySpectrumCmp(legendText,dataSimAxis,dataSimDiameter);


