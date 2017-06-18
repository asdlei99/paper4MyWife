function [ output_args ] = plotExpOrificPressurePlus(dataCombineStruct,varargin)
%����ʵ��װ��ѹ������ͼ
pp = varargin;
errorType = 'std'
rang = 1:13;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'errortype' %����
        	errorType = val;
        case 'rang'
            rang = val;
        otherwise
       		error('��������%s',prop);
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
xlabel('���');
ylabel('�������ֵ(kPa)');
paperFigureSet_normal();
end

