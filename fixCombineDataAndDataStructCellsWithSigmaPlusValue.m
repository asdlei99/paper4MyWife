function res = fixCombineDataAndDataStructCellsWithSigmaPlusValue( folderPath )
%�˺��������������ݺ󣬰��˹���ȡ������ֵ���õ�dataStructCells��combineDataStruct
%   �˴���ʾ��ϸ˵��
    dataStructCells = loadExpDataStructCellFromFolderPath(folderPath);
    sigmaPlusValue = loadSigmaPlusValueStructFromFolderPath (folderPath);
    plV = sigmaPlusValue.expPlusValues;
    sgV = sigmaPlusValue.expSigmaValues;
%����dataStructCells
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

