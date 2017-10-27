function [] = unkown_pm_TTV_period_calc(m0, m0_chi, po, po_chi)


m0=m0-m0_chi*3;
po=po-po_chi*3;

mj=1/1047.56;
mu=1/(1+(m0/(2*13*mj)));

TTV_period_max=po/sqrt((27/4)*(0));
TTV_period_min=po/sqrt((27/4)*(mu));
clc
sprintf('[%.0f, %.0f]',TTV_period_min,TTV_period_max)

end

