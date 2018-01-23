dataPath = getDataPath();
simAxisPath = fullfile(dataPath,'ģ������','������������տ�-��M���н��ڱ߽�','simulationDataStruct.mat');
simDiameterPath = fullfile(dataPath,'ģ������','���������������տ�-��M���н��ڱ߽�','simulationDataStruct.mat');
simAxisDataCell = loadSimDataStructCell(simAxisPath);
simDiameterDataCell = loadSimDataStructCell(simDiameterPath);

measurePoint = 3;
dataSimAxis = [simAxisDataCell.rawData.Fre(:,measurePoint),simAxisDataCell.rawData.Mag(:,measurePoint)];
dataSimDiameter = [simDiameterDataCell.rawData.Fre(:,measurePoint),simDiameterDataCell.rawData.Mag(:,measurePoint)];

figure
legendText = {'��������','��������'};
plotFrequencySpectrumCmp(legendText,dataSimAxis,dataSimDiameter);


