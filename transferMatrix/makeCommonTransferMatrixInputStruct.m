function st = makeCommonTransferMatrixInputStruct()
%产生一个通用输入结构体
st.isDamping = 1;%是否计算阻尼
st.coeffDamping = nan;%阻尼系数
st.coeffFriction = 0.03;%管道摩擦系数
st.meanFlowVelocity = 14.5;%流速
st.k = nan;%波数
st.oumiga = nan;%圆频率
st.a = 345;%声速
st.isOpening = 0;%边界条件是否为开口
st.notMach = 1;%是否马赫
st.mach = 14.5/345;%马赫数
end

