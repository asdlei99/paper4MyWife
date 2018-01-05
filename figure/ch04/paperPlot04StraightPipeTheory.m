function res = paperPlot04StraightPipeTheory(param,isSaveFig)
%����ֱ������ģ��ʵ��
	if isempty(param)
		param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
		param.rpm = 420;
		param.outDensity = 1.5608;
		param.Fs = 4096;
		param.acousticVelocity = 345;%���٣�m/s��
		param.isDamping = 1;
		param.coeffFriction = 0.03;
		param.meanFlowVelocity = 16;
		param.L1 = 3.5;%(m)
		param.L2 = 6;
		param.L = 3.5+6;
		param.l = 0.01;%(m)����޵����ӹܳ�
		param.Dpipe = 0.098;%�ܵ�ֱ����m��
		param.sectionL = 0:0.5:param.L;%linspace(0,param.L1,14);
	end
	freRaw = [14,21,28,42,56,70];
	massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
	massFlowDataCell = [freRaw;massFlowERaw];
	%����ֱ�ܹܾ��仯��Ӱ��
	if 0
		plotStraightPipeChangD(param,massFlowDataCell,isSaveFig);
	end
	%����ֱ�ܹܳ���������Ӱ��
	if 1
		plotStraightPipeChangL(param,massFlowDataCell,isSaveFig);
	end
end

function plotStraightPipeChangD(param,massFlowDataCell,isSaveFig)
%����ֱ�ܹܾ��仯��Ӱ��
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
	xlabel('����(m)','FontSize',paperFontSize());
    ylabel('�ܾ�(mm)','FontSize',paperFontSize());
	zlabel('ѹ���������ֵ(kPa)','FontSize',paperFontSize());
	view(114,40);
	set(fh.gca,'Position',[0.13 0.1405 0.8104 0.8127]);
	axis tight;
	box on;
	if isSaveFig
		set(fh.gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'ֱ�ܹܾ�������������Ӱ��');
		close(figHandle);
	end
end

function plotStraightPipeChangL(param,massFlowDataCell,isSaveFig)
%ֱ�ܹܳ���������Ӱ��
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
	
	xlabel('���߾���(m)','FontSize',paperFontSize());
    ylabel('�ܳ�(m)','FontSize',paperFontSize());
	zlabel('ѹ���������ֵ(kPa)','FontSize',paperFontSize());
	set(fh.gca,'Position',[0.13 0.1405 0.8104 0.8127]);
	axis tight;
	box on;
	if isSaveFig
		set(fh.gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'ֱ�ܳ��ȶ�����������Ӱ��');
		close(figHandle);
	end
end
