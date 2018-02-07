function paperPlotTheDoubleVessel(param,isSaveFigure)
%孔管的理论计算
	freRaw = [14,21,28,42,56,70];
	massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
	massFlowDataCell = [freRaw;massFlowERaw];
	if 1
		%变缓冲罐距离L2
		L2 = 0:0.5:5;
		theoryChangeL2(param,L2,massFlowDataCell,isSaveFigure);
	end
	

	if 1
		v1 = 0.05:0.02:0.4;
		v2 = v1;
		theoryChangeV1V2(param,v1,v2,massFlowDataCell,isSaveFigure);
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

function theoryChangeV1V2(param,v1,v2,massFlowDataCell,isSaveFigure)
	[res,X,Y,XDis] = doubleVesselChangV1V2(v1,v2...
								,'param',param...
								,'massflowdata',massFlowDataCell...
								,'zMode','cmpSameV'...
								);
	% %计算单一缓冲罐
	% paramT = param;
	% paramT.L2 = param.L2+param.L3+param.LV2+2*param.l;
	% paramT.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
	% paramT.lv1 = 0.318;
	% paramT.lv2 = 0.318;
	% paramT.Lv = param.LV1;
	% paramT.Dv = param.DV1;
	% vType = 'StraightInStraightOut';
	% singleVesselRes = oneVesselPulsation('param',paramT...
						% ,'vType',vType...
						% ,'fast',true...
						% );
	% svPlus = singleVesselRes{1};
	% svXDis = singleVesselRes{2};
	% % 计算脉动抑制率
	
	% for i=1:length(res)
		% Z = res{i}.Z;
		% dis = res{i}.x;
		% [ clVal,index ] = closeValue(svXDis,dis);
		% sv = svPlus(index);
		% Z = (sv - Z)./sv .* 100;
		% res{i}.Z = Z;
	% end
	% %% 绘制进口测点和末端测点
    [ clVal,index ] = closeValue(XDis,2);
	figure
	paperFigureSet('small',6);
	size(X)
	size(Y)
	size(res{index}.Z)
	[c,h]=contourfSmooth(X,Y,res{index}.Z);
	xlabel('V1(m^3)','FontSize',paperFontSize());
	ylabel('V2(m^3)','FontSize',paperFontSize());
	colormap jet;
	
	figure
	paperFigureSet('small',6);
	size(X)
	size(Y)
	size(res{index}.Z)
	[c,h]=contourfSmooth(X,Y,res{end}.Z);
	xlabel('V1(m^3)','FontSize',paperFontSize());
	ylabel('V2(m^3)','FontSize',paperFontSize());
    colormap jet;
end