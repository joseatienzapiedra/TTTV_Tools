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

function [chi2red] = TTTV_fit_chi2red( planet_n, planet_OC, planet_OCe, OC )
chi2=zeros;
i=2;
while i<= length(planet_n)
    
    chi2(i)=(((planet_OC(i))-OC(planet_n(i)))^2)/((planet_OCe(i)^2));
    
i=i+1;
end

chi2red= sum(chi2)/length(planet_n);
end

