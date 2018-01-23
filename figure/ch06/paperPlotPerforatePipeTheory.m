function paperPlotPerforatePipeTheory(param,isSaveFigure)
%孔管的理论计算
	freRaw = [14,21,28,42,56,70];
	massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
	massFlowDataCell = [freRaw;massFlowERaw];
	if 1
		%迭代开孔孔径
		rang = [0.004:0.004:0.03];
		theoryChangedp(rang,massFlowDataCell,param,isSaveFigure);
	end
	
end

function X = getXs(res)
	maxLen = -1;
	for i=1:size(res,1)
		x = res{i,3};
		len = length(x)
		if len > maxLen
			maxLen = len;
		end
	end
	X = zeros(size(res,1),maxLen);
	
	for i=1:size(res{},1)
		X(i,:) = res{i,3};
	end
end

function Z = getZs(res)
	maxLen = -1;
	for i=1:size(res,1)
		z = res{i,3};
		len = length(z)
		if len > maxLen
			maxLen = len;
		end
	end
	Z = zeros(size(res,1),maxLen);
	
	for i=1:size(res{},1)
		Z(i,:) = res{i,2};
	end
end

function plotResultCell(res,y)
	X = getXs(res);
	Y = zeros(size(x));
	for i=1:size(y,2)
		Y(:,i) = y;
	end
	
end

function theoryChangedp(rang,massFlowDataCell,param,isSaveFigure)
% 迭代开孔孔径
	res = PerforateClosePulsationChangedp(param,rang...
							,'massflowdata',massFlowDataCell,'fast',true);
	figure
	paperFigureSet('small',6);
	
	contourf
							
							
end
