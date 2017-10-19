
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

function [ TTV_period, TTV_offset,TTV_amplitude,TTV_fase,TTV_fit, correl] = TTTV_real_fitting(transit_time, OC)

disp('FUNDAMENTAL FITTING')
disp('-------------------')
[TTV_period(1), TTV_offset(1),TTV_amplitude(1),TTV_fase(1),TTV_fit(1,:)]=TTTV_sinusoildal_fitting (transit_time, OC,OC*0, 1);

disp('HARMONIC FITTING')
disp('----------------')
[TTV_period(2), TTV_offset(2),TTV_amplitude(2),TTV_fase(2),TTV_fit(2,:)]=TTTV_sinusoildal_fitting (transit_time, OC, TTV_fit(1,:), 2);

%TTV_fit(2,:)=TTV_fit(2,:)*0;

corr_matrix=corrcoef(sum(TTV_fit),OC);
correl=corr_matrix(2);

if isnan(correl)
    correl=1;
end

end