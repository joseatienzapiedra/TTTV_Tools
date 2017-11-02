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

function [ m1 ] = pm_fit( period, TTV_period, m0, mass_ratio )

m0=m0*1047.56;

myfun = @(m1, m0, period, TTV_period)  period/sqrt((27/4)*((m1+(m1/mass_ratio))/(m0+m1+(m1/mass_ratio))))- TTV_period;
fun= @(m1) myfun(m1, m0, period, TTV_period);
m1=fzero(fun, [0.000001 1000]);



end

