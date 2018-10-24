clc;
clear;
% close all;
T = input('Please input the data name you want to extract features:');

s1 = ['data = importdata(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\',T,'.mat'');'];
eval(s1);
% tic;
% T = data.T;

fs = 128;
N = 1;
C = 16;
%   Here C is the downsampling index.
an = data.a;
rfs = 8;
WT = data.T;
ST = data.WT;
FT = 10;
subt = WT/FT-1;
WL = WT*rfs;
RESO = 2*rfs/WL;
IF = 0.5;
IN = fix(IF/RESO);

for i = 1:N
    s1 = ['d.f',num2str(i),' = data.s.f',num2str(i),';'];
    eval(s1);
%     s2 = ['d.Sp',num2str(i),' = data.s.Sp',num2str(i),';'];
    s2 = ['d.Sp',num2str(i),' = data.s.Sp',num2str(i),'(1:8:end,:);'];
    eval(s2);
    s3 = ['d.fft',num2str(i),' = abs(fft(d.f',num2str(i),'));'];
    s4 = ['l(i) = length(d.f',num2str(i),'(1,:));'];
    eval(s4);
    s5 = ['d.Sp.d',num2str(i),' = std(d.Sp',num2str(i),');'];
    s6 = ['d.f.d',num2str(i),' = std(d.f',num2str(i),');'];
    s7 = ['d.f.fft',num2str(i),' = abs(fft(d.f',num2str(i),'));'];
    eval(s7);
    s8 = ['d.f.ftk',num2str(i),' = d.f.fft',num2str(i),'(1:10,:);'];
    eval(s8);
    s9 = ['d.f.ftk',num2str(i),' = mapminmax(d.f.ftk',num2str(i),''');'];
    s10 = ['d.f.kur',num2str(i),' = kurtosis(d.f.ftk',num2str(i),');'];
    eval(s10);

end
temp_l = data.l;
clear data
ft = [];
at = [];
t = [1/(rfs*WT):1/(rfs*WT):1];
% ��ͨ������
Hapor = 0.7;
% ����ͨ������
HaporH = 0.85;
% ��ͨ��Ѫ������
HaSp = 0.98;
% ����ͣ�ͱ���
apor = 0.3;
flowth = [0,9,15];
ST = 30;
for i = 1:N
%     temp1��������ʼ������ֹ��
%     temp2��������ֵ
    s971 = ['[temp1,temp2] = breathphse(d.f',num2str(i),');'];
    eval(s971);
%     temp3������ֵ֮��
    temp3 = sum(abs(temp2));
%     temp5������ֵ���ֵ
    temp5 = max(abs(temp2));
%     hathre������ͨ����ֵ
%     ����Ϊ�ö����ֵ����Ϊ�п��ܲ�׽����������������
%   tempmax���������ڳ��ȼ�ST��ʱ����ڵĵڶ����ֵ
%   tempmin���������ڳ��ȼ�ST��ʱ����ڵĵڶ�С��ֵ
    s1009 = ['[tempmax,tempmin] = Findmax(temp2(1:5,:),ST);'];
    eval(s1009);
    s911 = ['hathreh = Hapor*tempmax;'];
    s1008 = ['hathrel = Hapor*tempmin'];
    s912 = ['athreh = apor*tempmax;'];
    s1009 = ['athrel = apor*tempmin;'];
    s913 = ['hathreH = HaporH*tempmax;'];
    eval(s911);
    eval(s1008);
    eval(s1009);
    eval(s912);
    eval(s913);
%     s1009 = ['[tempmax,tempmin] = Findmax(d.f',num2str(i),');'];
%     eval(s1009);
%     for k = 1:length(hathreh)
%         if hathreh(k) > 8.5
%             hathreh(k) = 8.5;
%         end
%         if hathrel(k) < - 8.5
%             hathrel(k) = -8.5;
%         end
%     end
%     tempHa��ͨ��������tempL��������������
    tempA = zeros(1,length(temp1));
    tempHa = zeros(1,length(temp1));
    tempHaH = zeros(1,length(temp1));
    for count = 1:length(temp1)
        tempL(count) = length(temp1{count});
        temp4(count) = length(temp1{count});
        for tempcount = 1:tempL(count)
            if temp2(tempcount,count)>0 && temp2(tempcount,count)<hathreh(count)
                tempHa(count) = tempHa(count)+1;
                if temp2(tempcount,count) < athreh(count)
                    tempA(count) = tempA(count)+1;
                end
            end
            if temp2(tempcount,count)<0 && temp2(tempcount,count)>hathrel(count)
                tempHa(count) = tempHa(count)+1;
                if temp2(tempcount,count) > athrel(count)
                    tempA(count) = tempA(count)+1;
                end
            end
            if abs(temp2(tempcount,count))>hathreH(count)
                tempHaH(count) = tempHaH(count)+1;
            end
        end
    end
    s1008 = ['spmax = FindSp(d.Sp',num2str(i),',5);'];
    eval(s1008);
    % ����������ֵ
%     s972 = ['f.f',num2str(i),'(1,:) = temp3./temp4;'];
    % Ѫ���������0.8821 ,AUC��󣬱ȽϾ��⣬��10��64��
    s973 = ['f.f',num2str(i),'(1,:) = std(d.Sp',num2str(i),');'];
    eval(s973);
    % Ѫ���������0.8664��������1���ƣ��ȽϾ��⣬������1���������棬��10��60��
    s974 = ['f.f',num2str(i),'(2,:) = max(d.Sp',num2str(i),')-min(d.Sp',num2str(i),');'];
    eval(s974);
    % ��������
%     s975 = ['f.f',num2str(i),'(4,:) = tempL'];
    % ��ͨ��������ռ���أ�����0.8297�����������1�����ԱȽ����У����������������Ļ��ǱȽ�������40��98������50��99������10��20��
    s976 = ['f.f',num2str(i),'(3,:) = tempHa./tempL;'];
    eval(s976);
    % ��ͨ������������0.8219��������3���ƣ�Ӧ�ÿ���������3���棬
    s977 = ['f.f',num2str(i),'(4,:) = tempHa;'];
    eval(s977);
    % Ѫ����ͨ������������0.8453���ȽϾ��⣬������1�Ƚ����ƣ�������1���������棬������û�дﵽ90����10��60��
    s978 = ['f.f',num2str(i),'(5,:) = Findlow(d.Sp',num2str(i),',spmax*HaSp);'];
    eval(s978);
    % ��Сֵ������
    s979 = ['[var1,var2] = min(d.Sp',num2str(i),');'];
    eval(s979);
    % ���ֵ��������
    s980 = ['[var3,var4] = max(d.Sp',num2str(i),');'];
    eval(s980);
    % ����Сֵ�����ֵ��б�ʣ�ûɶ�ã���̫�У��������ûʲô�ã����Կ��ǣ����зֲ��Ĳ�ͬ
    s981 = ['f.f',num2str(i),'(6,:) = 100*(var3-var1)./(var4-var2);'];
    eval(s981);
    % ���ڷ�ֵ�����ٷ�֮��ʮ�ı����������������Ƚ����У�Ӧ�ÿ�����1���������棬AUC0.7773����50��98��,(60,95)����һ�����ص������ǲ���
    s983 = ['f.f',num2str(i),'(7,:) = tempHaH./tempL;'];
    eval(s983);
    % Ƶ���׷�ȣ����У�AUC0.70������һ�඼������
    s984 = ['f.f',num2str(i),'(8,:) = d.f.kur',num2str(i),';'];
    eval(s984);
    % ����ͣ�ʹ���,��̫�У������ǲ��ǿ�������ȷ��Apnea�������У�����һ�඼�����У�������������ѽ��
    s911 = ['f.f',num2str(i),'(9,:) = tempA./tempL;'];
    eval(s911);
    % Ѫ������91��ʱ��
    s9191 = ['f.f',num2str(i),'(10,:) = Findlow(d.Sp',num2str(i),',91);'];
    % Ѫ������92��ʱ�����������𣬵����ص��Ĳ���ͬ����ܶ�
    s9192 = ['f.f',num2str(i),'(11,:) = Findlow(d.Sp',num2str(i),',92);'];
    eval(s9191);
    eval(s9192);
    % ��������ͣ�͵�ʱ��,���ܲ�׽��������������һ��������������������ֲ�����һЩ�������ص��Ĳ���̫����
    s9121 = ['f.f',num2str(i),'(12,:) = Findlow(abs(d.f',num2str(i),'),4);'];
    eval(s9121);
    s9122 = ['temp = d.f.ftk',num2str(i),';'];
    eval(s9122);
    % Ѫ��Ƭ�ε��������ƣ���һ�������𣬵��ǲ���Ӳ����������ֲ���0���µĵط�������������ֲ���0����Χ�����ǻ��кܴ���ص�
    s9194 = ['f.f',num2str(i),'(13,:) = 100*(d.Sp',num2str(i),'(end,:)-d.Sp',num2str(i),'(1,:))/WL;'];
    eval(s9194);
    s1008 = ['temp = max(d.Sp',num2str(i),');'];
    eval(s1008);
    s1009 = ['temp = [90,temp(1:end-1)];'];
    eval(s1009);
    s978 = ['f.f',num2str(i),'(14,:) = Findlow(d.Sp',num2str(i),',temp*HaSp);'];
    eval(s978);
    s1009 = ['temp = f.f',num2str(i),'(13,:);'];
    eval(s1009);
    for k = 1:length(temp)
        if temp(k) > 0
            s1009 = ['f.f',num2str(i),'(14,k) = 0'];
            eval(s1009);
        end
    end
    
%     ind = [1,3,5,21,22,23,26];
%     ind = [3,7,29];
%     s9195 = ['f.f',num2str(i),' = f.f',num2str(i),'(ind,:);'];
%     eval(s9195);

    clear temp1 temp2 temp3 temp4 tempL tempHa tempHaH;
    
    s991 = ['tempind = find(an.a',num2str(i),'==2);'];
    s992 = ['an.a',num2str(i),'(tempind) = [];'];
    s993 = ['f.f',num2str(i),'(:,tempind) = [];'];
    s994 = ['d.f',num2str(i),'(:,tempind) = [];'];
    s995 = ['d.Sp',num2str(i),'(:,tempind) = [];'];
    s996 = ['d.f.fft',num2str(i),'(:,tempind) = [];'];
    
    eval(s991);
    eval(s992);
    eval(s993);
    eval(s994);
    eval(s995);
    eval(s996);
    clear tempind;
end

name = input('Please input the feature file name you want to save:');
s13 = ['save(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\',name,'.mat'',''f'',''an'',''ft'',''at'',''WT'',''ST'',''temp_l'');'];
% eval(s13);