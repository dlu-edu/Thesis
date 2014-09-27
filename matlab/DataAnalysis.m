% DataAnalysis.m
% *********************************************
% This is main script to find some exceptional date by compare v0, v1,
% (v0+v1)/2 and s/tau. Reasonable date should subject to:
%           s/v0<tau <s/v1 &  v1<(v0+v1)/2 approximate s/tau <v0
% Figure 1 give the relationship between tau(measured data) and s/v1, and 
% tau and s/v0.
% Figure 2 compare v0, v1,(v0+v1)/2 and s/tau.

% Zhou Lvwen:  zhou.lv.wen@gmail.com

nx = 1;
ns = 3;

xls={'DataOfConstantMass','DataOfVariableMass'};
sheet={'392.6','322.8','223.0','412.6g'};
if nx==2&ns~=4;
   error('DataOfVariableMass.xls only have sheet sheet{4}');
elseif nx==1&ns==4
    error('DataOfConstantMass.xls dont have sheet{4}');
end

data = xlsread(xls{nx},sheet{ns},'a3:c200');
d = 1;%cm
s = 100;%cm
t1 = data(:,1)/1000;%s
t2 = data(:,2)/1000;%s
tau= data(:,3);%s
v0 = d./t1;%cm/s
v1 = d./t2;%cm/s
[v0,I]=sort(v0);
v1 = v1(I);
tau = tau(I);
x=15:0.02:40;

figure('name','Compare s/v1,s/v0 and tau by Finally velocity')
subplot(1,2,1)
hold on
I = find(s./v1<tau); % Find unreasonable data.
for i = 1:length(I)
   plot(v1(I(i)),tau(I(i)),'mo','markersize',5,'linewidth',1.5)
end
h1=plot(x,s./x,v1,tau,'.k','markersize',10);
box on
legend(h1,{'$s/v^\prime$','$\tau$'},'Interpreter','latex')
xlabel('$ v^\prime $ (cm/s)','Interpreter','latex','fontsize',13);
ylabel('$ \tau $ (s)','Interpreter','latex','fontsize',13)

subplot(1,2,2)
hold on
I = find(s./v0>tau); % Find unreasonable data.
for i = 1:length(I)
   plot(v0(I(i)),tau(I(i)),'mo','markersize',5,'linewidth',1.5)
end
h2=plot(x,s./x,v0,tau,'.k','markersize',10);
box on
legend(h2,{'$s/v_0$','$\tau$'},'Interpreter','latex')
xlabel('$ v_0 $ (cm/s)','Interpreter','latex','fontsize',13);
ylabel('$ \tau $ (s)','Interpreter','latex','fontsize',13)


figure('name','Compare initial, finally, average and median velocity')
Vaverage = s./tau;
Vmedian = (v1+v0)./2;
x = 1:length(v0);
hold on
I = find(v0<Vaverage|Vaverage<v1); % Find unreasonable data.
for i = 1:length(I)
   plot(x(I(i)),Vaverage(I(i)),'mo','markersize',5,'linewidth',1.5)
end
h3 =plot(x,v0,'b-',x,v1,'r-',x,Vmedian,'-k',x,Vaverage,'.k','markersize',10);
box on
legend(h3,{'$v_0$','$v^\prime$','$(v_0+v^\prime)/2$','$s/\tau$'},'Interpreter','latex',2)
xlabel('Data','Interpreter','latex','fontsize',13)
ylabel('$ v $ (cm/s)','Interpreter','latex','fontsize',13);




