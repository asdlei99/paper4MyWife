function res = paperPlotInnerPipeTheory(param,isSaveFig)
%�ڲ�ܵ�ʵ��Ա�
if isempty(param)
	param.acousticVelocity = 345;%���٣�m/s��
	param.isDamping = 1;
	param.coeffFriction = 0.03;
	param.meanFlowVelocity = 16;
	param.L1 = 3.5;%(m)
	param.L2 = 6;
	param.Lv1 = 1.1/2;
	param.Lv2 = 1.1/2;
	param.l = 0.01;%(m)����޵����ӹܳ�
	param.Dv = 0.372;
	param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
	param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
	param.Dpipe = 0.098;%�ܵ�ֱ����m��
	param.Lbias = 0.168+0.150;
	param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2];
	param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
	param.rpm = 420;
	param.outDensity = 1.5608;
	param.Fs = 4096;
	param.Lin = 0.200;
	param.Lout = 0.200;
	param.Dinnerpipe = param.Dpipe;
end
freRaw = [14,21,28,42,56,70];
massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
massFlowDataCell = [freRaw;massFlowERaw];

%innerPipePulsation('param',param,'massflowData',massFlowDataCell);

count = 1;
if true
	Dinnerpipe = (param.Dpipe/1.5) : 0.01: (param.Dpipe*2);
	res{count,1} = '�ڲ�ܹܾ���С�仯��������Ӱ��';
	res{count,2} = plotInnerPipeChangeD(Dinnerpipe,param,massFlowDataCell,isSaveFig);
end

end

%�����ڲ�ܹܾ���С�ı��������Ӱ��
function res = plotInnerPipeChangeD(Dinnerpipe,param,massFlowDataCell,isSaveFig)
	res = innerPipePulsationChangInnerD(Dinnerpipe,'param'...
										,param,'massflowData'...
										,massFlowDataCell...
										,'fast',true...
										);
	figure
	paperFigureSet('small',6);
	measurePoints = floor(linspace(1,size(res{1,1},2),4));
    X = res{1,3};
	hold on;
	for i = 1:size(res,1)
		v(i,:) = res{i,2}(measurePoints);
	end
	legendText = {};
	for i = 1:size(v,2)
		legendText{i} = sprintf('����%g',X(measurePoints(i)));
		h(i) = plot(Dinnerpipe.*1000,v(:,i)./1000,'color',getPlotColor(i),'Marker',getMarkStyle(i));
	end
	legend(h,legendText,'Position',[0.544532903222646 0.688236222436951 0.340579706041709 0.314243750775264]);
    box on;
    ax = axis();
    plot([param.Dpipe.*1000,param.Dpipe.*1000],[ax(3),ax(4)],'--r');
    xlabel('�ڲ�ܾ�(mm)','FontSize',paperFontSize());
    ylabel('�����������ֵ(kPa)','FontSize',paperFontSize());
    if isSaveFig
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch06'),'�ڲ�ܹܾ���������Ӱ��');
	end
end




