function paperPlotFacTheDoubleVessel(param,isSaveFigure)
%孔管的理论计算
	freRaw = [11,22.39,33.62,44.85,56.01,67.24,78.4];%[11,22.39,33.62,44.85,56.01,67.24,78.4];
	massFlowERaw = [0.95,0.38,0.0236,0.01647,0.01378,0.01199,0.09];%[0.95,0.38,0.236,0.1647,0.1378,0.1199,0.09];
	massFlowDataCell = [freRaw;massFlowERaw];
    res = FacDoubleVesselPulsation('param',param,'massflowdata',massFlowDataCell);
	x = res.X;
    xlswrite('D:\DVx.xls',x,'x','A1:A10000');
    y = res.plus./1000;
    xlswrite('D:\DVy.xls',y,'y','B1:B10000');
	plot(x,y)
	
end

