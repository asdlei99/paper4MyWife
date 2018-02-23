function paperPlotDoubleVesselThe(param,isSaveFigure)
%孔管的理论计算
	freRaw = [14,21,28,42,56,70];
	massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
	massFlowDataCell = [freRaw;massFlowERaw];
	if 0
		%变缓冲罐距离L2
		L2 = 0:0.5:5;
		theoryChangeL2(param,L2,massFlowDataCell,isSaveFigure);
	end
	

	if 0
		v1 = 0.05:0.02:0.4;
		v2 = v1;
		theoryChangeV1V2CmpSingle(param,v1,v2,massFlowDataCell,isSaveFigure);
    end
	
    if 0
        v = 0.05:0.01:0.4;
        theoryChangeVCmpSingle(param,v,massFlowDataCell,isSaveFigure);
    end
    
    if 1
        v1 = 0.05:0.01:0.4;
        theoryFixVChangeV1V2(param,v1,massFlowDataCell,isSaveFigure);
    end
end

function theoryChangeL2(param,L2,massFlowDataCell,isSaveFigure)
%
    res = doubleVesselChangDistanceToFirstVessel(L2...
                                            ,'param',param...
                                            ,'massflowdata',massFlowDataCell...
											,'fast',true...
											);
	plotInContourf = 1;										
	figure
	paperFigureSet('small',6);
	if plotInContourf
		for i=1:length(res)
			data = res{i};
			y = data.plus;
			x = data.X;
			y(x<2) = nan;
			x(x<2) = nan;
			y = y./1000;
			Z(i,:) = y;
			X(i,:) = x;
			Y(i,:) = ones(1,length(y)) .* data.param.L2;
			xRegion1Start(i) = data.vesselRagion1(1);
			yRegion(i) = data.param.L2;
			xRegion2Start(i) = data.vesselRagion2(1);
		end
		[c,h]=contourfSmooth(X,Y,Z);
		hold on;
		%绘制L2范围
		plot(xRegion1Start,yRegion,'--w');
		plot(xRegion2Start,yRegion,'--w');
		
		xlabel('管线距离(m)','FontSize',paperFontSize());
		ylabel('L2(m)','FontSize',paperFontSize());
		ch = colorbar;
		set(gca,'Position',[0.163 0.1894 0.6739 0.7356]);
		set(ch,'Position',[0.8659 0.185 0.0558 0.7398]);
		box on;
	else
		hold on;
		for i=1:length(res)
			data = res{i};
			y = data.plus;
			x = data.X;
			y(x<2) = nan;
			x(x<2) = nan;
			y = y./1000;
			plot(x,y,'color',getPlotColor(i));
			x
		end
		
		xlabel('距离','FontSize',paperFontSize());
		ylabel('压力脉动(kPa)','FontSize',paperFontSize());
		
		box on;
	end
	if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch07'),'双罐-变L2');
	end	
end


function theoryChangeV1V2CmpSingle(param,v1,v2,massFlowDataCell,isSaveFigure)
%不同体积下变v1，v2
	[res,X,Y,XDis] = doubleVesselChangV1V2(v1,v2...
								,'param',param...
								,'massflowdata',massFlowDataCell...
								,'zMode','cmpSameV'...
								);
	%实验开始测点
    [ clVal,index ] = closeValue(XDis,2);
	figure
	paperFigureSet('small',6);
	size(res{index}.Z)
	[c,h]=contourfSmooth(X,Y,res{index}.Z);
	xlabel('V1(m^3)','FontSize',paperFontSize());
	ylabel('V2(m^3)','FontSize',paperFontSize());
	colormap jet;
	%实验末端测点
	figure
	paperFigureSet('small',6);
	size(res{index}.Z)
	[c,h]=contourfSmooth(X,Y,res{end}.Z);
	xlabel('V1(m^3)','FontSize',paperFontSize());
	ylabel('V2(m^3)','FontSize',paperFontSize());
    colormap jet;
    
end

function theoryChangeVCmpSingle(param,v,massFlowDataCell,isSaveFigure)
%同等体积下和单罐的比较
    theRes = doubleVesselChangV(v,'param',param,'massflowdata',massFlowDataCell);
    X = [];
    for i=1:length(theRes)
       X = union(X,theRes{i}.doubleVesselX);
    end
    X = X';
    for i=1:length(theRes)
        res = theRes{i};
        yy = ones(1,length(X));
        yy = yy .* v(i);
        ZZ(:,i) = interp1(res.doubleVesselX,res.pr,X);
        XX(:,i) = X;
        YY(:,i) = yy;
    end

    figHandle = figure; 
    paperFigureSet('small',6);
    contourfSmooth(XX,YY,ZZ);
    set(gca,'Position',[0.203671492449071 0.18 0.64675658974271 0.746]);
    xlabel('管线距离(m)','FontSize',paperFontSize());
    ylabel('体积(m^3)','FontSize',paperFontSize());
    colormap jet;
    cbh = colorbar();
    set(cbh,'Position',[0.861301369863015 0.18 0.045832850558751 0.746]);
    if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch07'),'双罐在不同体积下和等体积单罐的脉动抑制率对比');
		close(figHandle);
    end

    h = [];
    figHandle = figure;   
    paperFigureSet('small',6);
    h(1) = plot(v,ZZ(1,:),'-','color',getPlotColor(1));
    hold on;
    h(2) = plot(v,ZZ(960,:),'--','color',getPlotColor(2));
    xlabel('体积(m^3)','FontSize',paperFontSize());
    ylabel('脉动抑制率(%)','FontSize',paperFontSize());
    legend(h,{'管系进口端','管系末端'},'FontSize',paperFontSize()...
        ,'Location','southeast');
    
    if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch07'),'双罐在不同体积下和等体积单罐的特殊测点脉动抑制率对比');
		close(figHandle);
    end
end

function theoryFixVChangeV1V2(param,v1,massFlowDataCell,isSaveFigure)
%双罐两罐总体积相等情况下改变v1和v2的体积分配
    theRes = doubleVesselFixVChangeV1V2(v1,'param',param,'massflowdata',massFlowDataCell);
    for i = 1:length(theRes)
        X(i,:) = theRes{1}.xDisL1L3;
        Y(i,:) = ones(1,length(theRes{i}.sr)) .* v1(i);
        Z(i,:) = theRes{i}.sr;
    end
    figHandle = figure; 
    paperFigureSet('small',6);
    contourfSmooth(X,Y,Z);
end












