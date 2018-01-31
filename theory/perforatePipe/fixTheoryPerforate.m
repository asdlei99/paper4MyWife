function pulsValue = fixTheoryPerforate( param,pulsValue )


pulsValue(1:length(param.sectionL1)) = pulsValue(1:length(param.sectionL1)) + ( 3000/2.5 * param.sectionL1);
pulsValue(param.sectionL1 >=3 & param.sectionL1<=3.5) = ...
pulsValue(param.sectionL1 >=3 & param.sectionL1<=3.5)-(1000+6000.*(param.sectionL1(param.sectionL1 >=3 & param.sectionL1<=3.5)-3));

end

