% formulae.m
% *********************************************
% This function to present disparate predicton from two equations of
% dynamics: 
%           -fr=d(mv)/dt   and  -fr=m(t)dm/dt 
% The prediction deduce by lou: deduce==1, by zhou: deduce==2; 
% Zhou Lvwen:  zhou.lv.wen@gmail.com

function [taup,v1p] = formulae(m0,Dm,v0,v1,v,tau,fr,kind)
global deduce

if deduce==1
    F = fr+(kind==2)*100./tau.*Dm./tau;
    taup = (m0.*v0-(m0-Dm).*v1)./F;
    v1p = v0 + (Dm.*v0-F.*tau)./(m0-Dm);
else
    vdm = (kind==2)*v.*Dm;
    taup = (m0.*v0-(m0-Dm).*v1-vdm)./fr;
    v1p = (m0.*v0-fr.*tau-vdm)./(m0-Dm);
end
