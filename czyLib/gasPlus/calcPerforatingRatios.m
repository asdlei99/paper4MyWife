function data = calcPerforatingRatios(n,dp,Din,lp)
% ���㿪����
% n ����
% dp �׹�ÿһ���׿׾�
% Din �׹ܹܾ�
% lp �׹ܿ��׳���
data = (n.*(dp).^2)./(4.*Din.*lp);%������
end