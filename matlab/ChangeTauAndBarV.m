% ChangeTauAndBarV.m
% *********************************************
% This function to redefine average velocity(vbar) and time interval(tau).
% Zhou Lvwen:  zhou.lv.wen@gmail.com

function [Tau,vbar] = ChangeTauAndBarV(tau,v0,v1)
global deduce Vmmode
s = 100;
if Vmmode==1&deduce==1
    vbar = s./tau;
    Tau = tau;
elseif Vmmode==2&deduce==1
    vbar = (v0+v1)./2;
    Tau = s./vbar;
elseif Vmmode==1&deduce==2
    vbar = s./tau;
    Tau = tau;
elseif Vmmode==2&deduce==2
    vbar = (v0+v1)./2;
    Tau = tau;
end
    