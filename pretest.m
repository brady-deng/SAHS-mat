clc;
clear;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This script is for constructing the annotations for this dataset.
%   The variable T in this script is the length of time for deriving.
%   In 1-23 I add an auto saving code to make the script more effective.
%   Last editted by Brady Deng in 1-23
%   Last editted by Brady Deng in 2-3
%   Last editted by Brady Deng in 3-2
%   The number created by this script is changed from int to double in 3-2
%   I use down-sampling to low down the computation complexity.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ԭʼ�ź�����
data = importdata('E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\dataf&Sp.mat');
% ԭʼ�˹���ע����
an = importdata('E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\onlyanno.mat');

% ԭʼ������
fs = 128;
% ���ݿⱻ�Ը���
N = 25;
RN = 23;
%   Here T is the length of the period time.
T = input('Please input the data length:');
WT = input('Please input the window length:');
Tao = input('Please input the SpO2 delay(0-60):');
IP = WT/T;
M = 1/IP;
% segT = 
% �źŵ���ʵ������
rfs = 8;
% �źŽ������Ĳ���
step = fs/rfs;
% VT = WT;
% �����к��ж೤ʱ��ķ����¼���ȷ��Ϊ��������
VT = 5;
%ST��apnea��ʼ֮ǰ�Լ�֮����Ҫ�г���ʱ��
ST = 15;
%TaoѪ��֮������
% Tao = 20;
% Taofs = floor(Tao/rfs*fs);
% Ѫ��֮��ĵ�����Ҳ����������Ҫ���������ʱ��
Taofs = floor(Tao*rfs);
for i = 1:N
    % �¼��ĸ���
    s4 = ['l(i,3) = length(an.a',num2str(i),');'];
    eval(s4);
    % ����������

    % Ѫ��������
    s301 = ['data.f',num2str(i),' = data.f',num2str(i),'(1:step:end);'];
    s302 = ['data.Sp',num2str(i),' = data.Sp',num2str(i),'(1:step:end);'];
    
    eval(s301);
    eval(s302);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����ΪѰ�ҿɿ����ݵĴ��룬ɸ��ԭʼ�����д��ڵĲ�����Ȥ���¼��Լ�Ѫ�����ɿ�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    c = 1;
    for a = 1:l(i,3)
%       Periodic breathing (PB)/ Cheynes-Stokes (CS)����־Ϊ1���ں���Ӧ��ɾ��
        s956 = ['ann.a',num2str(i),'(c,1) = an.a',num2str(i),'(a,1);'];
        s957 = ['ann.a',num2str(i),'(c,2) = an.a',num2str(i),'(a,1) + an.a',num2str(i),'(a,2);'];
        s958 = ['ann.a',num2str(i),'(c,3) = an.a',num2str(i),'(a,3);'];
        
        eval(s956);
        eval(s957);
        eval(s958);
        c = c+1;
        
        
    end
    %   �˹���ע���¼�������
    s205 = ['l(i,6) = length(ann.a',num2str(i),'(:,1));'];
    eval(s205);
    s1011 = ['templ = length(data.f',num2str(i),');'];
    eval(s1011);
    tempind = zeros(1,templ);
    s1011 = ['tempsp = data.Sp',num2str(i),';'];
    eval(s1011);
    %   ���Ϊ2��ʱ��ζ���ɾ��
    %   Ѱ��Ѫ������50ˮƽ��ʱ���
    splow = find(tempsp<50);
    %   ��ʼ������ʱ���
    indstart = [1:600*rfs];
    tempind(splow) = 2;
    tempind(indstart) = 2;
    for k = 1:l(i,6)
        s1011 = ['tempan = ann.a',num2str(i),';'];
        eval(s1011);
        if tempan(k,3) == 0
            tempind(tempan(k,1)*rfs:tempan(k,2)*rfs) = 1;
        elseif tempan(k,3) == 1
            tempind(tempan(k,1)*rfs:tempan(k,2)*rfs) = 2;
        end
    end
    inddel = find(tempind == 2);
    s1011 = ['data.f',num2str(i),'(inddel) = [];'];
    eval(s1011);
    s1011 = ['data.Sp',num2str(i),'(inddel) = [];'];
    eval(s1011);
    tempind(inddel) = [];
    
    ind{i} = tempind;
        

    
    
    
    s1012 = ['dl = length(data.f',num2str(i),');'];
    eval(s1012);
    % ��������
    s9191 = ['data.f',num2str(i),' = data.f',num2str(i),'(1:end-Taofs);'];
    s9192 = ['data.Sp',num2str(i),' = data.Sp',num2str(i),'(Taofs+1:end);'];
    eval(s9191);
    eval(s9192);
    % ȷ����ͬ�Ĵ��ڵ������ܳ�����һ�µ�
    s1011 = ['segT = floor(dl/rfs)-30;'];
    eval(s1011);
    s1011 = ['data.f',num2str(i),' = data.f',num2str(i),'(1:segT*rfs);'];
    eval(s1011);
    s1012 = ['data.Sp',num2str(i),' = data.Sp',num2str(i),'(1:segT*rfs);'];
    eval(s1012);
    ind{i} = ind{i}(1:segT*rfs);
    tempind = tempind(1:segT*rfs);
    % l��i��1���źų���
    s1 = ['l(i,1) = length(data.f',num2str(i),');'];
    % �ź��ж��ٸ������Ĵ���
    s2 = ['l(i,2) = floor(l(i,1)/(T*rfs));'];
    eval(s1);
    eval(s2);

    % ��ȡ���źų���
    s202 = ['l(i,4) = l(i,2)*rfs*T;'];
    % �������ڵ�����Ŀ
    s201 = ['l(i,5) = fix((l(i,4)/rfs-T)/WT)+1;'];
    eval(s202);
    eval(s201);
    



    % �����ݻ���
    s9 = ['tempf = Findw(data.f',num2str(i),',T,WT,rfs);'];
    s10 = ['tempsp = Findw(data.Sp',num2str(i),',T,WT,rfs);'];
    
    eval(s9);
    eval(s10);
    s1011 = ['tempindw = Findw(tempind,T,WT,rfs);'];
    eval(s1011);
    tempanno = zeros(length(tempf),1);
    tempindsum = sum(tempindw);
    indapnea = find(tempindsum>=VT*rfs);
    tempanno(indapnea) = 1;

    s1011 = ['anno.a',num2str(i),' = tempanno;'];
    eval(s1011);

    s214 = ['ds.t.f',num2str(i),' = data.f',num2str(i),';'];
    eval(s214);
    s215 = ['ds.t.Sp',num2str(i),' = data.Sp',num2str(i),';'];
    eval(s215);
    s216 = ['ds.s.f',num2str(i),' = tempf;'];
    eval(s216);
    s217 = ['ds.s.Sp',num2str(i),' = tempsp;'];
    eval(s217);
    s218 = ['ds.a.a',num2str(i),' = anno.a',num2str(i),';'];
    eval(s218);
    
    clear tempf tempsp tempind templ tempanno tempindw tempindsum
end
index = zeros(2,max(l(:,5)));
for i = 1:max(l(:,5))
    index(1,i) = (i-1)*WT;
    index(2,i) = (i-1+M)*WT;
end

clear an

clear dataseq
c = 1;
for i = 1:N
    
    s2 = ['if i~=3 && i~=9 datar.an.a',num2str(c),' = ds.a.a',num2str(i),'; end'];
    eval(s2);
    s1 = ['if i~=3 && i~=9 datar.f',num2str(c),' = ds.s.f',num2str(i),'; end'];
    eval(s1);
    s5 = ['if i~=3 && i~=9 datar.Sp',num2str(c),' = ds.s.Sp',num2str(i),'; end'];
    eval(s5);
    s1011 = ['if i~=3 && i~=9 datar.tf',num2str(c),' = ds.t.f',num2str(i),'; end'];
    eval(s1011);
    s1011 = ['if i~=3 && i~=9 datar.tsp',num2str(c),' = ds.t.Sp',num2str(i),'; end'];
    eval(s1011);
    if i~=3 && i ~= 9
        c = c+1;
    end
    
    
end
clear ds
for i = 1:RN
    s214 = ['ds.t.f',num2str(i),' = datar.tf',num2str(i),';'];
    s215 = ['ds.t.Sp',num2str(i),' = datar.tsp',num2str(i),';'];
    s216 = ['ds.s.f',num2str(i),' = datar.f',num2str(i),';'];
    s217 = ['ds.s.Sp',num2str(i),' = datar.Sp',num2str(i),';'];
    s218 = ['ds.a.a',num2str(i),' = datar.an.a',num2str(i),';'];
    eval(s214);
    eval(s215);
    eval(s216);
    eval(s217);
    eval(s218);
end
clear datar

for i = 1:RN

    
    s1 = ['temp_a.a',num2str(i),' = zeros(floor(length(ds.t.f',num2str(i),')/rfs),1);'];
    s2 = ['l(i,7) = floor(length(ds.t.f',num2str(i),')/rfs),1;'];


    eval(s1);
    eval(s2);
    for count = 1:l(i,6)
        s2 = ['temp_a.a',num2str(i),'(ann.a',num2str(i),'(count,1):ann.a',num2str(i),'(count,2)) = (ann.a',num2str(i),'(count,3)+1);'];
        eval(s2);
    end

end


% temp_a = ds.a;
ds.l = l;
ds.T = T;
ds.WT = WT;
ds.tao = Tao;
ds.re = 0;
s13 = ['save(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\dataw',num2str(T),'&',num2str(WT),'.mat'',''ds'');'];
eval(s13);
