function [ m1 ] = pm_fit( period, TTV_period, m0, mass_ratio )

m0=m0*1047.56;

myfun = @(m1, m0, period, TTV_period)  period/sqrt((27/4)*((m1+(m1/mass_ratio))/(m0+m1+(m1/mass_ratio))))- TTV_period;
fun= @(m1) myfun(m1, m0, period, TTV_period);
m1=fzero(fun, [0.000001 1000]);



end

