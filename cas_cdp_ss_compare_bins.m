match1 = load('halo_match_v9.mat', 'match');
match2 = load('halo_match_v10.mat', 'match');

%%bin corrections%%

collect1 = make_empty_struct_from_cell(fieldnames(match1.match));
fields = fieldnames(match1.match);
for i_field=1:numel(fields)
    for i_day = 1:numel(match1.match)
        collect1.(fields{i_field}) = cat(2, collect1.(fields{i_field}), match1.match(i_day).(fields{i_field}) );
    end
end

collect2 = make_empty_struct_from_cell(fieldnames(match2.match));
fields = fieldnames(match2.match);
for i_field=1:numel(fields)
    for i_day = 1:numel(match2.match)
        collect2.(fields{i_field}) = cat(2, collect2.(fields{i_field}), match2.match(i_day).(fields{i_field}) );
    end
end

if strcmpi('sim','sim')
    filter_arr =  collect1.cdp_meandp >= 3 ...
        & collect1.cas_meandp >= 3 & collect1.cdp_nconc >=10 ...
        & collect1.cas_nconc >=10 & collect1.alt>0;
%                 filter_arr = collect1.alt>0;
    for i_field=1:numel(fields)
        thisdata = collect2.(fields{i_field});
        thisdata(~filter_arr) = nan;
        collect2.(fields{i_field}) = thisdata;
    end
end

subplot(2, 5, 1);
histogram(collect2.casbin1(:), 'Normalization', 'count')
title('3-5 um diameter')

subplot(2, 5, 2);
histogram(collect2.casbin2(:), 'Normalization', 'count')
title('5-7.2 um diameter')

subplot(2, 5, 3);
histogram(collect2.casbin3(:), 'Normalization', 'count')
title('7.2-15 um diameter')

subplot(2, 5, 4);
histogram(collect2.casbin4(:), 'Normalization', 'count')
title('15-20 um diameter')

subplot(2, 5, 5);
histogram(collect2.casbin5(:), 'Normalization', 'count')
title('20-25 um diameter')

subplot(2, 5, 6);
histogram(collect2.casbin6(:), 'Normalization', 'count')
title('25-30 um diameter')
ylabel('Count', 'FontSize', 15)

subplot(2, 5, 7);
histogram(collect2.casbin7(:), 'Normalization', 'count')
title('30-35 um diameter')

subplot(2, 5, 8);
histogram(collect2.casbin8(:), 'Normalization', 'count')
title('35-40 um diameter')

subplot(2, 5, 9);
histogram(collect2.casbin9(:), 'Normalization', 'count')
title('40-45 um diameter')

subplot(2, 5, 10);
histogram(collect2.casbin10(:), 'Normalization', 'count')
hold on;
histogram(1.0/5.0*collect2.casbin10(:), 'Normalization', 'count', 'FaceColor', 'red')
title('45-50 um diameter')

figure
subplot(3, 5, 1);
histogram(collect2.cdpbin1(:), 'Normalization', 'count')
title('2.5-2.9 um diameter')

subplot(3, 5, 2);
histogram(collect2.cdpbin2(:), 'Normalization', 'count')
hold on;
histogram(20.0/21.0*collect2.cdpbin2(:), 'Normalization', 'count', 'FaceColor', 'red')
title('2.9-5 um diameter')

subplot(3, 5, 3);
histogram(collect2.cdpbin3(:), 'Normalization', 'count')
title('5-7.5 um diameter')

subplot(3, 5, 4);
histogram(collect2.cdpbin4(:), 'Normalization', 'count')
title('7.5-10.2 um diameter')

subplot(3, 5, 5);
histogram(collect2.cdpbin5(:), 'Normalization', 'count')
title('10.2-11.8 um diameter')

subplot(3, 5, 6);
histogram(collect2.cdpbin6(:), 'Normalization', 'count')
title('11.8-15.6 um diameter')
ylabel('Count', 'FontSize', 15)

subplot(3, 5, 7);
histogram(collect2.cdpbin7(:), 'Normalization', 'count')
title('15.6-18.7 um diameter')

subplot(3, 5, 8);
histogram(collect2.cdpbin8(:), 'Normalization', 'count')
title('18.7-20.7 um diameter')

subplot(3, 5, 9);
histogram(collect2.cdpbin9(:), 'Normalization', 'count')
title('20.7-24.6 um diameter')

subplot(3, 5, 10);
histogram(collect2.cdpbin10(:), 'Normalization', 'count')
title('24.6-27.4 um diameter')

subplot(3, 5, 11);
histogram(collect2.cdpbin11(:), 'Normalization', 'count')
title('27.4-29.2 um diameter')

subplot(3, 5, 12);
histogram(collect2.cdpbin12(:), 'Normalization', 'count')
title('29.2-34.4 um diameter')

subplot(3, 5, 13);
histogram(collect2.cdpbin13(:), 'Normalization', 'count')
title('34.4-39 um diameter')
xlabel('Number concentration (cm^{-3})', 'FontSize', 15);

subplot(3, 5, 14);
histogram(collect2.cdpbin14(:), 'Normalization', 'count')
title('39-42.5 um diameter')

subplot(3, 5, 15);
histogram(collect2.cdpbin15(:), 'Normalization', 'count')
title('42.5-46 um diameter')

% avgcas1 = nanmean(collect2.casbin1);
% avgcas2 = nanmean(collect2.casbin2);
% avgcas3 = nanmean(collect2.casbin3);
% avgcas4 = nanmean(collect2.casbin4);
% avgcas5 = nanmean(collect2.casbin5);
% avgcas6 = nanmean(collect2.casbin6);
% avgcas7 = nanmean(collect2.casbin7);
% avgcas8 = nanmean(collect2.casbin8);
% avgcas9 = nanmean(collect2.casbin9);
% avgcas10 = nanmean(collect2.casbin10);
% 
% avgcdp1 = nanmean(collect2.cdpbin1);
% avgcdp2 = nanmean(collect2.cdpbin2);
% avgcdp3 = nanmean(collect2.cdpbin3);
% avgcdp4 = nanmean(collect2.cdpbin4);
% avgcdp5 = nanmean(collect2.cdpbin5);
% avgcdp6 = nanmean(collect2.cdpbin6);
% avgcdp7 = nanmean(collect2.cdpbin7);
% avgcdp8 = nanmean(collect2.cdpbin8);
% avgcdp9 = nanmean(collect2.cdpbin9);
% avgcdp10 = nanmean(collect2.cdpbin10);
% avgcdp11 = nanmean(collect2.cdpbin11);
% avgcdp12 = nanmean(collect2.cdpbin12);
% avgcdp13 = nanmean(collect2.cdpbin13);
% avgcdp14 = nanmean(collect2.cdpbin14);
% avgcdp15 = nanmean(collect2.cdpbin15);
% 
% mdncas1 = nanmedian(collect2.casbin1);
% mdncas2 = nanmedian(collect2.casbin2);
% mdncas3 = nanmedian(collect2.casbin3);
% mdncas4 = nanmedian(collect2.casbin4);
% mdncas5 = nanmedian(collect2.casbin5);
% mdncas6 = nanmedian(collect2.casbin6);
% mdncas7 = nanmedian(collect2.casbin7);
% mdncas8 = nanmedian(collect2.casbin8);
% mdncas9 = nanmedian(collect2.casbin9);
% mdncas10 = nanmedian(collect2.casbin10);
% 
% mdncdp1 = nanmedian(collect2.cdpbin1);
% mdncdp2 = nanmedian(collect2.cdpbin2);
% mdncdp3 = nanmedian(collect2.cdpbin3);
% mdncdp4 = nanmedian(collect2.cdpbin4);
% mdncdp5 = nanmedian(collect2.cdpbin5);
% mdncdp6 = nanmedian(collect2.cdpbin6);
% mdncdp7 = nanmedian(collect2.cdpbin7);
% mdncdp8 = nanmedian(collect2.cdpbin8);
% mdncdp9 = nanmedian(collect2.cdpbin9);
% mdncdp10 = nanmedian(collect2.cdpbin10);
% mdncdp11 = nanmedian(collect2.cdpbin11);
% mdncdp12 = nanmedian(collect2.cdpbin12);
% mdncdp13 = nanmedian(collect2.cdpbin13);
% mdncdp14 = nanmedian(collect2.cdpbin14);
% mdncdp15 = nanmedian(collect2.cdpbin15);