%  * Copyright (c) 2017 Jose Atiemza Piedra - All rights reserved.
%  * <www.joseatienza.com> <joseatienzapiedra@gmail.com>
%  *
%  * This file is part of TTTV TOOLS
%  * And:  https://github.com/joseatienzapiedra/TTTV_Tools
%  *
%  * TTTV TOOLS is free software: you can redistribute it and/or modify
%  * it under the terms of the GNU General Public License as published by
%  * the Free Software Foundation, either version 3 of the License, or
%  * (at your option) any later version.
%  *
%  * TTTV TOOLS is distributed in the hope that it will be useful,
%  * but WITHOUT ANY WARRANTY; without even the implied warranty of
%  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  * GNU General Public License for more details. <http://www.gnu.org/licenses/>.

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

