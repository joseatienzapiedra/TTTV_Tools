
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

clc;
clear all;
close all;
sweep_parameter=zeros;
TTV_period=zeros(2,2);
TTV_offset=zeros(2,2);
TTV_amplitude=zeros(2,2);
TTV_fase=zeros(2,2);
correl_vector=zeros;
iteration_time=zeros;
percent_thd=zeros;

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
% z= 20*pi/180;      % z(0º,40º)
% period= 400;       % Planet Orbital Period (Days)
% t_min=1;           % TTV test start time (usually t_min=1)
% t_max=4000;        % TTV test end time (~10*period)
% NS_factor = 10;    % Nyquist-Shannon sampling factor. (NS_factor>=2;)
% OC_precision = 10; % Order of magnitude of the calculation precision of O-C (10~12)

a=100;
lambda10=-pi/2;
g2=0;
J1=10;
ohm10=0;
fi_obs=pi/2;

m0=1;
m1=1;
m2=0.0035;
z= 1*pi/180;
period= 400;

fi=pi/2;

t_min=10;
t_max=200*period;
NS_factor = 10;
OC_precision = 10;
m0=m0*1047.56; 

sweep_parameter(1)=0.0;       %Sweep Parameter min value
sweep_step=5;              %Sweep Parameter step
sweep_max=359;                  %Sweep Parameter max value

%Sweep Parameter label

%sweep_parameter_label='Trojan Mass [Jupiter masses]';   
%sweep_parameter_label='Planet Mass [Jupiter masses]'; 
%sweep_parameter_label='Star Mass [Sun masses]'; 
%sweep_parameter_label='z [º]'; 
%sweep_parameter_label='J1, Inclination [º]'; %?????
%sweep_parameter_label='Period [Days]'; 
%sweep_parameter_label='Ohm10 [º]'; 
sweep_parameter_label='Fi [º]'; 
%sweep_parameter_label='Fi_obs [º]'; 
%sweep_parameter_label='a [AU]'; 

i=1;
while sweep_parameter<sweep_max
tic;
    if i>1
        sweep_parameter(i)=sweep_parameter(i-1)+sweep_step;
    end

fi=sweep_parameter(i);     %IMPORTANT! Define Sweep Parameter!

%t_max=period*200;        %ONLY if period=sweep_parameter(i);
%m0=m0*1047.56;            %ONLY if m0=sweep_parameter(i);
%J1= J1*pi/180;              %ONLY if J1=sweep_parameter(i);
%z= z*pi/180;              %ONLY if z=sweep_parameter(i);
%ohm10= ohm10*pi/180;      %ONLY if ohm10=sweep_parameter(i);
fi= fi*pi/180;            %ONLY if fi=sweep_parameter(i);
%fi_obs= fi_obs*pi/180;    %ONLY if fi=sweep_parameter(i);


[OC, transit_time, transit_orbit, time, Y1, Z1, Y1p, Z1p]=TTTV_Solver(a,J1,fi ,fi_obs,lambda10,ohm10,g2,m0,m1,m2,z,period,t_min, t_max, NS_factor, OC_precision);
[TTV_period(i,:), TTV_offset(i,:),TTV_amplitude(i,:),TTV_fase(i,:),TTV_fit, correl] = TTTV_real_fitting(transit_time, OC);
correl_vector(i)=correl;

[thd_db,~,harmfreq] = thd(OC,(1/period), length(TTV_offset(i,:)));
percent_thd(i) = 100*(10^(thd_db/20));


clf
figure(1);
plot(transit_orbit, OC)
hold on;
plot(transit_orbit, OC,'ro')
plot(transit_orbit,sum(TTV_fit),'black');
xlabel('Orbit number')
ylabel('O-C [Minutes]')
legend('O-C interpolation','O-C points',strcat('Fitting correlation: ',num2str(100*correl),'%'))
pause(0.1);

iteration_time(i)=toc;
mean_iteration_time=mean(iteration_time);

number_iterations=(1+(sweep_max-sweep_parameter(1))/sweep_step);
estimated_time=mean_iteration_time*(number_iterations-i);


clc;
disp(strcat('Sweep Parameter: ',sweep_parameter_label))
disp(strcat(num2str(100*i/number_iterations),'% Last Sweep Parameter value = ', num2str(sweep_parameter(i))))
fprintf('Estimated Time Remaining: %d minutes %d seconds\n',fix(estimated_time/60),round(60*((estimated_time/60)-fix(estimated_time/60))));
fprintf('Min correlation:  %.3f %%\n',100*min(correl_vector));
fprintf('Mean correlation: %.3f %%\n',100*mean(correl_vector));
fprintf('Max correlation:  %.3f %%\n',100*max(correl_vector));
disp(' ')

i=i+1;
end

figure (1)
suptitle('Fundamental')

subplot(2,2,1)
plot(sweep_parameter, TTV_offset(:,1))
hold on
plot(sweep_parameter, TTV_offset(:,1),'ro')
ylabel('TTV offset [Minutes]')
xlabel(sweep_parameter_label)
xlim([sweep_parameter(1) sweep_max])

subplot(2,2,2)
[AX,~,H2]=plotyy(sweep_parameter, TTV_period(:,1),sweep_parameter, TTV_period(:,1)/period);
xlim([sweep_parameter(1) sweep_max])
xlim(AX(2), [sweep_parameter(1) sweep_max])
set(AX,{'ycolor'},{'black';'black'})
set(H2,'Color','b')
hold on
plot(sweep_parameter, TTV_period(:,1),'ro')
ylabel('TTV period [Days]')
ylabel(AX(2), 'Times orbital period');
xlabel(sweep_parameter_label)


subplot(2,2,3)
plot(sweep_parameter,TTV_amplitude(:,1));
hold on
plot(sweep_parameter, TTV_amplitude(:,1),'ro')
ylabel('TTV amplitude [Minutes]')
xlabel(sweep_parameter_label)
xlim([sweep_parameter(1) sweep_max])

subplot(2,2,4)
plot(sweep_parameter, (180/pi)*TTV_fase(:,1))
hold on
plot(sweep_parameter, (180/pi)*TTV_fase(:,1),'ro')
ylabel('TTV fase [º]')
xlabel(sweep_parameter_label)
xlim([sweep_parameter(1) sweep_max])


figure (2)
suptitle('Second Harmonic')
subplot(2,2,1)
plot(sweep_parameter, TTV_offset(:,2))
hold on
plot(sweep_parameter, TTV_offset(:,2),'ro')
ylabel('TTV offset [Minutes]')
xlabel(sweep_parameter_label)
xlim([sweep_parameter(1) sweep_max])

subplot(2,2,2)
plot(sweep_parameter, TTV_period(:,2));
hold on
plot(sweep_parameter, TTV_period(:,2),'ro')
ylabel('TTV period [Days]')
xlabel(sweep_parameter_label)
xlim([sweep_parameter(1) sweep_max])

subplot(2,2,3)
plot(sweep_parameter,TTV_amplitude(:,2));
hold on
plot(sweep_parameter, TTV_amplitude(:,2),'ro')
ylabel('TTV amplitude [Minutes]')
xlabel(sweep_parameter_label)
xlim([sweep_parameter(1) sweep_max])

subplot(2,2,4)
plot(sweep_parameter, (180/pi)*TTV_fase(:,2))
hold on
plot(sweep_parameter, (180/pi)*TTV_fase(:,2),'ro')
ylabel('TTV fase [º]')
xlabel(sweep_parameter_label)
xlim([sweep_parameter(1) sweep_max])


figure(3)
subplot(2,1,1)
plot(sweep_parameter, correl_vector*100)
hold on
plot(sweep_parameter, correl_vector*100,'ro')
ylabel('Correlation [%]')
xlabel(sweep_parameter_label)
xlim([sweep_parameter(1) sweep_max])

subplot(2,1,2)
plot(sweep_parameter, percent_thd)
hold on
plot(sweep_parameter, percent_thd,'ro')
ylabel('THD [%]')
xlabel(sweep_parameter_label)
xlim([sweep_parameter(1) sweep_max])




