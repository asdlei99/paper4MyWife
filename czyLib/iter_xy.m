function [z,h] = iter_xy(x,y,funXY,varargin)
	% ����x,y
	% �����Ľ������z
	% x ����x
	% y ����y
	% funXY �������
	% isshowfig = �Ƿ���ʾ����������ͼ��
    % plotType = s-surf sc-surfc c-contour cf-contourf c3-contour3
	isShowFig = 1;
	pp=varargin;
    h = nan;
    z = nan;
    plotType = 's';
	while length(pp)>=2
	    prop =pp{1};
	    val=pp{2};
	    pp=pp(3:end);
	    switch lower(prop)
	        case 'isshowfig' %�Ƿ���ʾ����������ͼ��
	            isShowFig = val;
            case 'plottype'
                plotType = val;
            otherwise
                error('unknow input property %s',prop); 
	    end
	end
	for ii = 1:length(y)
		for jj = 1:length(x)
			z(ii,jj) = funXY(x(jj),y(ii));
		end
	end
	if isShowFig
		h = plotXYZ(x,y,z,plotType);
	end
end

function h = plotXYZ(x,y,z,plotType)
	[x,y] = meshgrid(x,y);
    if strcmpi(plotType,'s')
        h = surf(x,y,z);
    elseif strcmpi(plotType,'sc')
        h = surfc(x,y,z);
    elseif strcmpi(plotType,'c')
        [~,h] = contour(x,y,z);
    elseif strcmpi(plotType,'c3')
        [~,h] = contour3(x,y,z);
    elseif strcmpi(plotType,'cf')
        [~,h] = contourf(x,y,z);
    else
        h = [];
    end
end