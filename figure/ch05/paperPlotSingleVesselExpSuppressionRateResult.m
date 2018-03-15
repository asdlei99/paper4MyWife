function [ output_args ] = paperPlotSingleVesselExpSuppressionRateResult( vesselDirectInDirectOutCombineData,vesselSuppressionRateCells,legendSuppressionRateLabels,isSaveFigure )
%���ƻ����ʵ���ֱ�ܵ�����������
    [ ddMean,~,~,~,muci,~ ] = getExpCombineReadedPlusData(vesselDirectInDirectOutCombineData);
    ddMean = ddMean(1:13);
    suppressionRateBase = ddMean;
    suppressionRateBaseErr = muci(2,1:13) - ddMean;
    xlabelText = '����(m)';
    ylabelText = '����������(%)';
    figure
    paperFigureSet('small',6);
    fh = figureExpPressurePlusSuppressionRate(vesselSuppressionRateCells...
            ,legendSuppressionRateLabels...        
            ,'errorPlotType','bar'...
            ,'showVesselRigon',0 ...
            ,'suppressionRateBase',suppressionRateBase...
            ,'suppressionRateBaseErr',suppressionRateBaseErr...
            ,'xIsMeasurePoint',0 ...
            ,'figureHeight',8 ...
            ,'xlabelText',xlabelText...
            ,'ylabelText',ylabelText...
            ,'isFigure',false...
            ,'ylim',[-20,40]...
            );
    fixSmallFigurePosition();
    set(fh.legend,...
        'Position',[0.471478364339335 0.570824799738908 0.521917798713734 0.241064808506657]);
    if isSaveFigure
        set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch05'),'ʵ�黺��޶�ֱ��ֱ��������������');
	end


end
