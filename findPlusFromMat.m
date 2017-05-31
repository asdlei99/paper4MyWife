%% 手动定义脉动峰峰值
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%
[fileName,pathName] = uigetfile('*.mat','选择实验数据预处理文件');
dataPath = getDataPath();
expMatDataPath = fullfile(pathName,fileName);
%expMatDataPath = fullfile(dataPath,'实验原始数据\缓冲罐内置孔板0.5D罐中间\开机300转带压.mat');
zoomIndexStartPresent = 0.3;%放大的开始位置0.3
zoomIndexEndPresent = 0.35;%放大的结束位置0.35
sigmaValues = [];
sigmaValuesCell = {};
plusValuesCell = {};
%%开始读取第一个数据的压力值
expDataCells = load(expMatDataPath);
reject = 0;
quitProgram = 0;
isSave = 1;
for dataIndex = 1 : size(expDataCells,1)
	dataStruct = expDataCells{dataIndex,2};
	for i = 1:size(dataStruct.rawData.pressure,2)
    	p = dataStruct.rawData.pressure(:,i);
    	fs = dataStruct.input.fs;
		while 1
			if length(sigmaValues) > i
				sigma = sigmaValues(i);
			end
	        sigma=inputdlg(sprintf('输入测点%d的sigma值',i),'sigma',1,{sprintf('%g',sigma)});
	        if isempty(sigma)
	        	strBtn1 = '终止计算退出程序';
	        	strBtn2 = '终止计算跳转下一个实验数据';
	        	strBtn3 = '跳到下一个测点';
	            button = questdlg('是否终止计算，或者跳到下一个测点'...
	                ,'询问'...
	                ,strBtn1,strBtn2,strBtn3,strBtn3);

	            if strcmp(button,strBtn1)
	            	quitProgram = 1;
	                warning('用户终止程序');
	                break;
	            elseif strcmp(button,strBtn2)
	                reject = 1;
	                break;
	            elseif strcmp(button,strBtn3)
	                reject = 0;
	                break;   
	            end
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
    expDataCells{dataIndex,3} = plusValue;
    plusValuesCell{dataIndex,4} = sigmaValues;

end


if quitProgram
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
    save(expMatDataPath,'expDataCells');
end