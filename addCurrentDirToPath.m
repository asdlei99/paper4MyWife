function addCurrentDirToPath(currentPath)
%���ļ���ӵ�ϵͳ·��
	if 0 == nargin
		currentPath = fileparts(mfilename('fullpath'));
	end
	allpaths = genpath(currentPath);
	allpaths = regexp(allpaths,';','split');
	for i=1:length(allpaths)
		p = allpaths{i};
		if isempty(strfind(p,'.git'))
			addpath(p);
		else
			disp(sprintf('ignore %s',p));
		end
	end
end