function res = appendCell(orgCell,varargin)
%  在cell后面最近内容，以列追加
	orgIndex = length(orgCell);
    newLength = length(varargin);
	res = orgCell;
    for ii = 1:newLength
        res{ii+orgIndex} = varargin{ii};
    end
end