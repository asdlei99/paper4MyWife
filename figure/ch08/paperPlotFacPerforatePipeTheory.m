function paperPlotFacPerforatePipeTheory(param,isSaveFigure)
%孔管的理论计算
	freRaw = [11,22.39,33.62,44.85,56.01,67.24,78.4];%[11,22.39,33.62,44.85,56.01,67.24,78.4];
	massFlowERaw = [0.95,0.38,0.0236,0.01647,0.01378,0.01199,0.09];%[0.95,0.38,0.236,0.1647,0.1378,0.1199,0.09];
	massFlowDataCell = [freRaw;massFlowERaw];
    res = FacPerforateClosePulsation('param',param,'massflowdata',massFlowDataCell);
	x = res{2,3};
    y = res{2,2}.pulsationValue./1000;
	plot(x,y)
end




