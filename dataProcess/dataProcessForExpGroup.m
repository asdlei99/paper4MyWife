function dataStruct = dataProcessForExpGroup( expGroupFolder )
%处理一组实验数据，把一个文件夹的所有excel组合成一个struct
filelist=dir(fullfile(expGroupFolder,'*.xlsx'));
filelist = [filelist;dir(fullfile(datasPath,'*.CSV'))];
filelist = [filelist;dir(fullfile(datasPath,'*.xls'))];
file_count = 1;
for i_files=1:length(filelist)
    xlsFilesName = filelist(i_files).name;
    if xlsFilesName(1) == '~'
        continue;
    end
    xlsDataFileFullPath = fullfile(datasPath,xlsFilesName);
end
end

