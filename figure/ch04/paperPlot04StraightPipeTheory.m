function res = paperPlot04StraightPipeTheory(param,isSaveFig)
%绘制直管理论模拟实验
	if isempty(param)
		param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
		param.rpm = 420;
		param.outDensity = 1.5608;
		param.Fs = 4096;
		param.acousticVelocity = 345;%声速（m/s）
		param.isDamping = 1;
		param.coeffFriction = 0.03;
		param.meanFlowVelocity = 16;
		param.L1 = 3.5;%(m)
		param.L2 = 6;
		param.L = 3.5+6;
		param.l = 0.01;%(m)缓冲罐的连接管长
		param.Dpipe = 0.098;%管道直径（m）
		param.sectionL = 0:0.5:param.L;%linspace(0,param.L1,14);
	end
	freRaw = [14,21,28,42,56,70];
	massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
	massFlowDataCell = [freRaw;massFlowERaw];
	%绘制直管管径变化的影响
	if 0
		plotStraightPipeChangD(param,massFlowDataCell,isSaveFig);
	end
	%绘制直管管长对脉动的影响
	if 1
		plotStraightPipeChangL(param,massFlowDataCell,isSaveFig);
	end
end

function plotStraightPipeChangD(param,massFlowDataCell,isSaveFig)
%绘制直管管径变化的影响
	DRang = 0.03:0.02:0.25;
	theRes = straightPipeChangDpipe(DRang,param.Dpipe,param.meanFlowVelocity...
					,'massflowdata',massFlowDataCell...
					,'param',param...
					);
	figHandle = figure;
	paperFigureSet('normal',7);
	fh = figureTheoryPressurePlus(theRes(2:end,2),theRes(2:end,3)...
				,'Y',DRang.*1000 ...
				,'chartType','surf'...
				,'sectionY',param.Dpipe*1000 ...
				,'markSectionY','markLine' ...
				);
	xlabel('距离(m)','FontSize',paperFontSize());
    ylabel('管径(mm)','FontSize',paperFontSize());
	zlabel('压力脉动峰峰值(kPa)','FontSize',paperFontSize());
	view(114,40);
	set(fh.gca,'Position',[0.13 0.1405 0.8104 0.8127]);
	axis tight;
	box on;
	if isSaveFig
		set(fh.gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'直管管径对气流脉动的影响');
		close(figHandle);
	end
end

function plotStraightPipeChangL(param,massFlowDataCell,isSaveFig)
%直管管长对脉动的影响
	L = 5:1:20;
	theRes = straightPipeChangL(L...
					,'massflowdata',massFlowDataCell...
					,'param',param...
					);
	figHandle = figure;
	paperFigureSet('normal',7);
	fh = figureTheoryPressurePlus(theRes(2:end,2),theRes(2:end,3)...
				,'Y',L ...
				,'chartType','contourf'...%contour3,contourf,contourc
				,'sectionY',param.L ...
				,'markSectionY','markLine' ...
				);
	set(fh.plotHandle,'LevelStep',1,'LineStyle','none');
	hold on;
	ax = axis();
	plot([ax(1),ax(2)],[12,12],'color','k','LineStyle','--');
	text(ax(2),12,'12');
	plot([ax(1),ax(2)],[param.L,param.L],'color','k');
	text(ax(2),param.L,sprintf('%g',param.L));
	plot([L(1),L(1)],[L(end),L(end)],'b-');
	
	xlabel('管线距离(m)','FontSize',paperFontSize());
    ylabel('管长(m)','FontSize',paperFontSize());
	zlabel('压力脉动峰峰值(kPa)','FontSize',paperFontSize());
	set(fh.gca,'Position',[0.13 0.1405 0.8104 0.8127]);
	axis tight;
	box on;
	if isSaveFig
		set(fh.gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'直管长度对气流脉动的影响');
		close(figHandle);
	end
end
