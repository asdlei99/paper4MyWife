function [ C,H ] = contourfSmooth( X,Y,Z,varargin)
%这是一个绘制平滑云图的函数，平滑云图和contourf不同，contourf如果levelStep比较少，绘制出来的色块也比较少，
%   此函数levelStep的分段个数默认为100断，然后会再叠加contour，contour的分段为15段这样绘制出来的图看着更舒服
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
        case 'nsmoothstep' %误差带的类型
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
%计算levelStep
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

