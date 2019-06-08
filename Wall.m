%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This program is used to design a specific RC wall section
%Developed by: 
%Qun Yang (qyan327@aucklanduni.ac.nz), Unversity of Auckland
%Date: 19/05/2019
%Units: N, mm, MPa
%References: NZS 3101:2006, New Zealand Concrete Structures Standard. Standards New Zealand, Wellington.
%Update hostory:
%22/05/2019 1. Add an iteration process for choosing bar diameter if analysis failed
%           2. Add concrete stress factor and neutral axis factor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Geometry property input                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Input length of wall section
lw=3050;
%Input width of wall section
tw=250;
%Input distance from the wall edge to the centroid of tensile bars in wall end region
dc=100;
%Input number of bar layers
nl=2;
%Input diameter of bars in wall web
d1=12;
%Input number of bars in the wall web
n1=20;
%Input number of bars in each wall end region
n2=4;
%Input position of bars
load position.txt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Material property input                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Input compressive strength of concrete
fc=30;
%Input yield strength of reinforcing bar
fy=500;
%Input elastic modulus of bar
Es=200000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Demand input                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Input flexural demand
M=3600e6;
%Input axial demand
N=600e3;
%Input strength reduction factor NZS3101 2006 Clause 2.3.2.2
phai=0.85;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Find initial diameter of bars in wall end region        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Assumption: 1. All web bars are subjected tension to yielding
%            2. T2=Cs
%      where T2=tensile force of bars in wall end region;
%            Cs=compressive force bars in wall end region;
%Calculate flexural strength
Mn=M/phai;
%Calculate axial strength
Nn=N/phai;

%Calculate concrete stress factor for ULS NZS3101 2006 Clause 7.4.2.7
if fc<=55
    alpha=0.85;
else
    alpha=0.85-0.004*(fc-55);
end
if alpha<0.75
    alpha=0.75;
end
%Calculate neutral axis factor for ULS NZS3101 2006 Clause 7.4.2.7
if fc<=30
    beta=0.85;
else
    beta=0.85-0.008*(fc-30);
end
if beta<0.65
    beta=0.65;
end

%Find initial depth of netrual axis
c0=Findc(Nn,fy,fc,tw,d1,n1,alpha,beta);
%Find area of bars in wall end region 
As=FindArea(Mn,Nn,fy,fc,lw,tw,d1,n1,n2,dc,alpha);
%Determine diameter of bars in  wall region
d2=ceil(sqrt(4*As/3.14));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Determine diameter of bars in wall end region          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Specify iteration number
itdb=100;

for d=1:itdb
    
%Generate diameter matrix
for i=1:length(position)
    D(i)=d2;
end
for j=(n2/2+1):(length(position)-n2/2)
    D(j)=d1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Check demand and capacity                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calculate yield strain of bar
ey=fy/Es;
%Specify ulmate compressive strain of concrete NZS3103 2006 Clause 7.4.2.3
eccu=0.003;
%Specify iteration number
itn=100;
%Specify iteration tolerence
tor=1e-5;

%Check whether capacity is greater than demand
M_n=Cal_M(alpha,beta,phai,Nn,lw,tw,nl,c0,position,D,ey,Es,fc,eccu,tor,itn);
if M_n>=M/1e6
    disp('OK')
    break;
else
    disp('Analysis fail, need a larger diameter')
%Specify diameter increment 
    delta_d=1;
    d2=d2+delta_d;
end
end