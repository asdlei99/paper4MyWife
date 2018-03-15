%% 第五章 绘图 - 缓冲罐对比分析

clear all;
close all;
clc;
isSaveFigure = false;
%% 缓冲罐计算的参数设置
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 335;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.02;
param.meanFlowVelocity = 12;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv = 1.1;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m）
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];
lvLen = 0.318;
param.lv1 = lvLen;
param.lv2 = lvLen;

VExp = (pi * (param.Dv^2)) ./ 4 * param.Lv;%实验对应的体积
VApi618 = constVExpApi618();%API618的体积

freRaw = [14,21,28,42,56,70];
massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
time = makeTime(param.Fs,1024);
%% 研究缓冲罐体积变化时哪种结构形式的结构有着更好的优势
% 此对比使用和直管的脉动抑制率作为比较

%计算直管脉动
straightL = param.L1 + param.L2 + 2*param.l + param.Lv;
straightSectionL = param.X;
pressure = straightPipePulsationCalc(massFlowERaw, freRaw, time, straightL, straightSectionL,...
									'D', param.Dpipe,...
									'a', param.acousticVelocity,...
									'isDamping', param.isDamping,...
									'friction', param.coeffFriction,...
									'isOpening', param.isOpening,...
									'meanFlowVelocity', param.meanFlowVelocity...
									);
straightPlus = calcPuls(pressure);

% vTypes = {'StraightInStraightOut', 'BiasFontInStraightOut', 'straightinbiasout', 'biasInBiasOut',...
		 % 'EqualBiasInOut', ...
		 % 'BiasFrontInBiasFrontOut'};
vTypes = {'StraightInStraightOut', 'BiasFontInStraightOut', 'straightinbiasout'};
textLabel = {'直进直出', '侧进直出', '直进侧出'};


%% 研究体积变化各种形式的缓冲罐的变化趋势
if 1
	VIte = (VApi618-0.05):0.015:(VExp*2);
	DvIte = ((4 .* VIte) ./ pi).^ 0.5;
	resCell = {};
	for v = 1:length(vTypes)
		vType = vTypes{v};
		calcCell = {};
		for i = 1:length(DvIte)
			Dv = DvIte(i);
			[pressure1,pressure2] = oneVesselPulsationCalc(massFlowERaw, freRaw, time,...
									param.L1, param.L2, param.Lv, param.l, param.Dpipe, Dv, ...
									param.sectionL1,param.sectionL2, ...
									'a',param.acousticVelocity,...
									'isDamping',param.isDamping,...
									'friction',param.coeffFriction,...
									'isOpening',param.isOpening,...
									'meanFlowVelocity',param.meanFlowVelocity,...
									'lv1',param.lv1,...
									'lv2',param.lv2,...
									'vType',vType...
									);
			plus = calcPuls([pressure1,pressure2]);
			%计算脉动抑制率
			plusRate = (straightPlus - plus) ./ straightPlus;
			calcCell{i,1} = Dv;
			calcCell{i,2} = (pi*Dv^2)/4;
			calcCell{i,3} = plus;
			calcCell{i,4} = plusRate;
			calcCell{i,5} = param.X;
		end
		resCell{v,1} = vType;
		resCell{v,2} = calcCell;
	end
	
	if 1
		p1 = find(param.X>2.5);
		p1 = p1(1);
		p1XValue = param.X(p1);

		for i=1:size(resCell,1)
			c = resCell{i,2};
			for j = 1:size(c,1)
				y1(i,j) = c{j,4}(p1XValue);
				yend(i,j) = c{j,4}(end);
			end
		end
		y1 = y1.*100;
		yend = yend.*100;
		%绘图
		figure('Name','首端测点')
		paperFigureSet('small',6);
		%绘制测点0的
		hold on;
		h = [];
		for i = 1:size(y1,1)
			h(i) = plot(VIte,y1(i,:),'marker',getMarkStyle(i),'color',getPlotColor(i));
			%text(VIte(end),y1(i,end),textLabel{i});
		end
		ax = axis();
		plot([VApi618,VApi618],[ax(3),ax(4)],'--r');
		plot([VExp,VExp],[ax(3),ax(4)],':b');
		box on;
		xlabel('体积','FontSize',paperFontSize());
		ylabel('抑制率(%)','FontSize',paperFontSize());
		legend(h,textLabel,0,'FontSize',paperFontSize()...
				,'Position',[0.48135494497354 0.208726851851853 0.39143835054753 0.332199065137517]);
        set(gca,'color','none');
        if isSaveFigure
            set(gca,'color','none');
            saveFigure(fullfile(getPlotOutputPath(),'ch05'),'体积变化对单容不同接法的影响-首端测点');
        end
        
		%绘制最后一个测点的
		%绘制测点0的
		figure('Name','末端测点');
		paperFigureSet('small',6);
		hold on;
		h = [];
		for i = 1:size(y1,1)
			h(i) = plot(VIte,yend(i,:),'marker',getMarkStyle(i),'color',getPlotColor(i));
			%text(VIte(end),yend(i,end),textLabel{i});
		end
		ax = axis();
		pplot([VApi618,VApi618],[ax(3),ax(4)],'--r');
		plot([VExp,VExp],[ax(3),ax(4)],':b');
		box on;
		xlabel('体积','FontSize',paperFontSize());
		ylabel('抑制率(%)','FontSize',paperFontSize());
		legend(h,textLabel,0,'FontSize',paperFontSize()...
				,'Position',[0.48135494497354 0.208726851851853 0.39143835054753 0.332199065137517]);
        if isSaveFigure
            set(gca,'color','none');
            saveFigure(fullfile(getPlotOutputPath(),'ch05'),'体积变化对单容不同接法的影响-末端测点');
        end
	end
end


%% 研究L1变化对各种形式的缓冲罐的变化趋势
if 0
	totalL = param.L1 + param.L2;
	L1Ite = 0.1:0.5:5;
	L2Ite = totalL - L1Ite;
	
	resCell = {};
	for v = 1:length(vTypes)
		vType = vTypes{v};
		calcCell = {};
		for i = 1:length(L1Ite)
			L1 = L1Ite(i);
			L2 = L2Ite(i);
			sectionL1 = 0:0.5:L1;
			sectionL2 = 0:0.5:L2;
			X = [sectionL1, sectionL1(end) + 2*param.l + param.Lv + sectionL2];
			straightSectionL = X;%直管的分区会变
			pressure = straightPipePulsationCalc(massFlowERaw, freRaw, time, straightL, straightSectionL,...
												'D', param.Dpipe,...
												'a', param.acousticVelocity,...
												'isDamping', param.isDamping,...
												'friction', param.coeffFriction,...
												'isOpening', param.isOpening,...
												'meanFlowVelocity', param.meanFlowVelocity...
												);
			straightPlus = calcPuls(pressure);
			[pressure1,pressure2] = oneVesselPulsationCalc(massFlowERaw, freRaw, time,...
									L1, L2, param.Lv, param.l, param.Dpipe, param.Dv, ...
									sectionL1,sectionL2, ...
									'a',param.acousticVelocity,...
									'isDamping',param.isDamping,...
									'friction',param.coeffFriction,...
									'isOpening',param.isOpening,...
									'meanFlowVelocity',param.meanFlowVelocity,...
									'lv1',param.lv1,...
									'lv2',param.lv2,...
									'vType',vType...
									);
			plus = calcPuls([pressure1,pressure2]);
			%计算脉动抑制率
			plusRate = (straightPlus - plus) ./ straightPlus;
			calcCell{i,1} = L1;
			calcCell{i,2} = L2;
			calcCell{i,3} = plus;
			calcCell{i,4} = plusRate;
			calcCell{i,5} = X;
		end
		resCell{v,1} = vType;
		resCell{v,2} = calcCell;
	end
	%由于相对直管的脉动抑制率变化过于大，在图上没法分辨，因此选用直进直出作为基准
	for i = 2:size(resCell,1)
		c = resCell{i,2};
		for j = 1:size(c,1)
			plusBase = resCell{1,2}{j,3};
			plus = c{j,3};
			plusRate = (plusBase - plus) ./ plusBase;
			c{j,4} = plusRate;
		end
		resCell{i,2}=c;
	end
	if 1

		y1=zeros(size(resCell,1)-1,size(resCell{1,2},1));
		yend=zeros(size(y1));
		for i=2:size(resCell,1)
			c = resCell{i,2};
			for j = 1:size(c,1)
				y1(i-1,j) = c{j,4}(1);
				yend(i-1,j) = c{j,4}(end);
			end
		end
		y1 = y1.*100;
		yend = yend.*100;
		%绘图
		figure
		paperFigureSet('large',6);
		%绘制测点0的
		ax1 = subplot(1,2,1);
		hold on;
		h = [];
		for i = 1:size(y1,1)
			h(i) = plot(L1Ite,y1(i,:),'marker',getMarkStyle(i),'color',getPlotColor(i));
			%text(VIte(end),y1(i,end),textLabel{i});
		end
		ax = axis(ax1);
		plot([param.L1,param.L1],[ax(3),ax(4)],'--r');
		box on;

		title('(a)','FontSize',paperFontSize());
		xlabel('L1(m)','FontSize',paperFontSize());
		ylabel('抑制率(%)','FontSize',paperFontSize());
		legend(h,textLabel(2:end),0,'FontSize',paperFontSize()...
            ,'Position',[0.279072423563708 0.199907407407408 0.204107139928355 0.254293974779064]);
        set(gca,'color','none');
		%绘制最后一个测点的
		%绘制测点0的
		ax2 = subplot(1,2,2);
		hold on;
		h = [];
		for i = 1:size(y1,1)
			h(i) = plot(L1Ite,yend(i,:),'marker',getMarkStyle(i),'color',getPlotColor(i));
			%text(VIte(end),yend(i,end),textLabel{i});
		end
		ax = axis(ax2);
		plot([param.L1,param.L1],[ax(3),ax(4)],'--r');
		box on;
		xlabel('L1(m)','FontSize',paperFontSize());
		ylabel('抑制率(%)','FontSize',paperFontSize());
		title('(b)','FontSize',paperFontSize());
		legend(h,textLabel(2:end),0,'FontSize',paperFontSize()...
            ,'Position',[0.751542661658948 0.194027784480196 0.204107139928356 0.254293974779064]);
        if isSaveFigure
            set(gca,'color','none');
            saveFigure(fullfile(getPlotOutputPath(),'ch05'),'变缓冲罐进口长度对照各种缓冲罐接法影响');
        end
	end
end
