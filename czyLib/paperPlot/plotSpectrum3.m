function [ h,fillH ] = plotSpectrum3( fre,mag,Y,varargin )
%����Ƶ��ͼ��Ƶ��ͼ���������
%   fre Ƶ��
%   mag ��ֵ
%   Y �����ο�ϵ
%   lineColor ������ɫ
%   isFill �Ƿ�������
%   otherSetting �������ã�
% otherSetting.isMarkTop
% �Ƿ��Ƿ�ֵ���ڴ�����Ϊtrue������£�Ƶ�׵ķ�ֵ�ᱻ��ǣ�ͬʱotherSetting.markCount����Ч
% otherSetting.markCount ��Ƿ�ֵ�ĸ���
pp=varargin;
lineColor = [255,0,0]./255;
isFill = 0;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch prop
        case 'color'
            lineColor=val;
        case 'isFill'
            isFill=val;
        otherwise
            error('�����������')
    end
end



if length(Y) == 1
    Y = ones(length(fre),1) .* Y;
end

h = plot3(fre,Y,mag);
set(h,'color',lineColor);

if isFill
    hold on;
    fillH = fill3([0;fre;fre(end);0],[Y(1);Y;Y(1);Y(1)],[0;mag;0;0],lineColor);
    set(fillH,'edgealpha',0);
    set(fillH,'FaceAlpha',0.4);
else
    fillH = [];
end


end

