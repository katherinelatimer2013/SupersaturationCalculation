%%% Create LAYER1 in BG and PI datasets
%%% This layer contains functions of LAYER0 data

%%% Required files: BG_dataset_LAYER0.mat, 
%%%                 PI_dataset_LAYER0.mat

%%% Output files: BG_dataset_LAYER1.mat,
%%%               PI_dataset_LAYER1.mat

%%% constants - those for A copied from explore_GOAMAZON.m from Qindan; using 'sim-fixed-dl'%%%
Cp = 1005;     % Thermocapacity of dry air under constant pressure
g = 9.81;      % gravitational accel (m/s^2)
L = 2501000;   % latent heat of evaporation of water
Mma=.02896;    % Molecular weight of dry air
Mmv=.01806;    % Molecular weight of water vapour
Rg = 8.317;    % universal gas constant [j/mol*k]
Ra=Rg/Mma;     % Specific gas constant of dry air
Rv=Rg/Mmv;     % Specific gas constant of water vapour

load('BG_dataset_LAYER0.mat', 'LAYER0_BG');
LAYER1_BG.A = g*((L*Ra)/(Cp*Rv)*(LAYER0_BG.T).^(-1) - ones(size(LAYER0_BG.T))).*(Ra*LAYER0_BG.T).^(-1);
LAYER1_BG.esat = 6.112*exp(17.67*(LAYER0_BG.T - 273.15*ones(size(LAYER0_BG.T)))./(LAYER0_BG.T - 29.65*ones(size(LAYER0_BG.T))));
save('BG_dataset_LAYER1', 'LAYER1_BG');

load('PI_dataset_LAYER0.mat', 'LAYER0_PI');
LAYER1_PI.A = g*((L*Ra)/(Cp*Rv)*(LAYER0_PI.T).^(-1) - ones(size(LAYER0_PI.T))).*(Ra*LAYER0_PI.T).^(-1);
LAYER1_PI.esat = 6.112*exp(17.67*(LAYER0_PI.T - 273.15*ones(size(LAYER0_PI.T)))./(LAYER0_PI.T - 29.65*ones(size(LAYER0_PI.T))));
save('PI_dataset_LAYER1', 'LAYER1_PI');