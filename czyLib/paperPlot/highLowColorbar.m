function h = highLowColorbar(labels)
%只显示高低的colorbar
%   labels是高低对应的label为一个2X1cells

if 0 == nargin
    labels = {'低','高'};
end
h = colorbar;
tc = get(h,'Ticks');
newTc = [tc(1),tc(end)];
set(h,'Ticks',newTc);
set(h,'TickLabels',labels);
end

