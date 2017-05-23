function [xb,yb]=DrawBoundary(x,y,z)% ���߽�����
        xb=[];yb=[]; % �߽����ιսǵ�

        figure('NumberTitle','off','Name','�뻭���߽�����','Color','White')
        title('��{\color{red}��ʱ��}�����߽����εĹսǵ�(�������,�Ҽ�ȡ��),�����رս���')
%         set(gcf,'Pointer','cross') % ʮ�����ָ��
        hold on
        
        if nargin == 3
            scatter(x,y,2,z,'s','filled')% ����ɢ��ͼ
        else
            plot(x,y,'.r');
        end
        drawnow
        hb=plot(nan,nan,'+-k','LineWidth',1,'MarkerSize',5);% �߽���
        pbaspect([1.25 1 1]);
        daspect([1 1 1]);
        axis manual off
        xylim=axis;
        
        set(gcf,'WindowButtonUpFcn',@wbuf)
        function wbuf(src,cbd)
            switch get(gcf,'SelectionType')
                case 'normal'% ���,��ӵ�ǰ��(Ҫ��ʱ�뻭)
                    cp=get(gca,'CurrentPoint');
                    xb(end+1)=cp(1);
                    yb(end+1)=cp(3);
                case 'alt'% �Ҽ�,ɾ�����һ����
                    if ~isempty(xb)
                        xb(end)=[];yb(end)=[];
                    end
            end
            % �����(���ذ����һ����͵�һ�����غ�����)
            set(hb,'XData',xb,'YData',yb)
        end
        
%         set(gcf,'WindowButtonMotionFcn',@wbmf)
%         function wbmf(src,cbd) % ��̬����
%             cp=get(gca,'CurrentPoint');
%             set(hb,'XData',[xb,cp(1)],'YData',[yb,cp(3)])
%         end
        
        set(gcf,'WindowScrollWheelFcn',@wswf)
        function wswf(src,cbd)% �����������žֲ�ͼ��
            cp=get(gca,'CurrentPoint');
            if cbd.VerticalScrollCount > 0
                axis(xylim) % �ָ���ʼ��С/��Χ
            elseif cbd.VerticalScrollCount < 0 % �Ŵ�ͼ��(��С��Χ)
               axis(0.85*(axis-cp([1,1,3,3]))+cp([1,1,3,3]))
            end
        end

        waitfor(gcf)% �ȴ��رս���,֮�����ִ��
        if numel(xb)>=3% ����������
            xb=xb([1:end,1]);yb=yb([1:end,1]); % �պϱ߽�
            fprintf('�߽��:\n');disp([xb(:),yb(:)]);% ��ʾ�߽��
        else
            xb=[];yb=[];
            warndlg('����3����!')
        end
    end
