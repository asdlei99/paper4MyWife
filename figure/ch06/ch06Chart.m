%% �����»�ͼ
errorType = 'std';
dataPath = getDataPath();
%% �����м�׹ܻ��������
orificCombineDataPath = fullfile(dataPath,'\ʵ��ԭʼ����\���ÿװ�\��������ÿװ�0.5D���м�\����420ת��ѹ_combine.mat');
%% ͼ6-6 �м�׹ܻ����ѹ��������������
st = load(orificCombineDataPath,'combineDataStruct');
orificCombineData = st.combineDataStruct;
plotExpOrificPressurePlus(orificCombineData,'errorType',errorType);
plotyy