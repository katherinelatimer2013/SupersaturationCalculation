load('BG_dataset_LAYER0.mat', 'LAYER0_BG');
load('BG_dataset_LAYER1.mat', 'LAYER1_BG');
load('BG_dataset_LAYER2.mat', 'LAYER2_BG');
load('BG_dataset_LAYER3.mat', 'LAYER3_BG');

% load('BG_dataset.mat');
figure;
scatter(LAYER0_BG.Sf_qindan(:), LAYER3_BG.Sf(:));
% figure;
% scatter(LAYER3_BG.Sf(:), LAYER2_BG.Sq(:));