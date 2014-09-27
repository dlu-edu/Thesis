% MatchDegree.m
% *********************************************
% This function to compute the match degree between (xi,yi) and carve y =
% f(x) .  f(x)=poly(a);
% Zhou Lvwen:  zhou.lv.wen@gmail.com

function r = MatchDegree(xi,yi,a)
x = mean(xi);
y = mean(yi);

fx = polyval(a,xi);
fy = subs(finverse(poly2sym(a)),yi);

rx = sum((yi-y).*(fy-x))/sqrt(sum((yi-y).^2)*sum((fy-x).^2));
ry = sum((fx-y).*(xi-x))/sqrt(sum((fx-y).^2)*sum((xi-x).^2));
r = sqrt(rx*ry);


