%% 问题三-船体扰动模型求解
clear;clc;close all;

syms thetaf thetaa;
i = 1;
wxd = 0.1;
wyd = 0.9;
wzd = 0.5;
% for wxd = 1:10
%     for wyd = 1:10
%         for wzd = 1:10
between = 0.2:0.01:0.6;
for wyd = between
    record(i) = vpasolve(...
        [thetaf == -(wxd*cos(thetaa)+wyd*sin(thetaa)),...
        thetaa==-(wxd*sin(thetaa)*tan(thetaf)-wyd*cos(thetaa)*tan(thetaf)+wzd)],...
        [thetaf,thetaa]);
    record1(i)= rad2deg(double(record(i).thetaa));
    record2(i) = rad2deg(double(record(i).thetaf));
    i= i + 1;
end
% subplot(121);
figure
plot(between,record1);ylabel('\theta_a');xlabel('wyd');grid on;
% subplot(122);
figure
plot(between,record2);ylabel('\theta_f');xlabel('wyd');grid on;
%     enddouble(record.thetaf)
% end