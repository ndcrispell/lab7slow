clear all; close all; clc; format compact
 
% Define parameters of circuit

 

% Load in data
 
% OPTION 1: If loading file from your local machine:
% A = csvread('data.csv',2,1);
 
% OPTION 2: If using MATLAB via Virtual Computing Lab, identify folder on your laptop:
A = csvread('SlowData2.csv',8,0);
 
% Extract and assign data
for i = 2:7
    A(:,i) = A(:,i).*(5/512); %convert code to voltage
end
tr = A(:,8); %time in microseconds
v0 = A(:,2); %a0
v1 = A(:,3); %a1
v2 = A(:,4); %a2
v3 = A(:,5); %a3
v4 = A(:,6); %a4
vout = A(:,7); %a5
tsc = tr/1000000; %microseconds to seconds

%analysis
voutnom = mean(vout(1:50)); %found average no load voltage

% isolated 2 prettiest loaded data sets, bounds by visual inspection to
% find troughs
vout2 = vout(156:192); 
vout3 = vout(263:299);


%averaged 2 responses
avgvout = (vout2+vout3)./2;

%dv is zero-set value of vout from the second op-amp. This value is the
%difference between the 2 sides of the wheatstone bridge multiplied by the
%gain of the op amp
dv = voutnom - avgvout;

standev = std(dv); %standard deviation of the voltage response

%resistances, match up with numbers in prelab
R2 = 470; 
R3 = 20000;


dvreal = dv*R2/R3; %difference before opamp (R2/R3) is inverse of gain

dv_avg = mean(dvreal); %turn array into usable avg value

Vin = 5; %you better know what this is

dR_R = 4*dv_avg/Vin; % deltaR over R for later use in equations

%all below are given values
g = 9.81; %gravity
b = .0255; %m
H = .00345; %m
y = H/2; %m
L = .263; %m
x = .0245; %m (location of strain gauge 
rho = 2700; %kg/m^3
mass = 2.268; %kg
GF = 2.1; %(dR/R)/eps

%obvious
volume = b*H*L; %volume of beam
Wbeam = volume*rho*g; %weight of beam
Wmass = mass *g; %weight of mass

M = Wbeam*(L/2-x)+Wmass*(L-x); %moment at strain gauge
I = b*H^3/12; %moment of inertia
stress = M*y/I; %come on you know this one

strain = 1/GF*dR_R; %you can probably guess this too

E = stress/strain; %Youngs Modulus
 
% Plot data
figure(1);hold on
wg = 1000;
hg = 500;
set(gcf,'units','points','position',[0,0,wg,hg])
plot(tsc,v0,'LineWidth',2)
plot(tsc,v1,'LineWidth',2)
plot(tsc,v2,'LineWidth',2)
plot(tsc,v3,'LineWidth',2)
plot(tsc,v4,'LineWidth',2)
plot(tsc,vout,'LineWidth',2)
y = 2.5;
line([0,tsc(end)],[y,y],'Color','red','LineStyle','--')
title('Title here');
grid minor
legend('a0','a1','a2','a3','a4','vout','Location','NorthEast')
title('Analysis of al;fhd; Circuit Data by Nate Crispell, Esquire')
xlabel('Time [sec]')
ylabel('Volt(V)')