function newCell = cellPush2Right( originCell,varargin)
%��bePushCell�ŵ�originCell���ұ�
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
newCell = cellPush2Right_1dim(originCell,varargin{1});
for i=2:length(varargin)
	newCell = cellPush2Right_1dim(newCell,varargin{i});
end

end

function newCell = cellPush2Right_1dim( originCell,bePushCell)

	startRow = 1;

	newCell = originCell;
	startColumn = size(newCell,2)+1;
	for r = 1:size(bePushCell,1)
		newColumn = startColumn;
		for c = 1:size(bePushCell,2)
			newCell{startRow + r - 1,newColumn} = bePushCell{r,c};
			newColumn = newColumn + 1;
		end
end
end