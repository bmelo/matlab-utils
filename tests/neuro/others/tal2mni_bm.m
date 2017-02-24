function out = tal2mni_bm(input_m)
x = input_m(1);
y = input_m(2);
z = input_m(3);
a=0.99;
b=0.9688;
c=0.0460;
d=-0.0485;
e=0.9189;
f=0.0420;
g=0.8390;

if (z-d*y)/e >= 0
  xm = round(x/a);
  ym = round((e*y)/(b*e-c*d) - (c*z)/(b*e-c*d));
  zm = round((z/e) - (d/e)*((e*y-c*z)/(b*e-c*d)));
else
  xm = round(x/a);
  ym = round((e*y)/(b*e-f*d) - (f*z)/(b*e-f*d));
  zm = round((z/g) - (d/g)*((e*y-c*z)/(b*e-c*d)));
end
out = [xm ym zm]