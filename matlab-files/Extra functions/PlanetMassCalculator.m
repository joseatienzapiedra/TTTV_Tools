function [] = planet_mass_calculator(m0, m0_sigma_up, m0_sigma_down,period, period_sigma_up, period_sigma_down, TTV_period, TTV_period_sigma_up, TTV_period_sigma_down)
clc;
m0_up=(m0+3*m0_sigma_up)*1047.56;
m0_down=(m0-3*m0_sigma_down)*1047.56;

period_up=period+3*period_sigma_up;
period_down=period-3*period_sigma_down;

TTV_period_up=TTV_period+3*TTV_period_sigma_up;
TTV_period_down=TTV_period-3*TTV_period_sigma_down;

mu_min=0;
mu_max= 1/(1+(m0_down/(26)));


mu=((period^2)/(TTV_period^2))*(4/27);
mu_down=((period_down^2)/(TTV_period_up^2))*(4/27);
mu_up=((period_up^2)/(TTV_period_down^2))*(4/27);

mu_aux=max(mu_up, mu_down);
mu_down=min(mu_up, mu_down);
mu_up=mu_aux;

m2_down=0;

m1_up=(m0_down*mu_up/(2*(1-mu_up)));
m1_down=(m0_down*mu_down/(1-mu_down))+m2_down;
m1_mean=(m1_up+m1_down)/2;

m1_aux=max(m1_up, m1_down);
m1_down=min(m1_up, m1_down);
m1_up=m1_aux;


if mu_min<=mu_down&&mu_down<=mu_max || mu_min<=mu&&mu<=mu_max || mu_min<=mu_up&&mu_up<=mu_max
    
    disp('Compatible Planet Mass found:')
else
    disp('Impossible to find a compatible Planet Mass:')
    
end

 fprintf('%f\t+%f\t-%f\n', m1_mean,m1_up-m1_mean,m1_mean-m1_down)

 
end

