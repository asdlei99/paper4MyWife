function detrendData = polyfitDetrend( data,n,varargin)
%ʹ�ö���ʽ��Ͻ���ȥ����
%   data ����
%   n ����ʽ�Ľ״�
pp=varargin;
basePositionIndex = 1;
baseValue = nan;
if length(pp) == 1
    if strcmp(pp{1},'start')
        basePositionIndex=1;
    end
    if strcmp(pp{1},'end')
        basePositionIndex=length(data);
    end
else
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'basepositionindex' %ȥ������ϵĻ�׼λ��
                basePositionIndex=val;
            case 'pos' %ȥ������ϵĻ�׼λ��
                basePositionIndex=val;
            case 'val' %ȥ������ϵ�ֵ�����
                baseValue=val;
            case 'basevalue' %ȥ������ϵ�ֵ����������ˣ�����basePositionIndex
                baseValue=val;
            otherwise
                error('����������󣡲�����%s��������',prop);
        end
    end
end


x = 1:length(data);
if size(data,2) == 1%��ֹdata��n*1��x����1*n���
    x = x';
end
p = polyfit(x,data,n);
yy = polyval(p,x);
if ~isnan(baseValue)
    yy = yy - baseValue;
else
    yy = yy - yy(basePositionIndex);
end
detrendData = data - yy;
end

