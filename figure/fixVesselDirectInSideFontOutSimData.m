function [simPulsData,x] = fixVesselDirectInSideFontOutSimData( simVal )
%修正直进侧前出的模拟数据
xSim = [[0.5,1,1.5,2,2.5,2.85,3],[5.1,5.6,6.1,6.6,7.1,7.6,8.1,8.6,9.1,9.6,10.1,10.6]];
simVal(xSim < 2.5) = nan;
simVal(xSim>=2.5 & xSim < 3.5) = simVal(xSim>=2.5 & xSim < 3.5) + 4.9;
simVal(8) = simVal(8) -2.3;
simVal(xSim>=5.1 & xSim < 6) = simVal(xSim>=5.1 & xSim < 6) + 5.97;
simVal(xSim>=6) = simVal(xSim>=6) + 10.97;
simPulsData = simVal;
x = xSim;
end

