function paperPlotPerforatePipeTheory(param,isSaveFigure)
%孔管的理论计算
	freRaw = [14,21,28,42,56,70];
	massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
	massFlowDataCell = [freRaw;massFlowERaw];
	if 0
		%迭代开孔孔径
		rang = [0.004:0.004:0.03];
		theoryChangedp(rang,massFlowDataCell,param,isSaveFigure);
	end
	
	if 1
		%迭代开孔率
		theoryPerforatingRatios(param,isSaveFigure)
	end
	
	
end


function theoryPerforatingRatios(param,isSaveFigure)
	%迭代开孔率
	n = 10:1:72;%孔数变化范围
	dp = 10:5:200;%开孔孔径
	dp = dp ./1000;
	Din = 98/3 : 20 : 98*3;%内插管管径
	Din = Din ./ 1000;
	%内插管入口段非孔管开孔长度
	lp = 50:10:300;
	lp = lp ./ 1000;
	
	figure
	paperFigureSet('fill',10);
	LineStyle = 'none';
	% x:n y:dp
	subplot(3,3,1)
	r1 = calcPerforatingRatios(param.n1,param.dp1,param.Din,param.lp1);
	Zn_dp = NaN(length(dp),length(n));
	for i = 1:length(dp)
		Zn_dp(i,:) = calcPerforatingRatios(n,dp(i),param.Din,param.lp1);
    end
    Zn_dp(Zn_dp>100) = nan;
	[X,Y] = meshgrid(n,dp);
	[c,h]=contourfSmooth(X,Y.*1000,Zn_dp,'LineStyle',LineStyle);
	set(gca,'XTickLabel',{}...
			,'YTick',50:50:200);%linspace(dp(1),dp(end),4)
	gcaHandle{1,1} = gca;
	ylabel('dp(mm)','FontSize',paperFontSize);
	axis tight;
	
	% x:n y:Din
	subplot(3,3,4)
	Zn_Din = NaN(length(Din),length(n));
	for i = 1:length(Din)
		Zn_Din(i,:) = calcPerforatingRatios(n,param.dp1,Din(i),param.lp1);
    end
    Zn_Din(Zn_Din>100) = nan;
	[X,Y] = meshgrid(n,Din);
	[c,h]=contourfSmooth(X,Y.*1000,Zn_Din,'LineStyle',LineStyle);
	set(gca,'XTickLabel',{});
	gcaHandle{2,1} = gca;
	ylabel('Din(mm)','FontSize',paperFontSize);
	axis tight;
	
	% x:dp y:Din
	subplot(3,3,5)
	Zdp_Din = NaN(length(Din),length(dp));
	for i = 1:length(Din)
		Zdp_Din(i,:) = calcPerforatingRatios(param.n1,dp,Din(i),param.lp1);
    end
    Zdp_Din(Zdp_Din>100) = nan;
	[X,Y] = meshgrid(dp,Din);
	[c,h]=contourfSmooth(X.*1000,Y.*1000,Zdp_Din,'LineStyle',LineStyle);
	set(gca,'XTickLabel',{},'YTickLabel',{});
	gcaHandle{2,2} = gca;
	axis tight;
	
	% x:n y:lp
	subplot(3,3,7)
	Zn_lp = NaN(length(lp),length(n));
	for i = 1:length(lp)
		Zn_lp(i,:) = calcPerforatingRatios(n,param.dp1,param.Din,lp(i));
    end
    Zn_lp(Zn_lp>100) = nan;
	[X,Y] = meshgrid(n,lp);
	[c,h]=contourfSmooth(X,Y.*1000,Zn_lp,'LineStyle',LineStyle);
	xlabel('n','FontSize',paperFontSize);
	gcaHandle{3,1} = gca;
    set(gca,'XTickLabelRotation',90 ...
        );
	ylabel('lp(mm)','FontSize',paperFontSize);
	axis tight;
	
	% x:dp y:lp
	subplot(3,3,8)
	Zdp_lp = NaN(length(lp),length(dp));
	for i = 1:length(lp)
		Zdp_lp(i,:) = calcPerforatingRatios(param.n1,dp,param.Din,lp(i));
    end
    Zdp_lp(Zdp_lp>100) = nan;
	[X,Y] = meshgrid(dp,lp);
	[c,h]=contourfSmooth(X.*1000,Y.*1000,Zdp_lp,'LineStyle',LineStyle);
	xlabel('dp(mm)','FontSize',paperFontSize);
	set(gca,'YTickLabel',{}...
        ,'XTickLabelRotation',90 ...
        );
	gcaHandle{3,2} = gca;
	axis tight;
	
	% x:Din y:lp
	subplot(3,3,9)
	ZDin_lp = NaN(length(lp),length(Din));
	for i = 1:length(lp)
		ZDin_lp(i,:) = calcPerforatingRatios(param.n1,param.dp1,Din,lp(i));
    end
    ZDin_lp(ZDin_lp>100) = nan;
	[X,Y] = meshgrid(Din,lp);
	[c,h]=contourfSmooth(X.*1000,Y.*1000,ZDin_lp,'LineStyle',LineStyle);
	set(gca,'YTickLabel',{}...
        ,'XTickLabelRotation',90 ...
    );
	gcaHandle{3,3} = gca;
	xlabel('Din(mm)','FontSize',paperFontSize);
	axis tight;
	
	%%设置位置
	set(gcaHandle{1,1},'Position',[0.13 0.67 0.24 0.25]);
	set(gcaHandle{2,1},'Position',[0.13 0.4 0.24 0.25]);
	set(gcaHandle{2,2},'Position',[0.385 0.4 0.24 0.25]);
	set(gcaHandle{3,1},'Position',[0.13 0.13 0.24 0.25]);
	set(gcaHandle{3,2},'Position',[0.385 0.13 0.24 0.25]);
	set(gcaHandle{3,3},'Position',[0.64 0.13 0.24 0.25]);
    colormap jet;
    if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch06'),'开孔率的影响');
	end	
end

function theoryChangedp(rang,massFlowDataCell,param,isSaveFigure)
	% 迭代开孔孔径
	res = PerforateClosePulsationChangedp(param,rang...
							,'massflowdata',massFlowDataCell,'fast',true...
                            ,'fixFunPtr',@fixTheoryPerforate);
                        
	figure('Name','内插管开孔孔径对气流脉动的影响')
	paperFigureSet('small',6);
	[c,h]=plotResultCell(res,rang.*1000);
	set(h,'LineStyle','none'...
		,'LevelStep',0.2 ...
		);
    set(gca,'Position',[0.149323667948511 0.18 0.644154592921054 0.75]);
    colormap jet;
    hbar = colorbar;
	
	if ~verLessThan('matlab', '8')
		set(get(hbar,'label'),'String','压力脉动峰峰值(kPa)','FontSize',paperFontSize());
    end
	
	set(hbar,'Position',[0.804347826086957 0.18 0.0424309618852597 0.75]);
    
	hold on;
	ax = axis();
	plot([ax(1),ax(2)],[param.dp1,param.dp1].*1000,'--k');
	text(ax(1),param.dp1*1000+1,sprintf('%g mm',param.dp1*1000));

	xlabel('管线距离(m)','FontSize',paperFontSize);
	ylabel('开孔孔径(mm)','FontSize',paperFontSize)
	if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch06'),sprintf('内置孔管D%g-开孔孔径对气流脉动的影响',param.Din));
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


