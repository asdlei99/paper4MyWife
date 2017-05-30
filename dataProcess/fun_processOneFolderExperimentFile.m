function dataStructCells = fun_processOneFolderExperimentFile( fileFolderPath,varargin )
% 加载一个文件夹下北区的实验数据到dataStructCells里
%   文件路径
    filelist=dir(fullfile(fileFolderPath,'*.xlsx'));
    filelist = [filelist;dir(fullfile(fileFolderPath,'*.CSV'))];
    file_count = 1;
    for i_files=1:length(filelist)
        xlsFilesName = filelist(i_files).name;
        if xlsFilesName(1) == '~'
            continue;
        end
        xlsDataFileFullPath = fullfile(fileFolderPath,xlsFilesName);
        dataStructCells{file_count,1} = filelist(i_files).name;
        dataStructCells{file_count,2} = fun_processOneExperimentFile(xlsDataFileFullPath,varargin);
        file_count = file_count + 1;
    end
    
end