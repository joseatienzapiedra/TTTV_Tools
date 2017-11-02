function [] = TTTV_OC2Period( OC, period)
clc;
[thd_db,harmpow,harmfreq] = thd(OC,1/period,4);



fprintf('THD: %f %%\n\n',100*(10^(thd_db/20)))
fprintf('Period[Days]\tPower[db]\n');
fprintf('%.0f\t\t\t%f\n',1/harmfreq(1), harmpow(1));
fprintf('%.0f\t\t\t%f\n',1/harmfreq(2), harmpow(2));
fprintf('%.0f\t\t\t%f\n',1/harmfreq(3), harmpow(3));
fprintf('%.0f\t\t\t%f\n',1/harmfreq(4), harmpow(4));




end

