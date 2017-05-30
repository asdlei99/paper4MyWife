function pp = fun_calcPulsation( p,cutPresent )
%计算脉动
%   cutPresent为截取的信号部分，若为0.9就是信号的后90%部分
if nargin <2
    cutPresent = 0.9;
end

if size(p,2) > 1
    for i=1:size(p,2)
        pp(1,i) = calcPulsation( p(:,i),cutPresent);
    end
else
    pp = calcPulsation( p,cutPresent );
end

end

function pp = calcPulsation( p ,cutPresent)
    outindex = fun_sigma_outlier_detection(p,2.8);
    if ~isempty(outindex)
        p(outindex) = [];
    end
    len = length(p);
    if length(cutPresent) == 1
        cutIndex = round(len*cutPresent);
        p = p(cutIndex:end);
    else
        cutIndex1 = round(len*cutPresent(1));
        cutIndex2 = round(len*cutPresent(2));
        p = p(cutIndex1:cutIndex2);
    end
    outindex = fun_sigma_outlier_detection(p,2.8);
    if ~isempty(outindex)
        p(outindex) = [];
    end
    pp = max(p) - min(p);
end