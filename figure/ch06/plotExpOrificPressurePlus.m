function [ output_args ] = plotExpOrificPressurePlus(dataCombineStruct,varargin)
%绘制实验孔板的压力脉动图
pp = varargin;
errorType = 'std'
rang = 1:13;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'errortype' %波数
        	errorType = val;
        case 'rang'
            rang = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
figure
[y,stdVal,maxVal,minVal] = getExpCombineReadedPlusData(dataCombineStruct);
x = rang;
y = y(rang);
if strcmp(errorType,'std')
    yUp = y + stdVal(rang);
    yDown = y - stdVal(rang);
else
    yUp = maxVal(rang);
    yDown = minVal(rang);
end
[curHancle,fillHandle] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(1));
xlabel('测点');
ylabel('脉动峰峰值(kPa)');
paperFigureSet_normal();
end

