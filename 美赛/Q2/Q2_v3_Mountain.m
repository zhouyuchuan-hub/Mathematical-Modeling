% 问题二2.1-自建模型
clc;close;clear;

theta = 10:1:40;
for i = 1:length(theta)
%% 初始化
Pi = 20;      % 输入功率
Po = -127;   % 输出功率
beta = deg2rad(50);    % 仰角
N = [               % 各层电子密度
    2.5*10^9        % D层
    2*10^11         % E层
    ];
v = [
    5*10^6;    % D层
    10^5;          %E层
    ];
c = 3*10^8;
e = 1.60217662 * 10^(-19);  % 电量
hup = 150*10^3;
hdown = 60*10^3;
h = hup - hdown;       % 高度差
hmax = 200*10^3; % 最高高度
Nmax = 8*10^11; % 最大电子密度
R = 6371*10^3;      % 地球半径
m = 9.106*10^(-31);
fmax = sqrt((80.8*Nmax*(1+2*hmax/R))/(sin(beta)^2+2*hmax/R));      % 最大频率估算公式
f = 0.85*fmax;    % 工作频率
lamda = c /f;   % 波长
w = 2*pi*f;     % 工作角频率

%% 单次反射损耗计算
Lf = 20*log10(f/10^6);  % 工作

l = h/sin(beta);
a1 = (60*pi*N(1)*e^2*v(1))/(m*(w^2 + v(1)^2));        % D层吸收损耗
La1 = exp(-a1*l)*2;
a2 = (60*pi*N(2)*e^2*v(2))/(m*(w^2 + v(2)^2));        % E层吸收损耗
La2 = exp(-a2*l)*2;
La = La1+La2;
Le = 15.4;        % 12点

% 山地反射
% 初始化
er = 4;            % 相对介电常数
o = 10^-3;            % 海水电导率
ee = er+60*lamda*o*i;     % 海面复介电常数

    alpha = deg2rad(30);        % 山坡
    gama = pi -(alpha + beta);
    allow = pi/2 - beta;
    percent = allow/pi;
    RH = (sin(gama)-sqrt(ee - cos(gama)^2))/(sin(gama)+sqrt(ee-cos(gama)^2));
    RV = (ee*sin(gama) - sqrt(ee - cos(gama)^2))/(ee*sin(gama)+sqrt(ee - cos(gama)^2));
    R1 = (abs(RV)^2 + abs(RH)^2);
    Lg = abs(10*log10(R1/2));
    
    k = 1;
    while 1
        % 计算一次损耗
        Pi = Pi - La - 20*log10(hup/10^3*2);                   % 电离层以及部分空间损耗
        Pi = (Pi - Lg);     % 山坡
        Pi = 10^(Pi/10)*percent;    % 转换为W
        Pi = 10*log10(Pi)
        
        % 判断是否是已达到最后
        temp = Pi - 32.45 - 20*log10(f/10^6);
        if temp <= Po
            disp('跳跃');
            disp(k)
            record(i) = k;
       
            break;
        end
        k = k +1;
    end
end

plot(theta,k);
