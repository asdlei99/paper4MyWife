function [ C,H ] = contourfSmooth( X,Y,Z,varargin)
%����һ������ƽ����ͼ�ĺ�����ƽ����ͼ��contourf��ͬ��contourf���levelStep�Ƚ��٣����Ƴ�����ɫ��Ҳ�Ƚ��٣�
%   �˺���levelStep�ķֶθ���Ĭ��Ϊ100�ϣ�Ȼ����ٵ���contour��contour�ķֶ�Ϊ15���������Ƴ�����ͼ���Ÿ����
pp = varargin;
varargin = {};
nSmoothStep = 100;
nTextStep = 15;
LineStyle = '-';
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'nsmoothstep' %����������
        	nSmoothStep = val;
        case 'ntextstep'
            nTextStep = val;
        case 'linestyle'
            LineStyle = val;
        otherwise
       		varargin{length(varargin)+1} = prop;
            varargin{length(varargin)+1} = val;
    end
end
%����levelStep
maxZ = max(max(Z));
minZ = min(min(Z));
levelSmoothStep = (maxZ-minZ) / nSmoothStep;
levelTextStep = (maxZ-minZ) / nTextStep;
[C{1},H{1}]=contourf(X,Y,Z,'LevelStep',levelSmoothStep...
    ,'LineStyle','none'...
    );
hold on;
[C{2},H{2}]=contour(X,Y,Z,'LevelStep',levelTextStep...
	,'ShowText','on'...
    ,'LineStyle',LineStyle...
    ,'LineColor','k'...
    ,varargin{:}...
	);
end

