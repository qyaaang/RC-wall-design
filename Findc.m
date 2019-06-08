%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This routine calculates the initial depth of neutral axis
%Developed by: 
%Qun Yang (qyan327@aucklanduni.ac.nz), Unversity of Auckland
%Date: 20/05/2019
%Update hostory:

%Variables
%N=       Axial demand of wall section
%alpha=   Concrete stress factor
%beta=    Neutral axis factor
%fy=      Yield strength of bar
%fc=      Compressive strength of concrete
%tw=      Width of wall section
%dw=      Diameter of bars in wall web
%nbw=     Number of bars in the wall web
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c=Findc(N,fy,fc,tw,dw,nbw,alpha,beta)

%Calculate the tensile force in wall web
T1=nbw*(3.14*dw*dw/4)*fy;
%Calculate the compressive force of concrete
Cc=N+T1;
%Calculate the deptht of concrete compressive stress block
a=Cc/(alpha*fc*tw);
%Calculate the depth of neutral axis
c=a/beta;
end