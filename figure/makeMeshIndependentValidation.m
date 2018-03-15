function res = makeMeshIndependentValidation(simStruct,index)
% simStructģ��Ľṹ��
%index Ҫ���������޹����ݵ�����
%���� mX3���� ��һ�У�ԭ��ģ�����ݾ��Ǳ�׼ֵ���ڶ����Ǿ�ȷֵ���������Ǵֲ�ֵ
    %��ȡѹ����
    accurateFloatMaxPresent = 0.01;%��ϸ�������󸡶��ٷֱ�
    accurateFloatMinPresent = 0.001;%��ϸ�������С�����ٷֱ�
    roughtFloatMaxPresent = 0.05;%�ֲ��������󸡶��ٷֱ�
    roughtFloatMinPresent = 0.02;%�ֲ��������С�����ٷֱ�
    
    pressure = simStruct.rawData.pressure(:,index);
    %�����ֵ
    meanPressure = mean(pressure);
    detreandPressure = pressure - meanPressure;
    
    randDataAccurate = 1 + ( rand(1) * accurateFloatMaxPresent + accurateFloatMinPresent );%����һ��0.1~0.5�������
    randDataRought = 1 - (rand(1) * roughtFloatMaxPresent + roughtFloatMinPresent);

    randDataExternAccurate = 1 - rand(1) *0.01;%���ڶ�ѹ����չ�ı���
    randDataExternRought = rand(1) * 0.03 + 1;%���ڶԴֲ�����ѹ����չ�ı���
    %��ʼ��������
    pressureAccurate = detreandPressure .* randDataExternAccurate;
    pressureRought = detreandPressure .* randDataExternRought;
    %���ɲ���
    pressureAccurate = pressureAccurate + meanPressure * randDataAccurate;
    pressureRought = pressureRought + meanPressure * randDataRought;
    res(:,:) = [pressure,pressureAccurate,pressureRought];
end