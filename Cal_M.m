%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This routine checks whether the capacity is greater than demand
%Developed by: 
%Qun Yang (qyan327@aucklanduni.ac.nz), Unversity of Auckland
%Date: 19/05/2019
%Update hostory:
%21/05/2019 Adjust the iteration process

%Variables
%alpha=  Concrete stress factor
%beta=   Neutral axis factor
%phai=   Strength reduction factor
%Nn=     Axial demand
%lw=     Length of wall section
%tw=     Width of wall section
%nl=     Number of bar layers
%c=      Initial depth of netrual axis
%P=      Position matrix of bars
%D=      Diameter matrix of bars
%ey=     Yield strain of bars
%Es=     Modulus of bars
%fc=     Compressive strength of concrete   
%eccu=   Ultimate concrete compressive strain  
%tor=    Iteration torlerence
%itn=    Iteration number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Mn=Cal_M(alpha,beta,phai,Nn,lw,tw,nl,c,P,D,ey,Es,fc,eccu,tor,itn)

k=0;
for nm=1:itn
disp('Iteration')
k=k+1

%Determine the number of bars in compression and tension
numbc=0;
numbt=0;
numb=length(P);

for i=1:numb
    if P(i)<c
        numbc=numbc+1;
    else
        numbt=numbt+1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Compressive zone                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cs=0;
Ms=0;
Ast=0;
%Check yielding
for m=1:numbc
   ecb(m)=((c-P(m))/c)*eccu;
   if ecb(m)>=0.8*ey
       ecb(m)=ey;
   else
       ecb(m)=0;
   end
   %Calculate the area of bars in compression
   Ast=Ast+nl*3.14*D(m)^2/4;
   %Calculate the compressive force of bars
   Cs=Cs+nl*Es*ecb(m)*(3.14*D(m)^2/4);
   %Calculate the compressive force of concrete
   Cc=alpha*fc*(beta*c*tw-Ast);
   %Calculate flexural strength provided by compressive forces
   Ms=Ms+nl*Es*ecb(m)*(3.14*D(m)^2/4)*(c-P(m));
   Mc=Cc*(c-0.5*beta*c);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Tensile zone                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ts=0;
Mt=0;
%Check yielding
for n=1:numbt
  etb(n)=((P(numbc+n)-c)/c)*eccu;
  if etb(n)>=0.8*ey
      etb(n)=ey;
  else
      etb(n)=0;
  end
  %Calculate the tensile force of bars
  Ts=Ts+nl*Es*etb(n)*(3.14*D(numbc+n)^2/4);
  %Calculate the flexural strength provided by tensile bars
  Mt=Mt+nl*Es*etb(n)*(3.14*D(numbc+n)^2/4)*(P(numbc+n)-c);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calculate the flexural strength of wall
Mn=phai*(Mc+Ms+Mt+Nn*(0.5*lw-c))/1e6;

%Calculate the unbalanced force of tensile and compressive forces
UnBal=(Ts+Nn)-(Cc+Cs)

%Iteration process
if abs(UnBal)<=tor
    break;
else
    Cc=Cc+UnBal;
end

%Update depth of netrual axis
c=(Cc/(alpha*fc)+Ast)/(beta*tw);

end
end