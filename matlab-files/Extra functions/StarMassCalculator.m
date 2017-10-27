function [] = StarMassCalculator( log_g, log_g_low_sigma, R, R_low_sigma)
clc

R_upper_sigma=R_low_sigma;
log_g_upper_sigma=log_g_low_sigma;

log_g_sun = 4.44;
M_sun=1;
R_sun=1;
M=10^(log_g+2*log10(R)+log10(M_sun)-log_g_sun-2*log10(R_sun));

log_dflogg=1;
log_dfR= (2/(R*log(10)));

log_sigma_m=sqrt(((log_dflogg*log_g_upper_sigma)^2)+((log_dfR*R_upper_sigma)^2));

M_upper_sigma=(10^(log10(M)+log_sigma_m))-M;
M_low_sigma=M-10^(log10(M)-log_sigma_m);

disp('MEAN:');
disp(M);
disp('UPPER SIGMA:');
fprintf('+%.2f\n',M_upper_sigma)
disp('LOW SIGMA:');
fprintf('-%.2f\n',M_low_sigma)

end

