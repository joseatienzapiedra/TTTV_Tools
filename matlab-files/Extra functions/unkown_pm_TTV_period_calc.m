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

