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

function [Y1,Z1, zeta] = Y1Z1_Solver(a,J1,fi,fi_obs,lambda10,ohm10,g2,m0,m1,m2,z,zeta_0,n,t)


v=n*sqrt((27/4)*((m1+m2)/(m0+m1+m2)));
delta=m2/(m1+m2);

zeta= (pi/3)+(pi*sqrt(3)/8)*z*z+(1-sqrt(3)*z/4)*z*cos(v*t-fi)-(sqrt(3)/8)*z*z*cos(2*v*t-2*fi);

Y1=-a*sin(J1)*sin(fi_obs)*sin(lambda10-ohm10-g2*t+n*t+delta*zeta-delta*zeta_0)...
    +a*cos(fi_obs)*cos(lambda10-ohm10-g2*t+n*t+delta*zeta-delta*zeta_0)*sin(ohm10+g2*t)...
    +cos(J1)*cos(ohm10+g2*t)*sin(lambda10-ohm10-g2*t+n*t+delta*zeta-delta*zeta_0);

Z1=a*(cos(lambda10-ohm10-g2*t+n*t+delta*zeta-delta*zeta_0)*sin(fi_obs)*sin(ohm10+g2*t)...
    +(cos(fi_obs)*sin(J1)+cos(J1)*cos(ohm10+g2*t)*sin(fi_obs))*sin(lambda10-ohm10-g2*t+n*t+delta*zeta-delta*zeta_0));
end