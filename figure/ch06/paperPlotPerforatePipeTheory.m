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
		len = length(x);
		if len > maxLen
			maxLen = len;
		end
	end
	X = NaN(size(res,1),maxLen);
	
	for i=1:size(res,1)
		X(i,:) = res{i,3};
	end
end

function Z = getZs(res)
	maxLen = -1;
	for i=1:size(res,1)
		z = res{i,3};
		len = length(z);
		if len > maxLen
			maxLen = len;
		end
	end
	Z = NaN(size(res,1),maxLen);
	
	for i=1:size(res,1)
		Z(i,:) = res{i,2};
	end
end

function [c,h]=plotResultCell(res,rang)
	X = getXs(res);
	Y = zeros(size(X));
	for i=1:size(Y,2)
		Y(:,i) = rang;
	end
	Z = getZs(res);
    Z = Z./1000;
	[c,h]=contourf(X,Y,Z);
end

function theoryChangedp(rang,massFlowDataCell,param,isSaveFigure)
% 迭代开孔孔径
	res = PerforateClosePulsationChangedp(param,rang...
							,'massflowdata',massFlowDataCell,'fast',true);
                        
	figure('Name','内插管开孔孔径对气流脉动的影响')
	paperFigureSet('small',6);
	[c,h]=plotResultCell(res,rang.*1000);
	set(h,'LineStyle','none'...
		,'LevelStep',0.2 ...
		);
    set(gca,'Position',[0.149323667948511 0.18 0.644154592921054 0.75]);
    colormap jet;
    hbar = colorbar;
    set(get(hbar,'label'),'String','压力脉动峰峰值(kPa)','FontSize',paperFontSize());
    set(hbar,'Position',[0.804347826086957 0.18 0.0424309618852597 0.75]);
    
	xlabel('管线距离(m)','FontSize',paperFontSize);
	ylabel('开孔孔径(mm)','FontSize',paperFontSize)
	if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch06'),sprintf('内置孔管D%g-开孔孔径对气流脉动的影响',param.Din));
	end						
end
