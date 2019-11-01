%%% Create LAYER0 in BG and PI datasets
%%% This layer contains either raw data from the simulations,
%%% box' calculated quantities from Qindan, and LWC calculated previously
%%% by me

%%% Required files: read_wrf_study_domain_fan.mat, 
%%%                 read_wrf_study_domain_fan_corr_w_pres.mat, 
%%%                 lwc_BG.mat,
%%%                 lwc_PI.mat

%%% Output files: BG_dataset_LAYER0.mat,
%%%               PI_dataset_LAYER0.mat

%%% Dataset files structure(!add units!):
%%% LAYER0
%%%     lwc (liq wat cont g/g)
%%%     Nw (number conc of liquid water drops)
%%%     P (pressure hPa)
%%%     q (mixing ratio liquid water)
%%%     rmeanw (mean radius of liquid water drops)
%%%     Sf_qindan (Fan supersaturation calculated by Qindan)
%%%     T (temperature K)
%%%     w (vertical wind velocity m/s)
%%% LAYER1
%%%     A(T) (prop const)
%%%     esat(T) (saturation vapor pressure for water)
%%% LAYER2
%%%     qs(P, esat) (saturation mixing ratio liquid water)
%%%     Sq(Nw, rmeanw, w) (quasi-steady-state supersaturation liquid water)
%%% LAYER3
%%%     Sf(q, qs) (Fan supersaturation)

load('lwc_BG.mat');
LAYER0_BG.lwc_BG = lwc_BG;
clearvars -except LAYER0_BG;

load('read_wrf_study_domain_fan.mat');
LAYER0_BG.Nw = BG.nconc;
LAYER0_BG.rmeanw = BG.meanr;
LAYER0_BG.w = BG.w;
clearvars -except LAYER0_BG;

load('read_wrf_study_domain_fan_corr_w_pres.mat');
newpres = zeros([size(pres, 1), size(pres, 2), size(pres, 3)]);
for i = 1:72
    newpres(i,:,:) = pres(floor(i/7) + 1,:,:);
end 
LAYER0_BG.P = newpres; %use same pressure data for each hour; assuming it won't change much in time
LAYER0_BG.q = BG.q;
LAYER0_BG.Sf_qindan = BG.ss_fan;
LAYER0_BG.T = BG.temp + 273.15*ones(size(BG.temp));
clearvars -except LAYER0_BG;

save('BG_dataset_LAYER0', 'LAYER0_BG');

load('lwc_PI.mat');
LAYER0_PI.lwc_PI = lwc_PI;
clearvars -except LAYER0_PI;

load('read_wrf_study_domain_fan.mat');
LAYER0_PI.Nw = PI.nconc;
LAYER0_PI.rmeanw = PI.meanr;
LAYER0_PI.w = PI.w;
clearvars -except LAYER0_PI;

load('read_wrf_study_domain_fan_corr_w_pres.mat');
newpres = zeros([size(pres, 1), size(pres, 2), size(pres, 3)]);
for i = 1:72
    newpres(i,:,:) = pres(floor(i/7) + 1,:,:);
end  
LAYER0_PI.P = newpres; %use same pressure data for each hour; assuming it won't change much in time
LAYER0_PI.q = PI.q;
LAYER0_PI.Sf_qindan = PI.ss_fan;
LAYER0_PI.T = PI.temp + 273.15*ones(size(PI.temp));
clearvars -except LAYER0_PI;

save('PI_dataset_LAYER0', 'LAYER0_PI');