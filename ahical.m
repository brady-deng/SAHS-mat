function [ output_args,start,endcache ] = ahical( label )
%   �����ǩ�е��ܵ��¼���Ŀ�����ص�output_args���ܵ��¼���Ŀ
%   start��ʱ�俪ʼʱ�䣬endcache��ʱ�����ʱ�䣬label������
%   ����ı�ǩ
%   Detailed explanation goes here
l = length(label);
startflag = 0;
endflag = 0;
aha = 0;
start = zeros(1,400);
endcache = zeros(1,400);
c = 1;
for i = 1:l-1
    if label(i) == 0 && label(i+1) == 1
        startflag = 1;
        endflag = 0;
        tempstart = i;
    end
    if label(i) == 1&& label(i+1) == 0
        startflag = 0;
        endflag = 1;
        tempend = i;
    end
    if endflag == 1&&startflag == 0
        aha = aha+1;
        start(c) = tempstart;
        endcache(c) = tempend;
        c = c+1;
        startflag = 0;
        endflag = 0;
    end
end
output_args = aha;
        


end

