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

clc
clear

m1=2.45;
period=1.4857108;
TTV_period_paper=12.022;
m0=1.16;
m0_chi=0.06;

myfun = @(x, m1, period, TTV_period_paper) TTV_period_paper-period/sqrt((27/4)*(m1/(x*1047.56)));
fun= @(x)myfun(x, m1, period, TTV_period_paper);
m0_calc=fzero(fun, [m0-m0_chi*3 m0+m0_chi*3]);

disp('Masa calculada:')
disp(m0_calc);
disp('Masa mínima:')
disp(m0-m0_chi*3)
disp('Masa máxima:')
disp(m0+m0_chi*3)
disp('Masa media:')
disp((m0-m0_chi*3+m0+m0_chi*3)/2)
