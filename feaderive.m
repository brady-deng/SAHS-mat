clc;
clear;
close all;

name = input('Please input the feature name you want to derive:');
s1 = ['data = importdata(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\',name,'.mat'');'];
eval(s1);

N = 23;
Int = 10;
T = data.WT;
ST = data.ST;
num = T/Int-1;
for i = 1:N
    s1 = ['Sp.Sp',num2str(i),' = data.f.f',num2str(i),'([1:6 9+num:(9+2*num-1)],:);'];
    s2 = ['f.f',num2str(i),' = data.f.f',num2str(i),'(7:9+num-1,:);'];
    eval(s1);
    eval(s2);
end


name1 = ['ff',num2str(T),'-',num2str(ST)];
name2 = ['fsp',num2str(T),'-',num2str(ST)];
s13 = ['save(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\',name2,'.mat'',''Sp'');'];
s14 = ['save(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\',name1,'.mat'',''f'');'];
eval(s13);
eval(s14);
    