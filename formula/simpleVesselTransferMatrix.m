% 化简矩阵，迭代Dv变体积
function simpleVesselTransferMatrix(mod)
    dispM = [1,0,0,0];
    
    if strcmpi(mod,'Dv')%变dv（变体积）
        simpleVesselTransferMatSymbolDv(dispM);
    elseif strcmpi(mod,'ldr')%变长径比
        simpleVesselTransferMatSymbolLDR(dispM);
    elseif strcmpi(mod,'calc')%计算压力的化简公式
        calcSymbol();
    elseif strcmpi(mod,'ldrlv1')%变长径比和偏置距离
        simpleVesselTransferMatSymbolLDRAndLv1(dispM);
    elseif strcmpi(mod,'lv1')%变偏置距离
        simpleVesselTransferMatSymbolLv1(dispM);
    end
end

function simpleVesselTransferMatSymbolDv(dispM)
%化简缓冲罐传递矩阵，变体积保留Dv
    syms Dv f
    res = vesselTransferMatrix(1.1,0.01,'f',f,'a',345,'D',0.098,'Dv',Dv ...
            ,'isDamping',1,'coeffFriction',0.03,'meanFlowVelocity',13 ...
            ,'isUseStaightPipe',1,'notmach',0);
    A = res(1,1);
    B = res(1,2);
    C = res(2,1);
    D = res(2,2);

    

    if dispM(1)
        disp('A:');
        A = simplify(A);
        pretty(A);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(A);
    end

    if dispM(2)
        disp('B:');
        B = simplify(B);
        pretty(B);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(B);
    end

    if dispM(3)
        disp('C:');
        C = simplify(C);
        pretty(C);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(C);
    end

    if dispM(4)
        disp('D:');
        D = simplify(D);
        pretty(D);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(D);
    end
end

function simpleVesselTransferMatSymbolLDR(dispM)
%变长径比
    syms f r;
    syms Dv Lv;
    V = 0.1196;
    Dv = ((4*V)/(pi*r))^(1/3);
    Lv = (4*V*r^2 / pi)^(1/3);
    res = vesselTransferMatrix(Lv,0.01,'f',f,'a',345,'D',0.098,'Dv',Dv ...
            ,'isDamping',1,'coeffFriction',0.03,'meanFlowVelocity',13 ...
            ,'isUseStaightPipe',1,'notmach',0);
    A = res(1,1);
    B = res(1,2);
    C = res(2,1);
    D = res(2,2);

    
    if dispM(1)
        disp('A:');
        A = simplify(A);
        pretty(A);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(A);
    end

    if dispM(2)
        disp('B:');
        B = simplify(B);
        pretty(B);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(B);
    end

    if dispM(3)
        disp('C:');
        C = simplify(C);
        pretty(C);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(C);
    end

    if dispM(4)
        disp('D:');
        D = simplify(D);
        pretty(D);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(D);
    end
    
    
end

function calcSymbol()
    syms M1 M3 cm11 cm12 cm13 cm14 cm31 cm32 cm33 cm34;
    syms massFlowE;
    syms AA BB CC DD;
    M1 = [cm11 cm12
        cm13 cm14];
    M2 = [AA BB
        CC DD];
    M3 = [cm31 cm32
        cm33 cm34];
    calcRes = M1 * M2 * M3;
    A = calcRes(1,1);
    B = calcRes(1,2);
    C = calcRes(2,1);
    D = calcRes(2,2);
    pressureE = ((-D/C)*massFlowE);
    
    pressureE = simplify(pressureE);
    pretty(pressureE);
    cute(pressureE);
end

function simpleVesselTransferMatSymbolLDRAndLv1(dispM)
%变长径比和Lv1的
    syms f r;
    syms Dv Lv lBias;
    V = 0.1196;
    Dv = ((4*V)/(pi*r))^(1/3);
    Lv = (4*V*r^2 / pi)^(1/3);
    res = vesselStraightFrontBiasTransferMatrix(Lv,0.01,lBias,0,'f',f,'a',345,'D',0.098,'Dv',Dv ...
            ,'isDamping',1,'coeffFriction',0.03,'meanFlowVelocity',13 ...
            ,'isUseStaightPipe',1,'notmach',0);
    A = res(1,1);
    B = res(1,2);
    C = res(2,1);
    D = res(2,2);
    
    if dispM(1)
        disp('A:');
        A = simplify(A);
        pretty(A);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(A);
    end

    if dispM(2)
        disp('B:');
        B = simplify(B);
        pretty(B);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(B);
    end

    if dispM(3)
        disp('C:');
        C = simplify(C);
        pretty(C);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(C);
    end

    if dispM(4)
        disp('D:');
        D = simplify(D);
        pretty(D);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(D);
    end
end

function simpleVesselTransferMatSymbolLv1(dispM)
%变Lv1的
    syms f;
    syms lBias;
    V = 0.1196;
    res = vesselStraightFrontBiasTransferMatrix(1.1,0.01,lBias,0,'f',f,'a',345,'D',0.098,'Dv',0.372 ...
            ,'isDamping',1,'coeffFriction',0.03,'meanFlowVelocity',13 ...
            ,'isUseStaightPipe',1,'notmach',0);
    A = res(1,1);
    B = res(1,2);
    C = res(2,1);
    D = res(2,2);
    
    if dispM(1)
        disp('A:');
        A = simplify(A);
        pretty(A);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(A);
    end

    if dispM(2)
        disp('B:');
        B = simplify(B);
        pretty(B);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(B);
    end

    if dispM(3)
        disp('C:');
        C = simplify(C);
        pretty(C);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(C);
    end

    if dispM(4)
        disp('D:');
        D = simplify(D);
        pretty(D);
        % latex_expression = latex (sym (A));
        % latex_expression = strrep (latex_expression,'\!', '');
        cute(D);
    end
end