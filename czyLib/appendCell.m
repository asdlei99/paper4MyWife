function res = appendCell(orgCell,varargin)
%  ��cell����������ݣ�����׷��
	orgIndex = length(orgCell);
    newLength = length(varargin);
	res = orgCell;
    for ii = 1:newLength
        res{ii+orgIndex} = varargin{ii};
    end
end