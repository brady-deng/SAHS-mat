clc;
clear;
close all;

N = 5;

s1 = ['d{1} = importdata(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\dataw30&30.mat'')'];
s2 = ['d{2} = importdata(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\dataw30&15.mat'')'];
s3 = ['d{3} = importdata(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\dataw30&10.mat'')'];
s4 = ['d{4} = importdata(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\dataw30&5.mat'')'];
s5 = ['d{5} = importdata(''E:\�ĵ�\MATLAB����\ucd-process\UCD Sleep Apnea Database\����\dataw30&1.mat'')'];

eval(s1);
eval(s2);
eval(s3);
eval(s4);
eval(s5);

for i = 1:N
    s1 = ['l(i,1) = sum(d{i}.a.a1);'];
    s2 = ['l(i,2) = sum(~d{i}.a.a1);'];
    s3 = ['l(i,3) = length(d{i}.a.a1);'];
    eval(s1);
    eval(s2);
    eval(s3);
end

      
