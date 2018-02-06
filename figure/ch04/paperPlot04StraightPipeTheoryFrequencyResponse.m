function res = paperPlot04StraightPipeTheoryFrequencyResponse(param,isSaveFig)
%����ֱ��Ƶ����Ӧ
	fs = 400;
	pressures = straightPipeFrequencyResponse('param',param,'fs',fs);
	[fre,amp] = frequencySpectrum(pressures,fs);
	figHandle = figure;
	paperFigureSet('small',6);
	plotSpectrumContourf(amp,fre,param.sectionL);
end

function plotStraightPipeChangD(DRang,param,massFlowDataCell,isSaveFig)
%����ֱ�ܹܾ��仯��Ӱ��
	theRes = straightPipeChangDpipe(DRang,param.Dpipe,param.meanFlowVelocity...
					,'massflowdata',massFlowDataCell...
					,'param',param...
					);
	figHandle = figure;
	paperFigureSet('small',6);
    ySection = [0.03,param.Dpipe,0.15,0.21].*1000;
    legendLabel = {'a','exp','b','c'};
	fh = figureTheoryPressurePlus(theRes(2:end,2),theRes(2:end,3)...
				,'Y',DRang.*1000 ...
				,'chartType','surf'...
				,'sectionY',ySection ...
				,'markSectionY','all' ...
                ,'markSectionYColor',[67,252,227]./255 ...
				);
    for i = 1:length(ySection)
        text(0,ySection(i),200,legendLabel{i},'FontSize',paperFontSize());
    end
	xlabel('����(m)','FontSize',paperFontSize());
    ylabel('�ܾ�(mm)','FontSize',paperFontSize());
	zlabel('ѹ���������ֵ(kPa)','FontSize',paperFontSize());
	view(114,40);
% 	set(fh.gca,'Position',[0.13 0.1405 0.8104 0.8127]);
    set(fh.gca,'Position',[0.189731735159819 0.1405 0.689074061941631 0.8127]);
	axis tight;
    zlim([0,200]);
	box on;
	if isSaveFig
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'ֱ�ܹܾ�������������Ӱ��');
		close(figHandle);
    end
    
    %���ƽ���
    figHandle = figure;
	paperFigureSet('small',6);
    h = [];
    hold on;
    for i = 1:length(fh.sectionYHandle.data)
        x = fh.sectionYHandle.data(i).x;
        z = fh.sectionYHandle.data(i).z;
        h(i) = plot(x,z,'Color',getPlotColor(i),'Marker',getMarkStyle(i));
    end
    box on;
    legend(h,legendLabel);
    xlabel('���߾���(m)','FontSize',paperFontSize());
    ylabel('ѹ���������ֵ(kPa)','FontSize',paperFontSize());
    if isSaveFig
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'ֱ�ܹܾ�������������Ӱ��-����');
		close(figHandle);
    end
end

function plotConstMassFlowDd(DRang,param,isSaveFig)
%�����������¹ܾ������������Ӱ��
    figHandle = figure;
	paperFigureSet('small',6);
    V = ((param.Dpipe .^ 2) ./ (DRang .^ 2)).*param.meanFlowVelocity;
    plot(DRang.*1000,V,'Color',getPlotColor(2),'Marker',getMarkStyle(2));
    hold on;
    axis tight;
    ax = axis();
    %���ʵ�����
    plot([98,98],[ax(3),ax(4)],':r');
    text(98,ax(4),'98mm');
    plot([ax(1),ax(2)],[param.meanFlowVelocity,param.meanFlowVelocity],':b');
    text(ax(2)-50,param.meanFlowVelocity+5,sprintf('%g m/s',param.meanFlowVelocity));
    xlabel('�ܾ�(mm)','FontSize',paperFontSize());
    ylabel('��������(m/s)','FontSize',paperFontSize());
    
    if isSaveFig
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'�����������¹ܾ������������Ӱ��');
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
	paperFigureSet('small',6);
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
	text(ax(2)-2,12+1,'12');
	plot([ax(1),ax(2)],[param.L,param.L],'color','k');
	text(ax(2)-2,param.L+1,sprintf('%g',param.L));
	plot([L(1),L(1)],[L(end),L(end)],'b-');
	
	xlabel('���߾���(m)','FontSize',paperFontSize());
    ylabel('�ܳ�(m)','FontSize',paperFontSize());
	zlabel('ѹ���������ֵ(kPa)','FontSize',paperFontSize());
	axis tight;
	box on;
    clbh = colorbar;
%     set(fh.gca,'Position',[0.13 0.158490566037736 0.700434027777778 0.794709433962264]);
    set(fh.gca,'Position',[0.13 0.175590277777778 0.656231884057971 0.776409722222222]);
	if isSaveFig
		set(fh.gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'ֱ�ܳ��ȶ�����������Ӱ��');
		close(figHandle);
	end
end
