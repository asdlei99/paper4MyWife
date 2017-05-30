%% 手动定义脉动峰峰值
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%

dataPath = getDataPath();
expMatDataPath = fullfile(dataPath,'实验原始数据\缓冲罐内置孔板0.5D罐中间\开机300转带压.mat');


%%开始读取第一个数据的压力值
expDataCells = load(expMatDataPath);


load(expMatDataPath);
sigmaValues = zeros(1,size(dataStruct.rawData.pressure,2));
plusValue = sigmaValues;
meanValue = plusValue;
sigma = 1.5;
zoomIndexStartPresent = 0.3;%放大的开始位置0.3
zoomIndexEndPresent = 0.35;%放大的结束位置0.35
isSave = 1;
reject = 0;
for i = 1:size(dataStruct.rawData.pressure,2)
    p = dataStruct.rawData.pressure(:,i);
    fs = dataStruct.input.fs;
    while 1
        sigma=inputdlg(sprintf('输入测点%d的sigma值',i),'sigma',1,{sprintf('%g',sigma)});
        if isempty(sigma)
            button = questdlg('是否终止计算，或者跳到下一个测点'...
                ,'询问'...
                ,'终止计算退出程序','跳到下一个测点','跳到下一个测点');
            if strcmp(button,'终止计算退出程序')
                reject = 1;
            else
                continue;
            end
        end
        if reject
            break;
        end
        sigma = str2num(sigma{1});
        [out_index,meadUpStd,meadDownStd,meanValue(i),stdValue] =  sigmaOutlierDetection(p,sigma);
        
        fh = figure();
        subplot(2,1,1)
        set(fh,'outerposition',get(0,'screensize'));
        [~,time,~,~] = plotWave(p,fs,'figureHandle',fh);
        hold on;
        ax = axis();
        h = plot([ax(1),ax(2)],[meadUpStd,meadUpStd],'--');
        set(h,'color','r');
        h = plot([ax(1),ax(2)],[meadDownStd,meadDownStd],'--');
        set(h,'color','r');
        title(sprintf('测点%d，总共有%d个点,sigma%g范围之外的有%d个点',i,length(p),sigma,length(out_index)));
        subplot(2,1,2)
        hold on;
        xStartIndex = ceil(length(time)*zoomIndexStartPresent);
        xEndIndex = floor(length(time)*zoomIndexEndPresent);
        plot(time(xStartIndex:xEndIndex),p(xStartIndex:xEndIndex),'-b');
        ax = axis();
        h = plot([ax(1),ax(2)],[meadUpStd,meadUpStd],'--');
        set(h,'color','r');
        h = plot([ax(1),ax(2)],[meadDownStd,meadDownStd],'--');
        set(h,'color','r');
        
        button = questdlg(sprintf('是否可以作为测点%d的sigma值',i)...
                ,'询问'...
                ,'是','否','是');
        if strcmp(button,'是')
            close(fh);
            sigmaValues(1,i) = sigma;
            plusValue(1,i) = meadUpStd - meadDownStd;
            break;
        else 
            close(fh);
            continue;
        end
    end
    if reject
        break;
    end
end

if reject
    button = questdlg('中途终止计算，是否需要保存啊亲~~'...
        ,'询问'...
        ,'保存','不要保存','不要保存');
    if strcmp(button,'保存')
        isSave = 1;
    else
        isSave = 0;
    end
end
if isSave
    resCell{1,1} = '测点';
    resCell{1,2} = 'sigma值';
    resCell{1,3} = '脉动峰峰值';
    resCell{1,4} = '均值';
    for i = 1:length(sigmaValues)
        resCell{i+1,1} = i;
        resCell{i+1,2} = sigmaValues(i);
        resCell{i+1,3} = plusValue(i);
        resCell{i+1,4} = meanValue(i);
    end
    saveFilePath = expMatDataPath(1:end-4);
    saveFilePath = [saveFilePath,'-ppf.xlsx'];
    xlswrite(saveFilePath,resCell);
end