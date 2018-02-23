function ret = paperPlotFacPerforatePipeTheory(param,isSaveFigure,varargin)
%孔管的理论计算
    pp = varargin;
    saveXlsPath = [];%保存的xls路径，如果有就会保存数值
    while length(pp)>=2
        prop = pp{1};
        val = pp{2};
        pp = pp(3:end);
        switch lower(prop)
			case 'savexlspath' %保存xls的路径
				saveXlsPath = val;
			otherwise
				error('参数错误%s',prop);
        end
    end
       
	freRaw = [11,22.39,33.62,44.85,56.01,67.24,78.4];%[11,22.39,33.62,44.85,56.01,67.24,78.4];
	massFlowERaw = [0.95,0.38,0.0236,0.01647,0.01378,0.01199,0.09];%[0.95,0.38,0.236,0.1647,0.1378,0.1199,0.09];
	massFlowDataCell = [freRaw;massFlowERaw];
    res = FacPerforateClosePulsation('param',param,'massflowdata',massFlowDataCell,'fast',1);
	x = res{3};
    y = res{2}./1000;
	plot(x,y)
    
    if ~isempty(saveXlsPath)
        %         t = table(x,y);
        %         writetable(t,saveXlsPath);
        %
        excelCell = cell(length(x)+2,2);
        excelCell{1,1} = '孔管工程应用理论计算';
        excelCell{2,1} = 'x';
        excelCell{2,2} = 'y';
        for i=1:length(x)
            excelCell{2+i,1} = x(i);
            excelCell{2+i,2} = y(i);
        end
        xlswrite(saveXlsPath,excelCell);
        
    end

	ret.x = x';
	ret.plus = y';
end




