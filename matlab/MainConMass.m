% MainConMass.m
% *********************************************
% This is main script to plot the figure of average velocity vs average
% resistance(fr)(For three constant mass(392.6g, 322.8g and 223.0g) systems)
% Zhou Lvwen:  zhou.lv.wen@gmail.com

global deduce Vmmode
n = 2; % polyfit degree
Vmmode = 2;
deduce = 1;

xls='DataOfConstantMass';
M = [392.6,322.8,223.0];
sheet={'392.6','322.8','223.0'};
ifplot = 1;% plot or not
for i=1:3
    figure
    [v1,v2,avgv,avgfr,error]=AvgVvsFrConMass(xls,sheet{i},M(i),ifplot,n);
end