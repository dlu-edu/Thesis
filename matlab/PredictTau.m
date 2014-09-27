% PredictTau.m
% *********************************************
% This is main script to predict time interval.
% Zhou Lvwen:  zhou.lv.wen@gmail.com
clear;
disp('=========pridict tau=========')
global deduce Vmmode
n = 1;% polyfit degree
vtaufit = 1; % vtaufit==1 for 'tau = a*v0+b'; vtaufit == 2 for 'tau = a/v0' 
Vmmode = 1;  % Vmmode = 1 for vbar = s/tau;
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
H=[];
for i=1:2
    for kind=1:2
        [taupmax,v1pmax] = formulae(m0,Dm,v0,v1,v0,tau,frmax,kind);
        [taupmin,v1pmin] = formulae(m0,Dm,v0,v1,v1,tau,frmin,kind);
        [taup,v1p] = formulae(m0,Dm,v0,v1,vbar,tau,fr,kind);
                    
        v1fit=[15.04:0.1:35]';
        if vtaufit == 1
            amean=polyfit(v0,taup,n);
            taupfit=polyval(amean,v1fit);

            amax=polyfit(v0,taupmax,n);
            taupmaxfit=polyval(amax,v1fit);

            amin=polyfit(v0,taupmin,n);
            taupminfit=polyval(amin,v1fit);
        else
            a0=100;
            tauf=inline('a./x','a','x');
    
            [amean,resid2]=lsqcurvefit(tauf,a0,v0,taup);
            taupfit=tauf(amean,v1fit);
        
            [amax,resid2]=lsqcurvefit(tauf,a0,v0,taupmax);
            taupmaxfit=tauf(amax,v1fit);
    
            [amin,resid2]=lsqcurvefit(tauf,a0,v0,taupmin);
            taupminfit=tauf(amin,v1fit);
        end
        figure(i);
        hold on
        hid=fill([v1fit;flipud(v1fit)],[taupmaxfit;flipud(taupminfit)],'y');
        set(hid,'EdgeColor','none');
        
        h=plot(v1fit,taupfit,   str{kind},...
               v1fit,taupmaxfit,str{kind},...
               v1fit,taupminfit,str{kind});
        if i ==1
            plot(v0,taup,'.k',v0,taupmax,'.r',v0,taupmin,'.b','markersize',5)
            MatDeg = MatchDegree(v0,tau,amean);
            RelErr = RelativeError(v0,tau,amean);
            fprintf(1,strcat('\n*******',num2str(kind),'th pridiction*******\n'));
            fprintf(1,'Match Degree: %f\n',MatDeg);
            fprintf(1,'Relative Error: %f %%\n',RelErr*100);
        end
        H=[H h];
    end

    if i ==1
        legend(H(1,:),{'First prediction','Second prediction'},...
                       'Interpreter','latex');
    else
        h1=plot(v0,tau,'.k','markersize',15);
        h2=plot([15:0.05:35],s./[15:0.05:35],'r');
        legend([H(1,3:4),h2,h1],{'First prediction','Second prediction','$s/v_0$',...
        strcat('Actually data: ',num2str(length(v1)))},'Interpreter','latex');
    end
    xlim([15,35]);
    box on
    ylabelstr = '$ \tau $ (s)';
    if Vmmode==1
        ylabelstr = '$ \tau $ (s)';
    else
        ylabelstr = strcat('$ \tau = 2s/(v_0+v^\prime)$(s)');
    end
    xlabel('$ v_0 $ (cm/s)','Interpreter','latex','fontsize',13);
    ylabel(ylabelstr,'Interpreter','latex','fontsize',13)
end
