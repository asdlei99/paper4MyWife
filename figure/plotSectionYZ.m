function fh = plotSectionYZ( x,y,z,xval,varargin )
%在三维图上绘制切面xz，也就是定y值
markSection = 'all';
markSectionLabel = {};
color = [0,0,1];
markColor = [0,0,0];
pp = varargin;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'marksection'
            markSection = val;
        case 'marksectionlabel'
            markSectionLabel = val;
        case 'color'
            color = val;
        case 'markcolor'
            markColor = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
for i = 1:length(xval)
    val = xval(i);
    [val,index] = closeValue(x(1,:),val);
    if isnan(val)
        continue;
    end
    ax = axis();
    xf = ones(1,5).*val;
    yf = [ax(3),ax(4),ax(4),ax(3),ax(3)];
    zf = [ax(5),ax(5),ax(6),ax(6),ax(5)];
    fh.sectionYHandle(i) = fill3(xf,yf,zf,color);
    set(fh.sectionYHandle(i),'FaceAlpha',0.1);
    set(fh.sectionYHandle(i),'EdgeColor',color,'EdgeAlpha',0.6);
    xl = x(:,index);
    yl = y(:,index);
    zl = z(:,index);
    if strcmp(markSection,'all')
        fh.markPlotHandle = plot3(xl,yl,zl,'color',markColor);
    end
    if length(markSectionLabel) >= i
        text(val,ax(3),ax(6),markSectionLabel{i});
        text(val,ax(4),ax(6),markSectionLabel{i});
    end
end
end

