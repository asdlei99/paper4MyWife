function newCell = cellPush2Bottom( originCell,varargin)
%��bePushCell�ŵ�originCell���±�
% A = 
%     [1]    [2]    [3]    [4]
%     [5]    [6]    [7]    [8]
% B = 
%     [1]    [5]
%     [2]    [6]
%     [3]    [7]
%     [4]    [8]
% C = cellPush2Bottom(A,B)
% 
% C = 
%     [1]    [2]    [3]    [4]
%     [5]    [6]    [7]    [8]
%     [1]    [5]     []     []
%     [2]    [6]     []     []
%     [3]    [7]     []     []
%     [4]    [8]     []     []
% 
% C = cellPush2Right(A,B)
% 
% C = 
%     [1]    [2]    [3]    [4]    [1]    [5]
%     [5]    [6]    [7]    [8]    [2]    [6]
%      []     []     []     []    [3]    [7]
%      []     []     []     []    [4]    [8]
%   originCellԭʼcell
%   bePushCell Ҫ��ӽ�originCell�ұߵ���cell


newCell = cellPush2Bottom_1dim(originCell,varargin{1});
for i=2:length(varargin)
	newCell = cellPush2Bottom_1dim(newCell,varargin{i});
end

end

function newCell = cellPush2Bottom_1dim( originCell,bePushCell)

	startColumn = 1;

	newCell = originCell;
	startRow = size(newCell,1)+1;

	for c = 1:size(bePushCell,2)
		newRow = startRow;
		for r = 1:size(bePushCell,1)
			newCell{newRow,startColumn+c-1} = bePushCell{r,c};
			newRow = newRow + 1;
		end
	end
end