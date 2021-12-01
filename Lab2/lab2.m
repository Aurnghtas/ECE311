clc
clear

%%numerical linerliazation and sravlity assment

%%define the variable

M = 0.1;
La = 0.05;
Ra = 3;
g = 9.81;
km = 0.1;

ybar = 0.1;

xbar = [ybar;0;sqrt(g*M/km)*ybar];
ubar = sqrt(g*M/km)*ybar*Ra;

[A,B,C,D] = linmod('lab2_1',xbar,ubar);

%%define A1,B1,C1,D1
A1 = [0,1,0;2*g/ybar,0,-2*km*sqrt(g*M/km)/(M*ybar); 0,0,-Ra/La];
B1 = [0;0;1/La];
C1 = [1,0,0];
D1 = 0;
norm(A-A1)
norm(B-B1)
norm(C-C1)
norm(D-D1)


%% create the transfer function

ss_model = ss(A1,B1,C1,D1);
G = tf(ss_model)
eig(A1);
zpk_ = zpk(ss_model)


%% define the feedback control system
z = -10;
p = -100;
K = 70;

CONTROLLER = zpk(z,p,K)
new_sys = 1-CONTROLLER*G







