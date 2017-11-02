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

