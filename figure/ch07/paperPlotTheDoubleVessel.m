function paperPlotTheDoubleVessel(param,isSaveFigure)
%�׹ܵ����ۼ���
	freRaw = [14,21,28,42,56,70];
	massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
	massFlowDataCell = [freRaw;massFlowERaw];
	if 0
		%�仺��޾���L2
		rang = [0.004:0.004:0.03];
		theoryChangedp(rang,massFlowDataCell,param,isSaveFigure);
	end
	
	if 1
		%����������
		theoryPerforatingRatios(param,isSaveFigure)
	end
	
	
end

function theoryChangeL2(param,massFlowDataCell,isSaveFigure)
    L2 = 0:0.5:3;
    doubleVesselChangDistanceToFirstVessel(L2...
                                            ,'param',param...
                                            ,'massflowdata',massFlowDataCell)
end