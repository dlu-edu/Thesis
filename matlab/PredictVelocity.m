% PredictVelocity.m
% *********************************************
% This is main script to predict finally velocity.
% Zhou Lvwen:  zhou.lv.wen@gmail.com
clear;
disp('=========pridict  v1=========')
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

[v0,I] = sort(v0);
v1 = v1(I);
tau = tau(I);
Dm = Dm(I);
m0 = m0(I);

[tau,vbar] = ChangeTauAndBarV(tau,v0,v1);

[a,aerror] = AptitudeGrouping(0,n);
frmax = polyval(a,vbar)+polyval(aerror,vbar);
fr = polyval(a,vbar);
frmin = polyval(a,vbar)-polyval(aerror,vbar);
hold on
str={'--k',':k'};
H=[];
for i = 1:2
    for kind=1:2
        [taupmax,v1pmax] = formulae(m0,Dm,v0,v1,v0,tau,frmax,kind);
        [taupmin,v1pmin] = formulae(m0,Dm,v0,v1,v1,tau,frmin,kind);
        [taup,v1p] = formulae(m0,Dm,v0,v1,s./tau,tau,fr,kind);
    
        v0fit = [15.04:0.1:35]';
    
        amean = polyfit(v0,v1p,n);
        v1pfit = polyval(amean,v0fit);
    
        amax = polyfit(v0,v1pmax,n);
        v1pmaxfit = polyval(amax,v0fit);
    
        amin = polyfit(v0,v1pmin,n);
        v1pminfit = polyval(amin,v0fit);
   
        figure(i);
        hold on
        hid = fill([v0fit;flipud(v0fit)],[v1pmaxfit;flipud(v1pminfit)],'y');
        set(hid,'EdgeColor','none');
        if i == 1
            plot(v0,v1p,'.k',v0,v1pmax,'.r',v0,v1pmin,'.b','markersize',5);
            MatDeg = MatchDegree(v0,v1,amean);
            RelErr = RelativeError(v0,v1,amean);
            fprintf(1,strcat('\n*******',num2str(kind),'th pridiction*******\n'));
            fprintf(1,'Match Degree: %f\n',MatDeg);
            fprintf(1,'Relative Error: %f %%\n',RelErr*100);
        end
        h = plot(v0fit,v1pfit,   str{kind},...
                 v0fit,v1pmaxfit,str{kind},...
                 v0fit,v1pminfit,str{kind});
        H = [H h];
    end

    if i ==1
        legend(H(1,:),{'First prediction','Second prediction'},'Interpreter','latex',2);
    else
        h1 = plot(v0,v1,'.k','markersize',15);
        h2 = plot([15 35],[15,35],'r');% plot the line "v1=v0"
        legend([H(1,3:4),h2,h1],{'First prediction','Second prediction','$v^\prime=v_0$',...
        strcat('Actually data: ',num2str(length(v1)))},'Interpreter','latex',2);
    end
    xlim([15,35])
    box on
    xlabel('$ v_0 $ (cm/s)','Interpreter','latex','fontsize',13);
    ylabel('$ v^\prime $ (cm/s)','Interpreter','latex','fontsize',13);
end
