%%% Create LAYER2 in BG and PI datasets
%%% This layer contains functions of LAYER0 and LAYER1 data

%%% Required files: BG_dataset_LAYER0.mat, 
%%%                 PI_dataset_LAYER0.mat,
%%%                 BG_dataset_LAYER0pt5.mat,
%%%                 PI_dataset_LAYER0pt5.mat,
%%%                 BG_dataset_LAYER1.mat, 
%%%                 PI_dataset_LAYER1.mat


%%% Output files: BG_dataset_LAYER2.mat,
%%%               PI_dataset_LAYER2.mat

%%% constants - copied from explore_GOAMAZON.m from Qindan; using 'sim-fixed-dl'%%%
D = 0.23e-4;

load('BG_dataset_LAYER0.mat', 'LAYER0_BG');
% load('BG_dataset_LAYER0pt5.mat', 'LAYER0pt5_BG');
load('BG_dataset_LAYER1.mat', 'LAYER1_BG');
LAYER2_BG.qs = 0.622*LAYER1_BG.esat./(LAYER0_BG.P - LAYER1_BG.esat);
LAYER2_BG.S_qss_times_rmean = LAYER1_BG.A.*LAYER0_BG.w./(4*pi*D*LAYER0_BG.Nw);
LAYER2_BG.tau = 1./(LAYER1_BG.A.*LAYER0_BG.w + 4*pi*D*LAYER0_BG.Nw);
save('BG_dataset_LAYER2', 'LAYER2_BG');

load('PI_dataset_LAYER0.mat', 'LAYER0_PI');
% load('PI_dataset_LAYER0PT5.mat', 'LAYER0_PI');
load('PI_dataset_LAYER1.mat', 'LAYER1_PI');
LAYER2_PI.qs = 0.622*LAYER1_PI.esat./(LAYER0_PI.P - LAYER1_PI.esat);
LAYER2_PI.S_qss_times_rmean = LAYER1_PI.A.*LAYER0_PI.w./(4*pi*D*LAYER0_PI.Nw);
LAYER2_PI.tau = 1./(LAYER1_PI.A.*LAYER0_PI.w + 4*pi*D*LAYER0_PI.Nw);
save('PI_dataset_LAYER2', 'LAYER2_PI');