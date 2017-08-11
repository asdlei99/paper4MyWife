function h = highLowColorbar(labels)
%ֻ��ʾ�ߵ͵�colorbar
%   labels�ǸߵͶ�Ӧ��labelΪһ��2X1cells

if 0 == nargin
    labels = {'��','��'};
end
h = colorbar;
tc = get(h,'Ticks');
newTc = [tc(1),tc(end)];
set(h,'Ticks',newTc);
set(h,'TickLabels',labels);
end

