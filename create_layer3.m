%%% Create LAYER3 in BG and PI datasets
%%% This layer contains functions of LAYER0 and LAYER2 data

%%% Required files: BG_dataset_LAYER0.mat, 
%%%                 PI_dataset_LAYER0.mat,
%%%                 BG_dataset_LAYER2.mat, 
%%%                 PI_dataset_LAYER2.mat


%%% Output files: BG_dataset_LAYER3.mat,
%%%               PI_dataset_LAYER3.mat

load('BG_dataset_LAYER0.mat', 'LAYER0_BG');
load('BG_dataset_LAYER2.mat', 'LAYER2_BG');
LAYER3_BG.Sf = LAYER0_BG.q./LAYER2_BG.qs - ones(size(LAYER0_BG.q));
save('BG_dataset_LAYER3', 'LAYER3_BG');
clear;

load('PI_dataset_LAYER0.mat', 'LAYER0_PI');
load('PI_dataset_LAYER2.mat', 'LAYER2_PI');
LAYER3_PI.Sf = LAYER0_PI.q./LAYER2_PI.qs - ones(size(LAYER0_PI.q));
save('PI_dataset_LAYER3', 'LAYER3_PI');