%% �ֶ������������ֵ
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%
[fileName,pathName] = uigetfile('*.mat','ѡ��ʵ������Ԥ�����ļ�');
dataPath = getDataPath();
expMatDataPath = fullfile(pathName,fileName);
%expMatDataPath = fullfile(dataPath,'ʵ��ԭʼ����\��������ÿװ�0.5D���м�\����300ת��ѹ.mat');
zoomIndexStartPresent = 0.3;%�Ŵ�Ŀ�ʼλ��0.3
zoomIndexEndPresent = 0.35;%�Ŵ�Ľ���λ��0.35
sigmaValues = [];
sigmaValuesCell = {};
plusValuesCell = {};
%%��ʼ��ȡ��һ�����ݵ�ѹ��ֵ
dataStructCells = load(expMatDataPath);
dataStructCells = dataStructCells.expDataCells;
reject = 0;
quitProgram = 0;
isSave = 1;
sigmaData = 1.5;
plusValueMat = [];
sigmaValuesMat = [];
excelCells = {};
endDotIndex = strfind(fileName,'.');
excelPath = fileName(1:(endDotIndex(end)-1));
excelPath = strcat(excelPath,'_sigmaPlusValue.xls');
excelPath = fullfile(pathName,excelPath);
if exist(excelPath,'file')
    [~,~,excelCells] = xlsread(excelPath);
end
excelStartRow = size(excelCells,1) + 1;
excelCells{excelStartRow,1} = datestr(now);

for dataIndex = 1 : size(dataStructCells,1)
	dataStruct = dataStructCells{dataIndex,2};
	for i = 1:size(dataStruct.rawData.pressure,2)
    	p = dataStruct.rawData.pressure(:,i);
    	fs = dataStruct.input.fs;
		while 1
			if length(sigmaValues) > i
				sigmaData = sigmaValues(i);
			end
	        sigmaData=inputdlg(sprintf('������%d��sigmaֵ',i),'sigma',1,{sprintf('%g',sigmaData)});
	        if isempty(sigmaData)
	        	strBtn1 = '��ֹ�����˳�����';
	        	strBtn2 = '��ֹ������ת��һ��ʵ������';
	        	strBtn3 = '������һ�����';
	            button = questdlg('�Ƿ���ֹ���㣬����������һ�����'...
	                ,'ѯ��'...
	                ,strBtn1,strBtn2,strBtn3,strBtn3);

	            if strcmp(button,strBtn1)
	            	quitProgram = 1;
	                warning('�û���ֹ����');
	                break;
	            elseif strcmp(button,strBtn2)
	                reject = 1;
	                break;
	            elseif strcmp(button,strBtn3)
	                reject = 0;
	                break;   
	            end
	        end


	        sigmaData = str2num(sigmaData{1});
	        [out_index,meadUpStd,meadDownStd,meanValue(i),stdValue] =  sigmaOutlierDetection(p,sigmaData);
	        
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
	        title(sprintf('���%d���ܹ���%d����,sigma%g��Χ֮�����%d����',i,length(p),sigmaData,length(out_index)));
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
	            sigmaValues(1,i) = sigmaData;
	            plusValue(1,i) = meadUpStd - meadDownStd;
                excelCells{excelStartRow,i+1} = plusValue(1,i);
                excelCells{excelStartRow,i+21} = sigmaValues(1,i);
                
	            break;
	        else 
	            close(fh);
	            continue;
	        end
	    end

	    if reject
	        break;
	    else
	    	continue;
	    end
	    if quitProgram
	    	break;
	    end


    end
	if quitProgram
		break;
	end
	if reject
	   reject = 0;
	   continue;
    end
    excelStartRow = excelStartRow + 1;
    dataStructCells{dataIndex,3} = plusValue;
    dataStructCells{dataIndex,4} = sigmaValues;
    plusValueMat(dataIndex,:) = plusValue;
    sigmaValuesMat(dataIndex,:) = sigmaValues;
end


if quitProgram
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
    save(expMatDataPath,'dataStructCells');
    endDotIndex = strfind(expMatDataPath,'.');
    expMatDataPath = expMatDataPath(1:(endDotIndex(end)-1));
    expMatDataPath = strcat(expMatDataPath,'_sigmaPlusValue.mat');
    st.expPlusValues = plusValueMat;
    st.expSigmaValues = sigmaValuesMat;
    save(expMatDataPath,'st');
    xlswrite(excelPath,excelCells);
end