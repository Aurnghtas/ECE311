clc
clear

%%part 3 define motor and output
%%define variable
La = 0.02;
Ra = 3;
Ke = 0.01; 
Kt = 0.01;
I = 0.0006;
b = 0.0001;

%%define metrics
A = [0,1,0; 0,-b/I,Kt/I; 0,-Ke/La,-Ra/La];
B = [0; 0; 1/La];
C = [0,1,0];
D = 0;


%%define simplified metrics
A1 = [0,1; 0,-(b+(Ke*Kt)/Ra)/I];
B1 = [0; Kt/(Ra*I)];
C1 = [0,1];
D1 = 0;

%%define motor
motor = ss(A,B,C,D);
motor_simplified= ss(A1,B1,C1,D1);

%%convert the object to transfer function
G_motor = tf(motor);
G_motor_simplified = tf(motor_simplified);

%%convert the model to zpk form
zpk_motor = zpk(motor);

%%extract the list of poles of the transfer function
zpk_motor_data = cell2mat(zpkdata(G_motor));

%%extract numerator and denominator arrays for motor and simplified motor
%motor
[num den] = tfdata(G_motor);
num = cell2mat(num);
den = cell2mat(den);

%simplified motor
[num1 den1] = tfdata(G_motor_simplified);
num1 = cell2mat(num1);
den1 = cell2mat(den1);

%% part 4

%% define the array
T =linspace(0,30,1000);

%% create the step response and plot the graph for the motor
subplot(311); 
Y1=step(motor,T);
plot(T,Y1);
xlabel("Time(s)");
ylabel("Speed");
title("Step response of the motor's speed in 30s");

%% create the stepresponse and plot the graph for the simplified motor
subplot(312);
Y2=step(motor_simplified,T);
plot(T,Y2)
xlabel("Time(s)")
ylabel("Speed")
title("Step response of the simplifed motor'speed in 30s");

%% create the stepresponse and plot the graph for the simplified motor and motor difference
subplot(313);
plot(T,Y1-Y2);
xlabel("Time(s)");
ylabel("Speed Difference");
title("Step response for the simplified motor and motor speed difference in 30s");
%%the graph has a relative small difference(0.04-0) between the motor and simplified motor



%% using final value theorem to determine the theoritial
final_speed = 833.33/33.33


%% plot the armature current versus time
[Y,T1,X] = step(motor,T);
figure
current = X(:,3);
plot(T1,current)
xlabel("Time(s)")
ylabel("Current(A)")
title("Armature current change versus time in 30s")

%% find the output response with initial condition
X0 = [0;-1;.5];
figure
U=sin(T);
M = lsim(motor,U,T,X0);
plot(T,M);
xlabel("Time(s)");
ylabel("Speed");
title("Input response for the  motor's speed with sinusoidal input")

%% evaluate the motor transfer function at s = i
s=i;
evalfr(G_motor,s)


