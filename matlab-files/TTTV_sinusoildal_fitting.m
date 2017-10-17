
%  * Copyright (c) 2017 Jose Atiemza Piedra - All rights reserved.
%  * <www.joseatienza.com> <joseatienzapiedra@gmail.com>
%  *
%  * This file is part of TROY TTTV TOOLS 
%  * And:  https://github.com/joseatienzapiedra/TTTV_Tools
%  *
%  * TROY TTTV TOOLS is free software: you can redistribute it and/or modify
%  * it under the terms of the GNU General Public License as published by
%  * the Free Software Foundation, either version 3 of the License, or
%  * (at your option) any later version.
%  *
%  * TROY TTTV TOOLS is distributed in the hope that it will be useful,
%  * but WITHOUT ANY WARRANTY; without even the implied warranty of
%  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  * GNU General Public License for more details. <http://www.gnu.org/licenses/>.

function [TTV_period, TTV_offset,TTV_amplitude,TTV_fase,TTV_fit]=TTTV_sinusoildal_fitting (transit_time, OC)

transit_time_difer(:,1)=zeros;
err(:,1)=zeros;

for i_OC_aux = 1:length(transit_time)-1
    transit_time_difer(i_OC_aux)=transit_time(i_OC_aux+1)-transit_time(i_OC_aux);
end


TTV_offset=(max(OC)+min(OC))*0.5;
TTV_amplitude=max(OC)-(max(OC)+min(OC))*0.5;
TTV_fase=0;
TTV_period=0;

correl=[1 1];
TTV_fit=0*OC;

if TTV_amplitude~=0
    [~,~,harmfreq] = thd(OC,(1/mean(transit_time_difer)), 10);
    TTV_period=1/harmfreq(1);
    TTV_fase=atan2((TTV_period*0.25),OC(1)-TTV_offset);
    
    Aux_flag=1;
    j=2;
    while Aux_flag
        
        
        TTV_fit=TTV_offset*1.0001+TTV_amplitude*sin(TTV_fase+transit_time*2*pi/TTV_period);
        correl1=corrcoef(TTV_fit,OC);
        
        TTV_fit=TTV_offset*0.9999+TTV_amplitude*sin(TTV_fase+transit_time*2*pi/TTV_period);
        correl2=corrcoef(TTV_fit,OC);
        
        if abs(1-correl1(2))> abs(1-correl2(2))
            TTV_offset=TTV_offset*1.0001;
            correl(j)=correl1(2);
        elseif abs(1-correl1(2)) <= abs(1-correl2(2))
            TTV_offset=TTV_offset*0.9999;
            correl(j)=correl2(2);
        end
        if (round(correl(j)*10000)/10000) == (round(correl(j-1)*10000)/10000)
            Aux_flag=0;
            TTV_fit=TTV_offset+TTV_amplitude*sin(TTV_fase+transit_time*2*pi/TTV_period);
        end
        
        j=j+1;
    end
    
    disp('OFFSET OK');
    
    
    Aux_flag=1;
    j=2;
    while Aux_flag
        
        TTV_fit=TTV_offset+TTV_amplitude*1.000001*sin(TTV_fase+transit_time*2*pi/TTV_period);
        err1=abs((max(OC)-(max(OC)+min(OC))*0.5)-(max(TTV_fit)-(max(TTV_fit)+min(TTV_fit))*0.5));
        
        TTV_fit=TTV_offset+TTV_amplitude*0.999999*sin(TTV_fase+transit_time*2*pi/TTV_period);
        err2=abs((max(OC)-(max(OC)+min(OC))*0.5)-(max(TTV_fit)-(max(TTV_fit)+min(TTV_fit))*0.5));
        
        if err2 >= err1
            TTV_amplitude=TTV_amplitude*1.000001;
            err(j)=err1;
        elseif err2 < err1
            TTV_amplitude=TTV_amplitude*0.999999;
            err(j)=err2;
        end       

    
        if ((round(err(j)*10000)/10000) == (round(err(j-1)*10000)/10000) || err(j)<0.01) && abs(1-(TTV_amplitude/(max(OC)-(max(OC)+min(OC))*0.5))) <0.01
            Aux_flag=0;
            
            TTV_fit=TTV_offset+TTV_amplitude*sin(TTV_fase+transit_time*2*pi/TTV_period);
        end
        
        j=j+1;
    end
    
    disp('AMPLITUDE OK');

OC_aux=OC-TTV_offset;
OC_aux=OC_aux/TTV_amplitude;

if(OC_aux(1)>0 && OC_aux(2)>0)
    if OC_aux(1) < OC_aux(2)
        %b
        fase_min=0;
        fase_max=90;
    elseif OC_aux(1) == OC_aux(2)
        %c
        fase_min=80;
        fase_max=100;
    elseif OC_aux(1) > OC_aux(2)
        %d
        fase_min=90;
        fase_max=180;
    end
elseif (OC_aux(2)<0 && OC_aux(1)<0)
    if OC_aux(1) > OC_aux(2)
        %f
        fase_min=180;
        fase_max=270;
    elseif OC_aux(1) == OC_aux(2)
        %g
        fase_min=260;
        fase_max=280;
    elseif OC_aux(1) < OC_aux(2)
        %h
        fase_min=270;
        fase_max=360;
    end
elseif (OC_aux(1)/OC_aux(2))<0
    if OC_aux(2)>OC_aux(1)
        %a
        fase_min=-10;
        fase_max=10;
    elseif OC_aux(2) < OC_aux(1)
        %e
        fase_min=170;
        fase_max=190;
    end
end

TTV_fase=mean(fase_min, fase_max);

TTV_fase=TTV_fase*pi/180;
fase_min=fase_min*pi/180;
fase_max=fase_max*pi/180;


err(1,:)=zeros;
Aux_flag=1;
j=2;
while Aux_flag
    
    
    TTV_fit=sin(TTV_fase+0.00001+transit_time*2*pi/TTV_period);
    err1=abs(TTV_fit(1)-OC_aux(1));

    TTV_fit=sin(TTV_fase-0.00001+transit_time*2*pi/TTV_period);
    err2=abs(TTV_fit(1)-OC_aux(1));
    
    if (err2 > err1) && (TTV_fase+0.00001 < fase_max)
        TTV_fase=TTV_fase+0.00001;
        err(j)=err1;
    elseif (err2 < err1) && (TTV_fase-0.00001 > fase_min)
        TTV_fase=TTV_fase-0.00001;
        err(j)=err2;
    end
    
    if ((round(err(j)*10000)/10000) == (round(err(j-1)*10000)/10000)) && err(j)<0.0001
        Aux_flag=0;
        TTV_fit=TTV_offset+TTV_amplitude*sin(TTV_fase+transit_time*2*pi/TTV_period);
    end
    
    j=j+1;
end
    
    disp('PHASE OK');

fprintf('\n');

end
