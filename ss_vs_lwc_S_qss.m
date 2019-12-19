lwc_cutoff = 1e-5; %g/g
w_cutoff = 2; %m/s

load('wrf_supersaturation_comparison_v1.mat')

load('BG_dataset_LAYER0.mat');
load('BG_dataset_LAYER0pt5.mat');

lwc = squeeze(LAYER0pt5_BG.lwc);
w = LAYER0_BG.w;
ss = output.BG.S_qss;

above_lwc_cutoff = lwc > ones(size(lwc))*lwc_cutoff;
above_w_cutoff = w > ones(size(w))*w_cutoff;
above_both_cutoffs = above_lwc_cutoff & above_w_cutoff;

nowindfilt_lwc_fifth_prctile_by_alt = zeros([1, size(lwc, 3)]);
withwindfilt_lwc_fifth_prctile_by_alt = zeros([1, size(lwc, 3)]);

for i = 1:size(lwc, 3)
    lwc_altitude_slice = lwc(:, :, i);
    above_lwc_cutoff_altitude_slice = above_lwc_cutoff(:, :, i);
    above_both_cutoffs_altitude_slice = above_both_cutoffs(:, :, i);
    nowindfilt_lwc_fifth_prctile_by_alt(i) = prctile(lwc_altitude_slice(above_lwc_cutoff_altitude_slice), 5, [1,2]);
    withwindfilt_lwc_fifth_prctile_by_alt(i) = prctile(lwc_altitude_slice(above_both_cutoffs_altitude_slice), 5, [1,2]);
end

nowindfilt_lwc_fifth_prctile_by_alt_and_time = zeros([size(lwc, 1), size(lwc, 3)]);
withwindfilt_lwc_fifth_prctile_by_alt_and_time = zeros([size(lwc, 1), size(lwc, 3)]);

for i = 1:size(lwc, 1)
    for j = 1:size(lwc, 3)
        lwc_time_altitude_slice = lwc(i, :, j);
        above_lwc_cutoff_time_altitude_slice = above_lwc_cutoff(i, :, j);
        above_both_cutoffs_time_altitude_slice = above_both_cutoffs(i, :, j);
        nowindfilt_lwc_fifth_prctile_by_alt_and_time(i, j) = prctile(lwc_time_altitude_slice(above_lwc_cutoff_time_altitude_slice), 5);
        withwindfilt_lwc_fifth_prctile_by_alt_and_time(i, j) = prctile(lwc_time_altitude_slice(above_both_cutoffs_time_altitude_slice), 5);
    end
end

nowindfilt_lwc_cloud_bulk = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
nowindfilt_ss_cloud_bulk = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
nowindfilt_lwc_cloud_edge = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
nowindfilt_ss_cloud_edge = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);

withwindfilt_lwc_cloud_bulk = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
withwindfilt_ss_cloud_bulk = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
withwindfilt_lwc_cloud_edge = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
withwindfilt_ss_cloud_edge = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);

n_nowindfilt_bulk = 1;
n_nowindfilt_edge = 1;
n_withwindfilt_bulk = 1;
n_withwindfilt_edge = 1;

for i = 1:size(lwc, 1)
    for j = 1:size(lwc, 2)
        for k = 1:size(lwc, 3)
            if above_lwc_cutoff(i, j, k)
                if lwc(i, j, k) > nowindfilt_lwc_fifth_prctile_by_alt_and_time(i, k)
                    nowindfilt_lwc_cloud_bulk(n_nowindfilt_bulk) = lwc(i, j, k);
                    nowindfilt_ss_cloud_bulk(n_nowindfilt_bulk) = ss(i, j, k);
                    n_nowindfilt_bulk = n_nowindfilt_bulk + 1;
                else
                    nowindfilt_lwc_cloud_edge(n_nowindfilt_edge) = lwc(i, j, k);
                    nowindfilt_ss_cloud_edge(n_nowindfilt_edge) = ss(i, j, k);
                    n_nowindfilt_edge = n_nowindfilt_edge + 1;
                end
                
                if above_both_cutoffs(i, j, k)
                    if lwc(i, j, k) > withwindfilt_lwc_fifth_prctile_by_alt_and_time(i, k)
                        withwindfilt_lwc_cloud_bulk(n_withwindfilt_bulk) = lwc(i, j, k);
                        withwindfilt_ss_cloud_bulk(n_withwindfilt_bulk) = ss(i, j, k);
                        n_withwindfilt_bulk = n_withwindfilt_bulk + 1;
                    else
                        withwindfilt_lwc_cloud_edge(n_withwindfilt_edge) = lwc(i, j, k);
                        withwindfilt_ss_cloud_edge(n_withwindfilt_edge) = ss(i, j, k);
                        n_withwindfilt_edge = n_withwindfilt_edge + 1;
                    end
                end
            end
        end
    end
end

nowindfilt_lwc_cloud_bulk = nowindfilt_lwc_cloud_bulk(1:n_nowindfilt_bulk, 1);
nowindfilt_ss_cloud_bulk = nowindfilt_ss_cloud_bulk(1:n_nowindfilt_bulk, 1);
nowindfilt_lwc_cloud_edge = nowindfilt_lwc_cloud_edge(1:n_nowindfilt_edge, 1);
nowindfilt_ss_cloud_edge = nowindfilt_ss_cloud_edge(1:n_nowindfilt_edge, 1);

withwindfilt_lwc_cloud_bulk = withwindfilt_lwc_cloud_bulk(1:n_withwindfilt_bulk, 1);
withwindfilt_ss_cloud_bulk = withwindfilt_ss_cloud_bulk(1:n_withwindfilt_bulk, 1);
withwindfilt_lwc_cloud_edge = withwindfilt_lwc_cloud_edge(1:n_withwindfilt_edge, 1);
withwindfilt_ss_cloud_edge = withwindfilt_ss_cloud_edge(1:n_withwindfilt_edge, 1);

figure; 

% histogram(100*nowindfilt_ss_cloud_bulk,30,'Normalization','probability');
% hold on;
% histogram(100*nowindfilt_ss_cloud_edge,30,'Normalization','probability');
% title('No w filter - polluted');
% legend('Bulk', 'Edge');
% xlabel('SS (%)');
% ylabel('Frequency');
% figure;
% 
% histogram(100*withwindfilt_ss_cloud_bulk,30,'Normalization','probability');
% hold on;
% histogram(100*withwindfilt_ss_cloud_edge,30,'Normalization','probability');
% title('w > 2 m/s - polluted');
% legend('Bulk', 'Edge');
% xlabel('SS (%)');
% ylabel('Frequency');
% figure;

histogram(100*nowindfilt_ss_cloud_bulk, 'BinWidth', 2, 'Normalization','probability');
hold on;
histogram(100*nowindfilt_ss_cloud_edge, 'BinWidth', 2, 'Normalization','probability');
title('No w filter - polluted');
legend('Bulk', 'Edge');
xlabel('SS (%)');
ylabel('Frequency');
xlim([-60 30]);
saveas(gcf,'no_w_filter_bg_s_qss.png');
figure;

histogram(100*withwindfilt_ss_cloud_bulk, 'BinWidth', 2, 'Normalization','probability');
hold on;
histogram(100*withwindfilt_ss_cloud_edge, 'BinWidth', 2, 'Normalization','probability');
title('w > 2 m/s - polluted');
legend('Bulk', 'Edge');
xlabel('SS (%)');
ylabel('Frequency');
xlim([-60 30]);
saveas(gcf,'with_w_filter_bg_s_qss.png');
figure;

load('PI_dataset_LAYER0.mat');
load('PI_dataset_LAYER0pt5.mat');

lwc = squeeze(LAYER0pt5_PI.lwc);
w = LAYER0_PI.w;
ss = output.PI.S_qss;

above_lwc_cutoff = lwc > ones(size(lwc))*lwc_cutoff;
above_w_cutoff = w > ones(size(w))*w_cutoff;
above_both_cutoffs = above_lwc_cutoff & above_w_cutoff;

nowindfilt_lwc_fifth_prctile_by_alt = zeros([1, size(lwc, 3)]);
withwindfilt_lwc_fifth_prctile_by_alt = zeros([1, size(lwc, 3)]);

for i = 1:size(lwc, 3)
    lwc_altitude_slice = lwc(:, :, i);
    above_lwc_cutoff_altitude_slice = above_lwc_cutoff(:, :, i);
    above_both_cutoffs_altitude_slice = above_both_cutoffs(:, :, i);
    nowindfilt_lwc_fifth_prctile_by_alt(i) = prctile(lwc_altitude_slice(above_lwc_cutoff_altitude_slice), 5, [1,2]);
    withwindfilt_lwc_fifth_prctile_by_alt(i) = prctile(lwc_altitude_slice(above_both_cutoffs_altitude_slice), 5, [1,2]);
end

nowindfilt_lwc_fifth_prctile_by_alt_and_time = zeros([size(lwc, 1), size(lwc, 3)]);
withwindfilt_lwc_fifth_prctile_by_alt_and_time = zeros([size(lwc, 1), size(lwc, 3)]);

for i = 1:size(lwc, 1)
    for j = 1:size(lwc, 3)
        lwc_time_altitude_slice = lwc(i, :, j);
        above_lwc_cutoff_time_altitude_slice = above_lwc_cutoff(i, :, j);
        above_both_cutoffs_time_altitude_slice = above_both_cutoffs(i, :, j);
        nowindfilt_lwc_fifth_prctile_by_alt_and_time(i, j) = prctile(lwc_time_altitude_slice(above_lwc_cutoff_time_altitude_slice), 5);
        withwindfilt_lwc_fifth_prctile_by_alt_and_time(i, j) = prctile(lwc_time_altitude_slice(above_both_cutoffs_time_altitude_slice), 5);
    end
end

nowindfilt_lwc_cloud_bulk = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
nowindfilt_ss_cloud_bulk = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
nowindfilt_lwc_cloud_edge = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
nowindfilt_ss_cloud_edge = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);

withwindfilt_lwc_cloud_bulk = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
withwindfilt_ss_cloud_bulk = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
withwindfilt_lwc_cloud_edge = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);
withwindfilt_ss_cloud_edge = zeros(size(lwc, 1)*size(lwc, 2)*size(lwc, 3), 1);

n_nowindfilt_bulk = 1;
n_nowindfilt_edge = 1;
n_withwindfilt_bulk = 1;
n_withwindfilt_edge = 1;

for i = 1:size(lwc, 1)
    for j = 1:size(lwc, 2)
        for k = 1:size(lwc, 3)
            if above_lwc_cutoff(i, j, k)
                if not(isnan(nowindfilt_lwc_fifth_prctile_by_alt_and_time(i, k)))
                    if lwc(i, j, k) > nowindfilt_lwc_fifth_prctile_by_alt_and_time(i, k)
                        nowindfilt_lwc_cloud_bulk(n_nowindfilt_bulk) = lwc(i, j, k);
                        nowindfilt_ss_cloud_bulk(n_nowindfilt_bulk) = ss(i, j, k);
                        n_nowindfilt_bulk = n_nowindfilt_bulk + 1;
                    else
                        nowindfilt_lwc_cloud_edge(n_nowindfilt_edge) = lwc(i, j, k);
                        nowindfilt_ss_cloud_edge(n_nowindfilt_edge) = ss(i, j, k);
                        n_nowindfilt_edge = n_nowindfilt_edge + 1;
                    end
                end
                
                if above_both_cutoffs(i, j, k)
                    if not(isnan(withwindfilt_lwc_fifth_prctile_by_alt_and_time(i, k)))
                        if lwc(i, j, k) > withwindfilt_lwc_fifth_prctile_by_alt_and_time(i, k)
                            withwindfilt_lwc_cloud_bulk(n_withwindfilt_bulk) = lwc(i, j, k);
                            withwindfilt_ss_cloud_bulk(n_withwindfilt_bulk) = ss(i, j, k);
                            n_withwindfilt_bulk = n_withwindfilt_bulk + 1;
                        else
                            withwindfilt_lwc_cloud_edge(n_withwindfilt_edge) = lwc(i, j, k);
                            withwindfilt_ss_cloud_edge(n_withwindfilt_edge) = ss(i, j, k);
                            n_withwindfilt_edge = n_withwindfilt_edge + 1;
                        end
                    end
                end
            end
        end
    end
end

nowindfilt_lwc_cloud_bulk = nowindfilt_lwc_cloud_bulk(1:n_nowindfilt_bulk, 1);
nowindfilt_ss_cloud_bulk = nowindfilt_ss_cloud_bulk(1:n_nowindfilt_bulk, 1);
nowindfilt_lwc_cloud_edge = nowindfilt_lwc_cloud_edge(1:n_nowindfilt_edge, 1);
nowindfilt_ss_cloud_edge = nowindfilt_ss_cloud_edge(1:n_nowindfilt_edge, 1);

withwindfilt_lwc_cloud_bulk = withwindfilt_lwc_cloud_bulk(1:n_withwindfilt_bulk, 1);
withwindfilt_ss_cloud_bulk = withwindfilt_ss_cloud_bulk(1:n_withwindfilt_bulk, 1);
withwindfilt_lwc_cloud_edge = withwindfilt_lwc_cloud_edge(1:n_withwindfilt_edge, 1);
withwindfilt_ss_cloud_edge = withwindfilt_ss_cloud_edge(1:n_withwindfilt_edge, 1);

% histogram(100*nowindfilt_ss_cloud_bulk,30,'Normalization','probability');
% hold on;
% histogram(100*nowindfilt_ss_cloud_edge,30,'Normalization','probability');
% title('No w filter - unpolluted');
% legend('Bulk', 'Edge');
% xlabel('SS (%)');
% ylabel('Frequency');
% figure;
% 
% histogram(100*withwindfilt_ss_cloud_bulk,30,'Normalization','probability');
% hold on;
% histogram(100*withwindfilt_ss_cloud_edge,30,'Normalization','probability');
% title('w > 2 m/s - unpolluted');
% legend('Bulk', 'Edge');
% xlabel('SS (%)');
% ylabel('Frequency');
% figure;

histogram(100*nowindfilt_ss_cloud_bulk, 'BinWidth', 2, 'Normalization','probability');
hold on;
histogram(100*nowindfilt_ss_cloud_edge, 'BinWidth', 2, 'Normalization','probability');
title('No w filter - unpolluted');
legend('Bulk', 'Edge');
xlabel('SS (%)');
ylabel('Frequency');
xlim([-60 30]);
saveas(gcf,'no_w_filter_pi_s_qss.png');
figure;

histogram(100*withwindfilt_ss_cloud_bulk, 'BinWidth', 2, 'Normalization','probability');
hold on;
histogram(100*withwindfilt_ss_cloud_edge, 'BinWidth', 2, 'Normalization','probability');
title('w > 2 m/s - unpolluted');
legend('Bulk', 'Edge');
xlabel('SS (%)');
ylabel('Frequency');
xlim([-60 30]);
saveas(gcf,'with_w_filter_pi_s_qss.png');
