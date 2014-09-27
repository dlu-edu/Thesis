function RelErr = RelativeError(xi,yi,a)
yip = polyval(a,xi);
Err = (yi-yip);
RelErr = mean(Err./yi);
