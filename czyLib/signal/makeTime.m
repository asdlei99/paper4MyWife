function time = makeTime( Fs,points)
%���ݲ����ʺͲ���������ʱ��
    time = 0:points-1;
    time = time * (1/Fs);
end