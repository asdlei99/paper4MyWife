function fh = plotSpectrumContourf( mags,fres,y,varargin)
%����Ƶ��
%   �˴���ʾ��ϸ˵��
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
                isShowColorbar = val;%��ͼʱ�Ƿ���ʾɫ��
            otherwise%����͸��
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
            error('mags��fres��ά����Ҫһ�£�����fres�ǣ�1Xn������');
        end
    end
    if size(mags) ~= size(y)
        if size(mags,1) ~= length(y)
            error('y�ĳ��Ⱥ�size(mags,1)��Ҫһ��');
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

