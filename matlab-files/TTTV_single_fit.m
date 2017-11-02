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

function [transit_orbit, OC]=TTTV_single_fit(planet_n, planet_OC, planet_OCe)
clc;

a=5.2;
J1=10;
fi=pi/2;         %%FASE, OFFSET


ymax=max(planet_OC)*1.1;
ymax=300;
ymin=-ymax;


z= 0.168*pi/180;  %%OFFSET
m2=11.762668771799827/7;       %%AMPLITUD
t_min=-3000;         %FASE
art_offset=7;


ratio=226;
TTV_period_paper=ratio;
m0=0.97;
m1=11.762668771799827;
period= 67.09342695;



fi_obs=pi;
lambda10=-pi/2;
ohm10=0;
g2=0;
%t_max=planet_n(length(planet_OC))*period+t_min-1;
t_max=period*2000+t_min;
NS_factor = 10;
OC_precision = 10;


m0=m0*1047.56;


[OC, transit_time, transit_orbit, time, Y1, Z1, Y1p, Z1p]=TTTV_Solver(a,J1,fi ,fi_obs,lambda10,ohm10,g2,m0,m1,m2,z,period,t_min, t_max, NS_factor, OC_precision);
[TTV_period, TTV_offset,TTV_amplitude,TTV_fase,TTV_fit, correl] = TTTV_real_fitting(transit_time, OC);


[thd_db,~,~] = thd(OC,(1/period), 2);
percent_thd = 100*(10^(thd_db/20));

% 
% figure(3);
% clf
% plot(planet_n, planet_OC,'.')
% hold on
% xlabel('Orbit number')
% ylabel('O-C [Minutes]')
% plot(transit_orbit, OC,'.r')
% legend('O-C Model','O-C Real data')
% plot(transit_orbit, OC,'black')
% 
% ylim([ymin ymax])
% xlim([0 planet_n(length(planet_OC))])

figure(1)
clf
plot((transit_orbit/(ratio/period))-round(transit_orbit/(ratio/period)), art_offset+OC,'.r')
hold on
plot((planet_n/(ratio/period))-round(planet_n/(ratio/period)),planet_OC,'.')
errbar((planet_n/(ratio/period))-round(planet_n/(ratio/period)),planet_OC,planet_OCe)

%errorbar((planet_n/(ratio/period))-round(planet_n/(ratio/period)),planet_OC,planet_OCe,'ok')

xlabel('Phase Curve')
ylabel('O-C [Minutes]')
legend('O-C Model','O-C Real data','O-C Real data error')
ylim([ymin ymax])
%xlim([min((planet_n/(ratio/period))-round(planet_n/(ratio/period))) max((planet_n/(ratio/period))-round(planet_n/(ratio/period)))])
xlim([-0.5 0.5])


% figure(2)
% plot(transit_orbit, OC)
% hold on;
% plot(transit_orbit, OC,'ro')
% plot(transit_orbit,sum(TTV_fit),'black');
% xlabel('Orbit number')
% ylabel('O-C [Minutes]')
% legend('O-C interpolation','O-C points',strcat('Fitting correlation: ',num2str(100*correl),'%'))
% 
% 


% subplot(4,1,4)
% [pxx1,w1]=periodogram(OC);
% 
% pxx1=pxx1/max(pxx1(4:length(pxx1)));
% pxx1=pxx1*TTV_amplitude(1);
% 
% w1=w1/(2*pi*period);
% plot(w1,pxx1)
% xlabel('Frequency [Days^-^1]')
% ylabel('Power [Minutes]')

clc

[chi2red] = TTTV_fit_chi2red( planet_n, planet_OC, planet_OCe, art_offset+OC );
fprintf(strcat('Fitting correlation: ',num2str(100*correl),'%'));
fprintf('\n---------------------------\n')
fprintf('AMPLITUDE\tPERIOD\t\tPERIOD ERROR\n')
fprintf('%f\t%f\t%f\n', TTV_amplitude(1), TTV_period(1), TTV_period(1)-TTV_period_paper)
fprintf('---------------------------\n')
fprintf('MODEL OFFSET\tPLANET OFFSET\tX2RED\n')
fprintf('%f\t\t%f\t\t%f\n', mean(OC)+art_offset, mean(planet_OC), chi2red)
fprintf('---------------------------\n')

end

