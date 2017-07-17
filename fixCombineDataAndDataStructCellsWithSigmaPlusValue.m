function res = fixCombineDataAndDataStructCellsWithSigmaPlusValue( folderPath )
%此函数用于修正数据后，把人工读取的脉动值设置到dataStructCells和combineDataStruct
%   此处显示详细说明
    dataStructCells = loadExpDataStructCellFromFolderPath(folderPath);
    sigmaPlusValue = loadSigmaPlusValueStructFromFolderPath (folderPath);
    plV = sigmaPlusValue.expPlusValues;
    sgV = sigmaPlusValue.expSigmaValues;
%修正dataStructCells
    for i=1:size(plV,1)
        dataStructCells{i,3} = plV(i,:);
        dataStructCells{i,4} = sgV(i,:);
    end
%
    saveMatFilePath = fullfile(folderPath,[constDataStructCellsFileName(),'.mat']);
    save(saveMatFilePath,'dataStructCells');

    combineDataStruct = combineExprimentMatFile(saveMatFilePath);
    saveMatFilePath = fullfile(folderPath,[constCombineDataStructFileName(),'.mat']);
    save(saveMatFilePath,'combineDataStruct');
end

