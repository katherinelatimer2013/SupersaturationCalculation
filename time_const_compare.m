% load('BG_dataset_LAYER2.mat', 'LAYER2_BG');
% load('PI_dataset_LAYER2.mat', 'LAYER2_PI');
% load('wrf_supersaturation_comparison_v1.mat');
% load('BG_dataset_LAYER0pt5.mat');

lwc_BG = squeeze(LAYER0pt5_BG.lwc);
s_fan_BG = output.BG.S_fan;
s_qss_BG = output.BG.S_qss;
tau_BG = LAYER2_BG.tau;
rmean_BG = output.BG.aver_radius;
perc50 = 10^(-4);%prctile(tau_BG(:), 38);
lwc_cutoff = 10^(-5);
% r_cutoff = 10;

lwc_cutoff_inds = lwc_BG > lwc_cutoff;
lwccutoffsfanbg = s_fan_BG(lwc_cutoff_inds);
lwccutoffsqssbg = s_qss_BG(lwc_cutoff_inds);

scatter(lwccutoffsfanbg(:), lwccutoffsqssbg(:));
ylim([-2, 8])
xlim([-.15, .15]);

figure;

low_tau_inds = tau_BG < perc50 & lwc_BG > lwc_cutoff;

lowtimesfanbg = s_fan_BG(low_tau_inds);
lowtimesqssbg = s_qss_BG(low_tau_inds);

scatter(lowtimesfanbg(:), lowtimesqssbg(:));
ylim([-2, 8])
xlim([-.15, .15]);

% r_cutoff_inds = rmean_BG > r_cutoff;
% hirsfanbg = s_fan_BG(r_cutoff_inds);
% hirsqssbg = s_qss_BG(r_cutoff_inds);
% 
% figure;
% 
% scatter(hirsfanbg(:), hirsqssbg(:));
% ylim([-2, 8])
% xlim([-.15, .15]);