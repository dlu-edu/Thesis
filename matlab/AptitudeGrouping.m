% AptitudeGrouping.m
% *********************************************
% This function choose and combine proper average v and average fr from 
% three constant mass system to approach the resistance of variable mass
% system.
% Zhou Lvwen:  zhou.lv.wen@gmail.com

function [a,aerror] = AptitudeGrouping(ifplot,n)
if nargin==0
   ifplot = 1;
   n = 1;% polyfit degree
end
global Vmmode
data=xlsread('DataOfVariableMass','412.6g','A3:E46');
M = [392.6,322.8,223.0];
mlim=[384.99  283.87];
d = 1;%cm
s = 100;%cm
E=0.16;

t1 = data(:,1)/1000;%s
t2 = data(:,2)/1000;%s
tau= data(:,3);%s
v1 = d./t1;%cm/s
v2 = d./t2;%cm/s

v1 = mean(v1-v2)./(mlim(1)-mlim(2))*M(1)+v1-...
     mean(v1-v2)./(mlim(1)-mlim(2))*mlim(1);
v2 = mean(v1-v2)./(mlim(1)-mlim(2))*M(3)+v1-...
     mean(v1-v2)./(mlim(1)-mlim(2))*mlim(1);
 
[v1,I]=sort(v1);
v2=v2(I);
tau=tau(I);

[tau,vbar] = ChangeTauAndBarV(tau,v1,v2);

ratio=(M(1)-M(2))/(M(1)-M(3));
vInsert = v2+(v1-v2).*ratio;
a1=polyfit(v1,vInsert,1);
a2=polyfit(v1,v2,1);

v1i=14:0.15:42;
vIi=polyval(a1,v1i);
v2i=polyval(a2,v1i);

xls='DataOfConstantMass';
sheet={'392.6','322.8','223.0'};

[v1m1,v2m1,avgvm1,avgfrm1,errorm1]=AvgVvsFrConMass(xls,sheet{1},M(1),0,n);
[v1m2,v2m2,avgvm2,avgfrm2,errorm2]=AvgVvsFrConMass(xls,sheet{2},M(2),0,n);
[v1m3,v2m3,avgvm3,avgfrm3,errorm3]=AvgVvsFrConMass(xls,sheet{3},M(3),0,n);

Index=[];
I1=[];
I2=[];
I3=[];
for i=1:length(v1i)
    e=E;
    for j=1:length(avgvm1)
        if abs(v1i(i)-avgvm1(j))<e
           e=abs(v1i(i)-avgvm1(j));
           I1=j;
        end
    end
    e=E;
    for j=1:length(avgvm2)
        if abs(vIi(i)-avgvm2(j))<e
           e=abs(vIi(i)-avgvm2(j));
           I2=j;
        end
    end
    e=E;
    for j=1:length(avgvm3)
        if abs(v2i(i)-avgvm3(j))<e
           e=abs(v2i(i)-avgvm3(j));
           I3=j;
        end
    end
    if (isempty(I1)+isempty(I2)+isempty(I3))==0
        Index=[Index;I1 I2 I3];
    end
    I1=[];I2=[];I3=[];
end

vGroup=[avgvm1(Index(:,1)),avgvm2(Index(:,2)),avgvm3(Index(:,3))];
frGroup=[avgfrm1(Index(:,1)),avgfrm2(Index(:,2)),avgfrm3(Index(:,3))];
errormGroup=[errorm1(Index(:,1)),errorm2(Index(:,2)),errorm3(Index(:,3))];

avgvg=mean(vGroup,2);
avgfrg=mean(frGroup,2);
avgerror=mean(abs(errormGroup),2);

a=polyfit(avgvg,avgfrg,n);
avgfrgfit1=polyval(a,avgvg);
S=sqrt(sum((avgfrgfit1-avgfrg).^2)./(length(avgfrgfit1)-1));
avgvgfit=15:0.1:40;
avgfrgfit=polyval(a,avgvgfit);

aerror=polyfit(avgvg,avgerror,n);
errori=polyval(aerror,avgvgfit);

if ifplot == 1
    plot(avgvg,avgfrg,'.k',avgvgfit,avgfrgfit,'k','markersize',15,'linewidth',2);
    hold on;
    plot(avgvgfit,[avgfrgfit-errori;avgfrgfit+errori],'b--','linewidth',2)
    if Vmmode == 1
        xlabelstr = strcat('$\bar v = ','s/\tau$');
    else
        xlabelstr = strcat('$\bar v = ','(v_0+v^\prime)/2$');
    end
    xlabel(xlabelstr,'Interpreter','latex','fontsize',13);
    ylabel('$\bar{f_r}$ (dain)','Interpreter','latex','fontsize',13)
    text(16,380,'$m_1 = 392.6g$, $m_2 = 322.8g$, $m_3 = 223.0g$ ',...
                'Interpreter','latex','fontsize',13)
    text(16,360,strcat('$Y = ',poly2str(a,'x'),'$'),...
                'Interpreter','latex','fontsize',13)        
    text(16.2,340,strcat('$S = ',poly2str(aerror,'x'),'$'),...
                'Interpreter','latex','fontsize',13)
    text(16.2,320,strcat('Data :',num2str(length(Index))),...
                'Interpreter','latex','fontsize',13)
end


