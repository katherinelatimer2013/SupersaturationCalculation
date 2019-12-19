%%% Create merged BG and PI datasets

%%% Required files: BG_dataset_LAYER0.mat, 
%%%                 PI_dataset_LAYER0.mat,
%%%                 BG_dataset_LAYER1.mat, 
%%%                 PI_dataset_LAYER1.mat,
%%%                 BG_dataset_LAYER2.mat, 
%%%                 PI_dataset_LAYER2.mat,
%%%                 BG_dataset_LAYER3.mat, 
%%%                 PI_dataset_LAYER3.mat


%%% Output files: BG_dataset.mat,
%%%               PI_dataset.mat

load('BG_dataset_LAYER0.mat', 'LAYER0_BG');
load('BG_dataset_LAYER1.mat', 'LAYER1_BG');
load('BG_dataset_LAYER2.mat', 'LAYER2_BG');
load('BG_dataset_LAYER3.mat', 'LAYER3_BG');

BG_dataset.LAYER0 = LAYER0_BG;
BG_dataset.LAYER1 = LAYER1_BG;
BG_dataset.LAYER2 = LAYER2_BG;
BG_dataset.LAYER3 = LAYER3_BG;

save('BG_dataset');
clear;

load('PI_dataset_LAYER0.mat', 'LAYER0_PI');
load('PI_dataset_LAYER1.mat', 'LAYER1_PI');
load('PI_dataset_LAYER2.mat', 'LAYER2_PI');
load('PI_dataset_LAYER3.mat', 'LAYER3_PI');

PI_dataset.LAYER0 = LAYER0_PI;
PI_dataset.LAYER1 = LAYER1_PI;
PI_dataset.LAYER2 = LAYER2_PI;
PI_dataset.LAYER3 = LAYER3_PI;

save('PI_dataset');