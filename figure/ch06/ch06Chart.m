%% �����»�ͼ
function ch06Chart
%�����»�ͼ�Ĳ�������
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% �����м�׹ܻ��������
orificD0_5CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D0.5RPM420���м�');

%% ͼ6-6 �м�׹ܻ����ѹ��������������
[~,orificCombineData] = loadExpDataFromFolder(orificCombineDataPath);
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