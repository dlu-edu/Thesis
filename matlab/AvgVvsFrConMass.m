% AvgVvsFrConMass.m
% *********************************************
% This fuctions is for the constant mass system to plot the figure of 
% average velocity vs average resistance(fr) and output the v1,v2,average 
% v,average fr and the error of the curve fitting
% Zhou Lvwen:  zhou.lv.wen@gmail.com

function [v1,v2,avgv,avgfr,error] = AvgVvsFrConMass(xls,sheet,m,ifplot,n)
d = 1;%cm
s = 100;%cm
global Vmmode

data = xlsread(xls,sheet,'a3:c200');
t1 = data(:,1)/1000;%s
t2 = data(:,2)/1000;%s
tau= data(:,3);%s
v1 = d./t1;%cm/s
v2 = d./t2;%cm/s
[avgv,index] = sort(s./tau);%cm/s
v1 = v1(index);
v2 = v2(index);
tau = tau(index);
[tau,vbar] = ChangeTauAndBarV(tau,v1,v2);

avgfr = m*(v1-v2)./tau;%dain
a = polyfit(avgv,avgfr,n);
avgvfit = avgv;
avgfrfit = polyval(a,avgvfit);
error = avgfrfit-avgfr;
Standard_deviation = sqrt(sum((error).^2)./(length(avgfr)-1));

if ifplot
    plot(avgv,avgfr,'.k',avgvfit,avgfrfit,'k-','markersize',15,'linewidth',2);
    ylim([0,400]);xlim([13,40]);
    
    if Vmmode == 1
        xlabelstr = strcat('$\bar v = ','s/\tau$ (cm/s)');
    else
        xlabelstr = strcat('$\bar v = ','(v_0+v^\prime)/2$ (cm/s)');
    end
    
    xlabel(xlabelstr,'Interpreter','latex','fontsize',13)
    ylabel('$\bar{f_r}$ (dain)','Interpreter','latex','fontsize',13) 
    text(14,380,strcat('$m={ }$ ',sheet,'g'),...   
               'Interpreter','latex','fontsize',13)
    text(14,350,strcat('$Y = ',poly2str(a,'x'),'$'),...
               'Interpreter','latex','fontsize',13)
    text(14.2,320,strcat('$S={ }$ ',num2str(Standard_deviation)),...
               'Interpreter','latex','fontsize',13)
    text(14.2,290,strcat('Data :',num2str(length(tau))),...
               'Interpreter','latex','fontsize',13)
end