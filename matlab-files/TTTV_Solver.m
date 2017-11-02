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


function [OC, transit_time, transit_orbit, time, Y1, Z1, Y1p, Z1p] = TTTV_Solver(a,J1,fi ,fi_obs,lambda10,ohm10,g2,m0,m1,m2,z,period,t_min, t_max, NS_factor, OC_precision)
i=t_min;
j=1;
k=1;
l=1;

n=2*pi/period;
sample_time=period/NS_factor; %Nyquist-Shannon factor. 
delta=m2/(m1+m2);
zeta_0=(pi/3)+(pi*sqrt(3)/8)*z*z+(1-sqrt(3)*z/4)*z*cos(-fi)-(sqrt(3)/8)*z*z*cos(-2*fi);

time(:,1)=zeros;
transit_time(:,1)=zeros;
transit_orbit=zeros;

Y1p(:,1)=zeros;
Z1p(:,1)=zeros;
t_ip(:,1)=zeros;
zetap(:,1)=zeros;

Y1(:,1)=zeros;
Z1(:,1)=zeros;
t_i(:,1)=zeros;
zeta(:,1)=zeros;


while t_min<=i&&i<=t_max
    
    [Y1p(j),Z1p(j), zetap(j)]=Y1Z1_Solver(a,J1,fi, fi_obs,lambda10,ohm10,g2,m0,m1,m2,z, zeta_0,n,i);
    [Y1(j),Z1(j),zeta(j)]=Y1Z1_Solver(a,J1, fi, fi_obs,lambda10,ohm10,g2,m0,m1,0, z, zeta_0,n,i);
    
    if j>1
    if (Y1p(j)/Y1p(j-1)<0 || Y1p(j)/Y1p(j-1)==Inf || Y1p(j)/Y1p(j-1)==-Inf)&& Z1p(j)<0

        zeta=zetap(j);
        myfunY1p = @(a,J1,fi_obs,lambda10,ohm10,g2,delta, zeta,zeta_0,n,t) -a*sin(J1)*sin(fi_obs)*sin(lambda10-ohm10-g2*t+n*t+delta*zeta-delta*zeta_0)...
            +a*cos(fi_obs)*cos(lambda10-ohm10-g2*t+n*t+delta*zeta-delta*zeta_0)*sin(ohm10+g2*t)...
            +cos(J1)*cos(ohm10+g2*t)*sin(lambda10-ohm10-g2*t+n*t+delta*zeta-delta*zeta_0);
        
        funY1p= @(t) myfunY1p(a,J1,fi_obs,lambda10,ohm10,g2,delta, zeta,zeta_0,n,t);
        t_ip(k)=fzero(funY1p, [i+sample_time i-2*sample_time]);
        
        %t_ip(k)=mean([i i-sample_time]);

        k=k+1;
    end
    
    if (Y1(j)/Y1(j-1)<0 || Y1(j)/Y1(j-1)==Inf || Y1(j)/Y1(j-1)==-Inf)&& Z1(j)<0
        
        zeta=zetap(j);
        myfunY1 = @(a,J1,fi_obs,lambda10,ohm10,g2,n,t) -a*sin(J1)*sin(fi_obs)*sin(lambda10-ohm10-g2*t+n*t)...
            +a*cos(fi_obs)*cos(lambda10-ohm10-g2*t+n*t)*sin(ohm10+g2*t)...
            +cos(J1)*cos(ohm10+g2*t)*sin(lambda10-ohm10-g2*t+n*t);
        
        funY1= @(t) myfunY1(a,J1,fi_obs,lambda10,ohm10,g2,n,t);
        t_i(l)=fzero(funY1, [i+sample_time i-2*sample_time]);
        
        %t_i(l)=mean([i i-sample_time]);
        transit_time(l)=t_ip(l);
        transit_orbit(l)=l;                   

        l=l+1;
    end
    end
    
    time(j)=i;
    i=i+sample_time;
    j=j+1;
end

if length(t_ip)>length(t_i)
    t_ip=t_ip(1:length(t_i));
elseif length(t_ip)<length(t_i)
    t_i=t_i(1:length(t_ip));
end

OC=t_ip-t_i;
OC=1440*round(OC*10^OC_precision)/10^OC_precision;
end

