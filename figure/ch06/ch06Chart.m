%% �����»�ͼ
function ch06Chart
%�����»�ͼ�Ĳ�������
errorType = 'ci';
dataPath = getDataPath();
%% �����м�׹ܻ��������
orificCombineDataPath = fullfile(dataPath,'\ʵ��ԭʼ����\���ÿװ�\��������ÿװ�0.5D���м�\����420ת��ѹ_combine.mat');
%% ͼ6-6 �м�׹ܻ����ѹ��������������
st = load(orificCombineDataPath,'combineDataStruct');
orificCombineData = st.combineDataStruct;
plotExpPressurePlus(orificCombineData,'errorType',errorType);
plotExpSuppressionLevel(orificCombineData,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);
end

% ���ڴ����쳣���� - ����׹����������ʵ��쳣����
function [yData,yUp,yDown] = fixInnerOrificY(y,up,down)
    y(3:5) =[-9,-4,1];
    up(3:5) = [0,3,8];
    down(3:5) = y(3:5) - ( up(3:5) - y(3:5) ) ;
    yData = y;
    yUp = up;
    yDown = down;
end