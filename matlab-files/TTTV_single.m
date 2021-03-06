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

% a=1;               % Semi-major axis
% J1=10;             % Inclination of planet's orbit with respect to the invariant plane
% fi=pi;             %
% fi_obs=-pi/2;      %
% lambda10=-pi/2;    % (Fixed lambda10=-pi/2)
% ohm10=0;           % Argument of the line of nodes of the planet (lambda10 = U(-pi, pi))
% g2=0;              % Precession frequency of the trojan (Fixed g2=0)
% m0=1;              % Mass of the Star in Sun masses
% m1=1;              % Mass of the Planet in Jupiter masses
% m2=0.0035;         % Mass of the Trojan in Jupiter masses
% z= 20*pi/180;      %
% period= 400;       % Planet Orbital Period (Days)
% t_min=1;           % TTV test start time (usually t_min=1)
% t_max=4000;        % TTV test end time (~10*period)
% NS_factor = 10;    % Nyquist-Shannon sampling factor. (NS_factor>=2;)
% OC_precision = 10; % Order of magnitude of the calculation precision of O-C (10~12)

function [transit_time, OC, TTV_period, TTV_offset,TTV_amplitude,TTV_fase,TTV_fit, percent_thd, correl]=TTTV_single()
clc;
close all;

a=5.2;
J1=10;
fi=pi/2;
fi_obs=pi/2;
lambda10=-pi/2;
ohm10=0;
g2=0;
m0=1;
m1=1;
m2=0.003;
z= 1*pi/180;
period= 400;
t_min=1;
t_max=200*period;
NS_factor = 10;
OC_precision = 10;


m0=1.21;
m1=0.062638002218427;
period= 17.83365704;
z= 5*pi/180;  %%OFFSET
m2=0.062638002218427/30;       %%AMPLITUD




m0=m0*1047.56;


[OC, transit_time, transit_orbit, time, Y1, Z1, Y1p, Z1p]=TTTV_Solver(a,J1,fi ,fi_obs,lambda10,ohm10,g2,m0,m1,m2,z,period,t_min, t_max, NS_factor, OC_precision);
[TTV_period, TTV_offset,TTV_amplitude,TTV_fase,TTV_fit, correl] = TTTV_real_fitting(transit_time, OC);



[thd_db,~,~] = thd(OC,(1/period), 2);
percent_thd = 100*(10^(thd_db/20));

figure(2);
subplot(4,1,1);
plot(time, Y1p)
hold on;
plot(time, Y1,'r')
xlabel('Time [Days]')
ylabel('Distance from Oxyz [AU]')
legend('Y1p','Y1')

subplot(4,1,2);
plot(time, Z1p)
hold on;
plot(time, Z1,'r')
xlabel('Time [Days]')
ylabel('Distance from Oxyz [AU]')
legend('Z1p','Z1')

subplot(4,1,3)
plot(transit_orbit, OC)
hold on;
plot(transit_orbit, OC,'ro')
plot(transit_orbit,sum(TTV_fit),'black');
xlabel('Orbit number')
ylabel('O-C [Minutes]')
legend('O-C interpolation','O-C points',strcat('Fitting correlation: ',num2str(100*correl),'%'))





subplot(4,1,4)
[pxx1,w1]=periodogram(OC);

pxx1=pxx1/max(pxx1);
pxx1=pxx1*TTV_amplitude(1);

w1=w1/(2*pi*period);
plot(w1,pxx1)
xlabel('Frequency [Days^-^1]')
ylabel('Power [Minutes]')

figure(1)

plot(transit_orbit, OC)
hold on;
plot(transit_orbit, OC,'ro')
plot(transit_orbit,sum(TTV_fit),'black');
xlabel('Orbit number')
ylabel('O-C [Minutes]')
legend('O-C interpolation','O-C points',strcat('Fitting correlation: ',num2str(100*round(correl)),'%'))




end

