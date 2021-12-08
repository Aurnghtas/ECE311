clc
clear

%%design the plant
%define the variable
Ra = 3;
Ke = 0.01;
Kt = 0.01;
I = 6*10^(-4);
b = 10^(-4);

thetades= pi/2;
tau_l = 0.01;
d_bar = (Ra/Kt)*tau_l;
Vlim = 5;

%define the LTI object
A = Kt/(Ra*I);
B = (b+(Ke*Kt)/Ra)/I;
G = tf([A],[1 B 0])

%%design the lead controller
initial_crossover = 20;
K = 1/abs(evalfr(G,initial_crossover*j));

%create the bode plot
figure
bode(K*G)


%%define the the controller C1
alpha = 0.1;
[Gm,Pm,Wcg,omega_bar] = margin(K*G/(sqrt(alpha)));
T = 1/(sqrt(alpha)*omega_bar);
C1 = tf([K*T K],[alpha*T 1])

figure
bode(C1*G)
[Output1Gm, Output1Pm, Output1Wcg, Output1Wcp] = margin(C1*G);

%%define the the controller C2
%select TI
TI = 1/(0.1*Output1Wcp)
C2 = tf([TI 1],[TI 0]);

%%define the full controller
C = C1 * C2;

[Output2Gm,Output2Pm,Output2Wcg,Output2Wcp] = margin(C*G)

figure
bode(G/(1+C*G))

%tune the baseline parameters
T_R = minreal((C*G)/(1+C*G));
T_D = minreal(G/(1+C*G));

figure
subplot(211); 
step(thetades*T_R)
subplot(212);
step(d_bar*T_D)

stepinfo(thetades*T_R)

sin = tf([1],[1 0 1])












