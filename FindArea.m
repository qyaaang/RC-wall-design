%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This routine calculates the area of tensile bar in wall end region
%Developed by: 
%Qun Yang (qyan327@aucklanduni.ac.nz), Unversity of Auckland
%Date: 19/05/2019
%Update hostory:

%Variables
%M=       Flexural demand of wall section
%N=       Axial demand of wall section
%alpha=   Concrete stress factor
%fy=      Yield strength of bar
%fc=      Compressive strength of concrete
%lw=      Length of wall section
%tw=      Width of wall section
%dw=      Diameter of bar in wall web
%nbw=     Number of bars in the wall web
%nbe=     Number of bars in the wall end region
%dc=      Distance from the wall edge to the centroid of tensile bars in wall end region
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function As=FindArea(M,N,fy,fc,lw,tw,dw,nbw,nbe,dc,alpha)

%Calculate the tensile force in wall web
T1=nbw*(3.14*dw*dw/4)*fy;
%Calculate the compressive force of concrete
Cc=N+T1;
%Calculate the deptht of concrete compressive stress block
a=Cc/(alpha*fc*tw);
%Calculate the flexural strength contributed by N and T1
M1=Cc*(0.5*lw-0.5*a);
%Calculate the flexural strength contributed by T2
M2=M-M1;
%Calculate the tensile force in wall end region
T2=M2/(lw-2*dc);
%Calculate the area of each bar
As=T2/(fy*nbe);
end