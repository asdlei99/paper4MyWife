function st = makeCommonTransferMatrixInputStruct()
%����һ��ͨ������ṹ��
st.isDamping = 1;%�Ƿ��������
st.coeffDamping = nan;%����ϵ��
st.coeffFriction = 0.03;%�ܵ�Ħ��ϵ��
st.meanFlowVelocity = 14.5;%����
st.k = nan;%����
st.oumiga = nan;%ԲƵ��
st.a = 345;%����
st.isOpening = 0;%�߽������Ƿ�Ϊ����
st.notMach = 1;%�Ƿ����
st.mach = 14.5/345;%�����
end

