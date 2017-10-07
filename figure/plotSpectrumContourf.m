function fh = plotSpectrumContourf( mags,fres,y,varargin)
%绘制频谱
%   此处显示详细说明
    %LineStyle = 'none';
    pp = varargin;
    isShowColorbar = 1;
    input_args = {};
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'colorbar'
                isShowColorbar = val;
            case 'isshowcolorbar'
                isShowColorbar = val;%云图时是否显示色棒
            otherwise%参数透传
           		input_args{length(input_args)+1} = prop;
                input_args{length(input_args)+1} = val;   
        end
    end

    if size(mags) ~= size(fres)
        if size(fres,1) == 1
            fresTmp = fres;
            for i = 2:size(mags,1)
                fres(i,:) = fresTmp;
            end
        else
            error('mags和fres的维度需要一致，或者fres是（1Xn）向量');
        end
    end
    if size(mags) ~= size(y)
        if size(mags,1) ~= length(y)
            error('y的长度和size(mags,1)需要一致');
        end
        yTmp = y;
        y = ones(size(mags));
        for i = 1:size(mags,2)
            y(:,i) = yTmp;
        end
    end
    [~,fh.contourfHandle] = contourf(fres,y,mags,input_args{:});
    if isShowColorbar
        fh.colorBar = colorbar;
    end
end

