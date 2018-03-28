function  fixSmallFigurePosition( fh )
%修正小图的位置
 ax = axis();
 set(gca,'Position',[0.18 0.179016148252809 0.78 0.649213018413858]);
 ylim([ax(3:4)]);
 xlim([ax(1:2)]);
 if nargin > 0
     if isfield(fh,'legend')
        set(fh.legend,'Location','northwest');
     end
     if isfield(fh,'textarrowVessel')
         delete(fh.textarrowVessel) % 删除曲线
     end
     if isfield(fh,'textboxMeasurePoint')
         set(fh.textboxMeasurePoint,'Position',[0.498115942028986 0.915837004405289 0.201159420289855 0.0911999999999996]);
     end
 end

end

