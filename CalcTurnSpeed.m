r = 0.25;
y = 19;

dx = 0.125;
xn1 = (0:19)*8;
xn2 = (0:19);

t1 = [0  , 108, 160, 194, 216, 234, 250, 262, 272, 280, 290, 298, 308, 312, 318, 324, 330, 336, 340, 346];
t2 = [0  , 0  , 0  , 34 , 56 , 76 , 88 , 102, 112, 120, 130, 136, 142, 148, 154, 160, 166, 170, 174, 178];

xn = xn1;
t = t1;

x = xn .* dx;
l = sqrt(x.*x + y.*y);
degree_center = atan(x ./ y) ./ pi * 180;
degree_edge   = asin(r ./ l) ./ pi * 180;
degree = degree_center - degree_edge;
degree(degree < 0) = 0;

Kt = log(degree_center ./ degree_edge);
Kt(Kt < 0) = 0;

K = Kt ./ t;

K0 = 1/ 80;
% K0 = 0.013;

t0 = Kt/K0;
plot(t0);
hold on;
plot(t);
hold off;