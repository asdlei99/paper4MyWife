function fh = plotCombineData(dataCombineStruct,dataField,varargin)
%����CombineStruct��ͼ
% dataCombineStruct ����һ��dataCombineStruct
% dataField Ҫ���Ƶ�filed
% varargin��ѡ���ԣ�
% errortype:'std':���������Ǳ�׼�'ci'����������95%�������䣬'minmax'����������min��max�������䣬��none������������
% rang������㷶Χ��Ĭ��Ϊ1:13,���Ǹı���˳�򣬷�����Ҫ���
% showpurevessel�����Ƿ���ʾ��һ����ޡ�
    pp = varargin;
    errorType = 'ci';
    rang = 1:13;
    legendLabels = {};
    isFigure = 0;
    otherProp = {};%���������ԣ����ڴ��ݸ�plot
    x = constExpMeasurementPointDistance();%����Ӧ�ľ���
    %��������İѵ�һ��varargin��Ϊlegend
    if 0 ~= mod(length(pp),2)
        legendLabels = pp{1};
        pp=pp(2:end);
    end
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'errortype' %����������
                errorType = val;
            case 'rang'
                rang = val;
            case 'isfigure'
                isFigure = val;
            case 'x'
                x = val;
            otherwise
                otherProp{length(otherProp)+1} = prop;
                otherProp{length(otherProp)+1} = val;
        end
    end
    if isFigure
        fh.gcf = figure();
        paperFigureSet_normal();
    end
    if iscell(dataField)
        if length(dataField) == 1
            [y,stdVal,maxVal,minVal,muci] = getExpCombineData(dataCombineStruct,dataField{1});
        elseif length(dataField) == 2
            [y,stdVal,maxVal,minVal,muci] = getExpCombineData(dataCombineStruct,dataField{2},dataField{1});
        end
    else
        [y,stdVal,maxVal,minVal,muci] = getExpCombineData(dataCombineStruct,dataField);
    end
    if isnan(y)
        error('û�л�ȡ�����ݣ���ȷ�����ݽ��й��˹�������ȡ');
    end
    y = y(rang);
    if strcmp(errorType,'std')
        yUp = y + stdVal(rang);
        yDown = y - stdVal(rang);
    elseif strcmp(errorType,'ci')
        yUp = muci(2,rang);
        yDown = muci(1,rang);
    elseif strcmp(errorType,'minmax')
        yUp = maxVal(rang);
        yDown = minVal(rang);
    end
    if strcmp(errorType,'none')
        fh.plotHandle = plot(x,y,otherProp{:});
    else
        [fh.plotHandle(plotCount),fh.errFillHandle(plotCount)] = plotWithError(x,y,yUp,yDown,otherProp{:});
    end


    
end




