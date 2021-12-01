clc
clear

%define the variable
M = 1000;
B = 1;
g = 9.81;
a = B/M;
vdes = 14;
thetta =-pi/6;
dbar = g*sin(thetta);

num = [1];
den = [1 a];
G = tf(num,den)

%%define the p1 p2 based on our choice
p1 = 15/14;
p2 = 15/14;

%%define K and TI based on our derivation
K = p1+p2-a;
TI = (p1+p2-a)/(p1*p2);

%%define the tansfer function of C
numC=[K*TI K];
denC = [TI 0];
C = tf(numC,denC)

%%define the transfer function 
T = (C*G)/(1+C*G)

%%perform the pole-zero cancellation
T = minreal(T);
[z p k] = zpkdata(T);
cell2mat(p)

H = stepinfo(T)









