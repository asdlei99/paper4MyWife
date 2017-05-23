function [xb,yb]=DrawBoundary(x,y,z)% 画边界多边形
        xb=[];yb=[]; % 边界多边形拐角点

        figure('NumberTitle','off','Name','请画出边界多边形','Color','White')
        title('请{\color{red}逆时针}画出边界多边形的拐角点(左键画点,右键取消),画完后关闭界面')
%         set(gcf,'Pointer','cross') % 十字鼠标指针
        hold on
        
        if nargin == 3
            scatter(x,y,2,z,'s','filled')% 数据散点图
        else
            plot(x,y,'.r');
        end
        drawnow
        hb=plot(nan,nan,'+-k','LineWidth',1,'MarkerSize',5);% 边界线
        pbaspect([1.25 1 1]);
        daspect([1 1 1]);
        axis manual off
        xylim=axis;
        
        set(gcf,'WindowButtonUpFcn',@wbuf)
        function wbuf(src,cbd)
            switch get(gcf,'SelectionType')
                case 'normal'% 左键,添加当前点(要逆时针画)
                    cp=get(gca,'CurrentPoint');
                    xb(end+1)=cp(1);
                    yb(end+1)=cp(3);
                case 'alt'% 右键,删除最后一个点
                    if ~isempty(xb)
                        xb(end)=[];yb(end)=[];
                    end
            end
            % 多边形(不必把最后一个点和第一个点重合起来)
            set(hb,'XData',xb,'YData',yb)
        end
        
%         set(gcf,'WindowButtonMotionFcn',@wbmf)
%         function wbmf(src,cbd) % 动态画点
%             cp=get(gca,'CurrentPoint');
%             set(hb,'XData',[xb,cp(1)],'YData',[yb,cp(3)])
%         end
        
        set(gcf,'WindowScrollWheelFcn',@wswf)
        function wswf(src,cbd)% 用鼠标滚轮缩放局部图像
            cp=get(gca,'CurrentPoint');
            if cbd.VerticalScrollCount > 0
                axis(xylim) % 恢复初始大小/范围
            elseif cbd.VerticalScrollCount < 0 % 放大图像(缩小范围)
               axis(0.85*(axis-cp([1,1,3,3]))+cp([1,1,3,3]))
            end
        end

        waitfor(gcf)% 等待关闭界面,之后继续执行
        if numel(xb)>=3% 至少三个点
            xb=xb([1:end,1]);yb=yb([1:end,1]); % 闭合边界
            fprintf('边界点:\n');disp([xb(:),yb(:)]);% 显示边界点
        else
            xb=[];yb=[];
            warndlg('至少3个点!')
        end
    end
