%% �ֶ������������ֵ
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%

dataPath = getDataPath();
expMatDataPath = fullfile(dataPath,'ʵ��ԭʼ����\��������ÿװ�0.5D���м�\����300ת��ѹ.mat');


%%��ʼ��ȡ��һ�����ݵ�ѹ��ֵ
expDataCells = load(expMatDataPath);


load(expMatDataPath);
sigmaValues = zeros(1,size(dataStruct.rawData.pressure,2));
plusValue = sigmaValues;
meanValue = plusValue;
sigma = 1.5;
zoomIndexStartPresent = 0.3;%�Ŵ�Ŀ�ʼλ��0.3
zoomIndexEndPresent = 0.35;%�Ŵ�Ľ���λ��0.35
isSave = 1;
reject = 0;
for i = 1:size(dataStruct.rawData.pressure,2)
    p = dataStruct.rawData.pressure(:,i);
    fs = dataStruct.input.fs;
    while 1
        sigma=inputdlg(sprintf('������%d��sigmaֵ',i),'sigma',1,{sprintf('%g',sigma)});
        if isempty(sigma)
            button = questdlg('�Ƿ���ֹ���㣬����������һ�����'...
                ,'ѯ��'...
                ,'��ֹ�����˳�����','������һ�����','������һ�����');
            if strcmp(button,'��ֹ�����˳�����')
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
        title(sprintf('���%d���ܹ���%d����,sigma%g��Χ֮�����%d����',i,length(p),sigma,length(out_index)));
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
        
        button = questdlg(sprintf('�Ƿ������Ϊ���%d��sigmaֵ',i)...
                ,'ѯ��'...
                ,'��','��','��');
        if strcmp(button,'��')
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
    button = questdlg('��;��ֹ���㣬�Ƿ���Ҫ���氡��~~'...
        ,'ѯ��'...
        ,'����','��Ҫ����','��Ҫ����');
    if strcmp(button,'����')
        isSave = 1;
    else
        isSave = 0;
    end
end
if isSave
    resCell{1,1} = '���';
    resCell{1,2} = 'sigmaֵ';
    resCell{1,3} = '�������ֵ';
    resCell{1,4} = '��ֵ';
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