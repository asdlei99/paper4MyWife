function [ mean,err ] = loadExpStandardVesselData()
%提取标准缓冲罐用于做脉动抑制率对比的数据
    dataPath = getDataPath();
    baseVesselDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\RPM420');%侧前进直后出
    [~,baseVesselCombineData] = loadExpDataFromFolder(baseVesselDataPath);%侧前进直后出
    [mean,~,~,~,muci] = getExpCombineReadedPlusData(baseVesselCombineData);
    err = muci(2,:) - muci(1,:);
end

