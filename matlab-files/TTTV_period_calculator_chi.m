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

function [ TTV_period, TTV_period_min, TTV_period_max ] = TTTV_period_calculator_chi( m0, m0_chi, m1, m1_chi, period, period_chi )
m0=m0*1047.56;
m0_chi=m0_chi*1047.56;

m0_min=m0-m0_chi*3;
m0_max=m0+m0_chi*3;
m1_min=m1-m1_chi*3;
m1_max=m1+m1_chi*3;


 m1_max=1.37;
 m1_min=0;

m2_min=0;
m2_max=m1;


if m0<0
    m0=0;
end

if m1<0
    m1=0;
end


TTV_period_min=(period-period_chi*3)/sqrt((27/4)*((m2_max+m1_max)/(m2_max+m1_max+m0_min)));
TTV_period_max=(period+period_chi*3)/sqrt((27/4)*((m2_min+m1_min)/(m2_min+m1_min+m0_max)));
TTV_period=period/sqrt((27/4)*(m1/(m1+m0)));
clc
sprintf('[%.4f, %.4f]',TTV_period_min,TTV_period_max)

end

