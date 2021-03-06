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

function []=PlanetMassCalculator_old (m0, m0_sigma_up, m0_sigma_down,period, period_sigma_up, period_sigma_down, TTV_period, TTV_period_sigma_up, TTV_period_sigma_down)
clc;

m0_up=(m0+3*m0_sigma_up)*1047.56;
m0_down=(m0-3*m0_sigma_down)*1047.56;
m0=m0*1047.56;

period_up=period+3*period_sigma_up;
period_down=period-3*period_sigma_down;

TTV_period_up=TTV_period+3*TTV_period_sigma_up;
TTV_period_down=TTV_period-3*TTV_period_sigma_down;


myfun = @(m1, m0, period, TTV_period)  period/sqrt((27/4)*((m1+(m1/30))/(m0+m1+(m1/30))))- TTV_period;
fun= @(m1) myfun(m1, m0, period, TTV_period);
m1=fzero(fun, [0.0001 100]);

myfun = @(m1, m0_up, period_up, TTV_period_down)  period_up/sqrt((27/4)*((m1+(m1/1000))/(m0_up+m1+(m1/1000))))- TTV_period_down;
fun= @(m1) myfun(m1, m0_up, period_up, TTV_period_down);
m1_up=fzero(fun, [0.0001 100]);

myfun = @(m1, m0_down, period_down, TTV_period_up)  period_down/sqrt((27/4)*((m1+(m1))/(m0_down+m1+(m1))))- TTV_period_up;
fun= @(m1) myfun(m1, m0_down, period_down, TTV_period_up);
m1_down=fzero(fun, [0.0001 100]);


fprintf('M1\t\t\t\n')
fprintf('%f\t+%f\t-%f\n',m1, m1_up-m1, m1-m1_down)

end