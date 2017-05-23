function detrendData = polyfitDetrend( data,n,varargin)
%使用多项式拟合进行去趋势
%   data 数据
%   n 多项式的阶次
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
            case 'basepositionindex' %去趋势拟合的基准位置
                basePositionIndex=val;
            case 'pos' %去趋势拟合的基准位置
                basePositionIndex=val;
            case 'val' %去趋势拟合的值，如果
                baseValue=val;
            case 'basevalue' %去趋势拟合的值，如果设置了，忽略basePositionIndex
                baseValue=val;
            otherwise
                error('参数输入错误！参数“%s”不适用',prop);
        end
    end
end


x = 1:length(data);
if size(data,2) == 1%防止data是n*1，x生成1*n情况
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

