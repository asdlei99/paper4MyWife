L = 10;
Dpipe = 0.106;
a = 345;
isDamping = 1;
coeffFriction = 0.01;
meanFlowVelocity = 14.5;
mach = meanFlowVelocity / a;
notMach = 0;
calcWay2 = 0;
density = 1.293;
dynViscosity = nan;


matrix_straigh = straightPipeTransferMatrixFreSymbol(L,'frequency','a',a,'D',Dpipe...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'m',mach,'notmach',notMach...
        ,'calcWay2',calcWay2,'density',density,'dynViscosity',dynViscosity);
matrix_straigh = matrix_straigh * [1;0];
syms frequency
A = matrix_straigh(1);
B = matrix_straigh(2);
equ = A == 1;
ans = solve(equ,frequency);
eval(ans)

equ = B == 0;
ans = solve(equ,frequency);
eval(ans)




