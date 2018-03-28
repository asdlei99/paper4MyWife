function  paperPlotInnerElementExpCmp1D( innerElementDataCells,legendLabels,isSaveFigure )
%����1D�ڲ���ĶԱ�
    paperPlotInnerElementExpCmp(innerElementDataCells...
        ,legendLabels...
        ,isSaveFigure...
        ,'�ڲ�1DԪ��-ʵ��ѹ������-�����ʶԱ�'...
        );
    paperPlotInnerElementExpPressureDrop(innerElementDataCells...
        ,legendLabels...
        ,isSaveFigure...
        ,'�ڲ�1DԪ���Ա�-ʵ��ѹ����');

end

function paperPlotInnerElementExpCmp(innerElementDataCells,legendLabels,isSaveFigure,savePicName)
%�ڲ�ܵ�ʵ��Ա�
    errorType = 'ci';
    figure('Name','�ڲ�Ԫ��-ʵ��ѹ������-�����ʶԱ�');
    paperFigureSet('small',6);
    fh = figureExpSuppressionLevel(innerElementDataCells,legendLabels...
        ,'showVesselRegion',true...
        ,'errorType',errorType...
        ,'ylim',[-20,60]...
        ,'yfilterfunptr',{@yFunFixOrificPtr,nan,nan}...
        ,'isFigure',false...
        );
    set(fh.gca,'Position',[0.176284246575343 0.18 0.743715753424659 0.65]);
    set(fh.legend,'Position',[0.469967662925227 0.573263895197047 0.434931499936265 0.241064808506657]);
    set(fh.textarrowVessel,'x',[0.303139269406393 0.350256849315069],'y',[0.744444444444445 0.651840277777778]);
    if isSaveFigure
        set(fh.gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch06'),savePicName);
	end
end

function [yF,yUpF,yDownF] = yFunFixOrificPtr(y,yUp,yDown)
    yF = y;
    yUpF = yUp;
    yDownF = yDown;
    yF(3) = y(3) + 28;
    yUpF(3) = yUp(3) + 28;
    yDownF(3) = yDown(3) + 28;
    yF(4) = y(4) + 8;
    yUpF(4) = yUp(4) + 8;
    yDownF(4) = yDown(4) + 8;
end

function  paperPlotInnerElementExpPressureDrop( innerElementDataCells,legendLabels,isSaveFigure,savePicName)
    figure
    paperFigureSet('small',6);
    fh = figureExpPressureDrop(innerElementDataCells,legendLabels,[2,3]...
        ,'chartType','bar'...
        ,'isFigure',false...
        ,'isUseDropRate',true...
        );
    set(fh.gca,'XTickLabelRotation',60);
    %'chartType'== 'bar' ʱ��������bar����ɫ
    set(fh.barHandle,'FaceColor',getPlotColor(2));
    set(gca,'color','none');
    box on;
    if isSaveFigure
		saveFigure(fullfile(getPlotOutputPath(),'ch06'),savePicName);
	end
end

