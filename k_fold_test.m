clc;
clear;
close all;


load fisheriris
indices = crossvalind('Kfold',species,10); 
cp = classperf(species); 
for i = 1:10
      test = (indices == i); train = ~test;    %�ֱ�ȡ��1��2��...��10��Ϊ���Լ�������Ϊѵ����
      class = classify(meas(test,:),meas(train,:),species(train,:));
      classperf(cp,class,test);
end
cp.ErrorRate     %��ѯ���������