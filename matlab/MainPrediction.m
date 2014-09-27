% MainPrediction.m
% *********************************************
% This is main script to predict time interval(tau) and finally velocity(v1).
% Zhou Lvwen:  zhou.lv.wen@gmail.com

global deduce Vmmode
n = 1;% polyfit degree
vtaufit = 1; % vtaufit==1 for 'tau = a*v0+b'; vtaufit == 2 for 'tau = a/v0' 
Vmmode = 2;  % Vmmode = 1 for vbar = s/tau;
             % Vmmode = 2 for vbar = (v0+v1)/2, tau = s/vbar;
deduce = 1;  % The prediction deduce by lou: deduce==1, by zhou: deduce==2; 

data = xlsread('DataOfVariableMass','412.6g','A3:E46');
m0 = 412.6-data(:,4);%g
Dm = data(:,5);%g
d = 1;%cm
s = 100;%cm
t1 = data(:,1)./1000;%s
t2 = data(:,2)./1000;%s
tau= data(:,3);%s
v0 = d./t1;%cm/s
v1 = d./t2;%cm/s

[v0,I]=sort(v0);
v1=v1(I);
tau=tau(I);
Dm=Dm(I);
m0=m0(I);
[tau,vbar] = ChangeTauAndBarV(tau,v0,v1);

[a,aerror] = AptitudeGrouping(0,n);
frmax = polyval(a,vbar)+polyval(aerror,vbar);
fr=polyval(a,vbar);
frmin = polyval(a,vbar)-polyval(aerror,vbar);
str={'--k',':k'};
Ht=[];
Hv=[];

figure('name','predict time interval(tau)');
figure('name','predict finally velocity(v1)');
for kind=1:2
    [taupmin,v1pmax] = formulae(m0,Dm,v0,v1,v0,tau,frmax,kind);
    [taupmax,v1pmin] = formulae(m0,Dm,v0,v1,v1,tau,frmin,kind);
    [taup,v1p] = formulae(m0,Dm,v0,v1,vbar,tau,fr,kind);

    v0fit=[15.04:0.1:35]';
    % ---------------------------------predict tau------------------------
    if vtaufit == 1
         atmean=polyfit(v0,taup,n);
         taupfit=polyval(atmean,v0fit);

        atmax=polyfit(v0,taupmax,n);
        taupmaxfit=polyval(atmax,v0fit);

        atmin=polyfit(v0,taupmin,n);
        taupminfit=polyval(atmin,v0fit);
    else
        a0=100;
        tauf=inline('a./x','a','x');
    
        [atmean,resid2]=lsqcurvefit(tauf,a0,v0,taup);
        taupfit=tauf(atmean,v0fit);
        
        [atmax,resid2]=lsqcurvefit(tauf,a0,v0,taupmax);
        taupmaxfit=tauf(atmax,v0fit);
    
        [atmin,resid2]=lsqcurvefit(tauf,a0,v0,taupmin);
        taupminfit=tauf(atmin,v0fit);
    end
    
    figure(1)
    hold on
    hidt=fill([v0fit;flipud(v0fit)],[taupmaxfit;flipud(taupminfit)],'y');
    set(hidt,'EdgeColor','none');
    plot(v0,taup,'.k',v0,taupmax,'.r',v0,taupmin,'.b','markersize',5)

    ht=plot(v0fit,taupfit,  str{kind},...
           v0fit,taupmaxfit,str{kind},...
           v0fit,taupminfit,str{kind});
    Ht=[Ht ht];
    
    % ---------------------------------predict v1--------------------------
    avmean = polyfit(v0,v1p,n);
    v1pfit = polyval(avmean,v0fit);
    
    avmax = polyfit(v0,v1pmax,n);
    v1pmaxfit = polyval(avmax,v0fit);
    
    avmin = polyfit(v0,v1pmin,n);
    v1pminfit = polyval(avmin,v0fit);
    
    figure(2)
    hold on
    hidv = fill([v0fit;flipud(v0fit)],[v1pmaxfit;flipud(v1pminfit)],'y');
    set(hidv,'EdgeColor','none');
    plot(v0,v1p,'.k',v0,v1pmax,'.b',v0,v1pmin,'.b','markersize',5)

    hv = plot(v0fit,v1pfit,   str{kind},... 
             v0fit,v1pmaxfit,str{kind},...
             v0fit,v1pminfit,str{kind});
    Hv = [Hv hv];
end

figure(1)
h1t=plot(v0,tau,'.k','markersize',15);
h2t=plot([15:0.05:35],s./[15:0.05:35],'r');
legend([Ht(1,2),h2t,h1t],{'Second prediction','$S/v_0$',...
strcat('Actually data: ',num2str(length(v1)))},'Interpreter','latex')
xlim([15,35])
box on
ylabelstr = '$ \tau $ (s)';
if Vmmode==1
    ylabelstr = '$ \tau $ (s)';
else
    ylabelstr = strcat('$ \tau = 2s/(v_0+v^\prime)$(s)');
end
xlabel('$ v_0 $ (cm/s)','Interpreter','latex','fontsize',13);
ylabel(ylabelstr,'Interpreter','latex','fontsize',13)
gca1=gca;

%--------------------------------------------------------------------------
figure(2)
h1v = plot(v0,v1,'.k','markersize',15);
h2v = plot([15 35],[15,35],'r');% plot the line "v1=v0"
legend([Hv(1,:),h2v,h1v],{'First prediction','Second prediction',...
      '$v^\prime=v_0$',strcat('Actually data:',num2str(length(v1)))},...
      'Interpreter','latex',2)

xlim([15,35])
box on
xlabel('$ v_0 $ (cm/s)','Interpreter','latex','fontsize',13);
ylabel('$ v^\prime $ (cm/s)','Interpreter','latex','fontsize',13)

gca2=gca;