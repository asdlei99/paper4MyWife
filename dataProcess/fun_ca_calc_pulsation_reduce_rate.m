function [rate,pdr] = fun_ca_calc_pulsation_reduce_rate( y,seprateIndex_before,seprateIndex_after )
%�������������ʣ�
%   rate �����������������ָ����seprateIndex��ߵ����ݵ����ֵ��Ϊ��ĸ��seprateIndex���ұߵ����ֵ��Ϊ���ӣ�����֮��
%   pdr ��������˥�������Ͻ���ʿ����Һѹϵͳ����˥���������Է�����35ҳ
%  y ����
%  seprateIndex �ֽ��
temp = y(1:seprateIndex_before);
a1 = max(temp);
temp = y(seprateIndex_after:end);
a2 = max(temp);

rate = (a1-a2)/a1;
pdr = 20 .* log10(a1./a2);
end

