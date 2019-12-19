match1 = load('halo_match_bins.mat', 'match');
match2 = load('halo_match_v14.mat', 'match');

cdp_low = [2.5, 2.9, 5, 7.5, 10.2, 11.8, 15.6, 18.7, 20.7, 24.6, 27.4, 29.2, 34.4, 39, 42.5];
cdp_high = [2.9, 5, 7.5, 10.2, 11.8, 15.6, 18.7, 20.7, 24.6, 27.4, 29.2, 34.4, 39, 42.5, 46];
cdp_mean = (cdp_high + cdp_low)/2;
cdp_diff = cdp_high - cdp_low;

cas_low = [0.89,0.96,3,5,7.2,15,20,25,30,35,40,45];
cas_high = [0.96,3,5,7.2,15,20,25,30,35,40,45,50];
cas_mean = (cas_high + cas_low)/2;
cas_diff = cas_high - cas_low;

%%bin corrections%%

collect2 = make_empty_struct_from_cell(fieldnames(match2.match));
fields = fieldnames(match2.match);
for i_field=1:numel(fields)
    for i_day = 1:numel(match2.match)
        collect2.(fields{i_field}) = cat(2, collect2.(fields{i_field}), match2.match(i_day).(fields{i_field}) );
    end
end

collect1 = make_empty_struct_from_cell(fieldnames(match1.match));
fields = fieldnames(match1.match);
for i_day = 1:numel(match1.match)
    for i_field=1:numel(fields)
        collect1.(fields{i_field}) = cat(2, collect1.(fields{i_field}), match1.match(i_day).(fields{i_field}));       
        collect1_day.(fields{i_field}) = match1.match(i_day).(fields{i_field});      
    end
    x_cdp_day = cdp_mean;
    y_cdp_day = [nanmean(collect1_day.cdpbin1),nanmean(collect1_day.cdpbin2),nanmean(collect1_day.cdpbin3),nanmean(collect1_day.cdpbin4),...
        nanmean(collect1_day.cdpbin5),nanmean(collect1_day.cdpbin6),nanmean(collect1_day.cdpbin7),nanmean(collect1_day.cdpbin8),...
        nanmean(collect1_day.cdpbin9),nanmean(collect1_day.cdpbin10),nanmean(collect1_day.cdpbin11),nanmean(collect1_day.cdpbin12),...
        nanmean(collect1_day.cdpbin13),nanmean(collect1_day.cdpbin14),nanmean(collect1_day.cdpbin15)]./cdp_diff.*cdp_mean;
    x_cas_day = cas_mean;
    y_cas_day = [nanmean(collect1_day.casbin1),nanmean(collect1_day.casbin2),nanmean(collect1_day.casbin3),nanmean(collect1_day.casbin4),...
        nanmean(collect1_day.casbin5),nanmean(collect1_day.casbin6),nanmean(collect1_day.casbin7),nanmean(collect1_day.casbin8),...
        nanmean(collect1_day.casbin9),nanmean(collect1_day.casbin10),nanmean(collect1_day.casbin11),nanmean(collect1_day.casbin12)]./cas_diff.*cas_mean;
%     figure;
%     plot(x_cdp_day, y_cdp_day, '-o', 'Color','red');
%     hold on;
%     plot(x_cas_day, y_cas_day, '-o', 'Color','blue');
%     legend('CDP', 'CAS');
%     xlabel('Diameter ($\mu$m)', 'Interpreter', 'latex');
%     ylabel('Diameter x Number concentration per diameter range (mm$^{-4}$)', 'Interpreter', 'latex');
%     title(strcat('Flight date: ', match1.match(i_day).date));
%     saveas(gcf, strcat('ptcldiampdf', match1.match(i_day).date, '_volcorr.png'));
end

% if strcmpi('sim','sim')
%     filter_arr =  collect2.cdp_meandp >= 3 ...
%         & collect2.cas_meandp >= 3 & collect2.cdp_nconc >=10 ...
%         & collect2.cas_nconc >=10 & collect2.alt>0;
% %                 filter_arr = collect1.alt>0;
%     for i_field=1:numel(fields)
%         thisdata = collect1.(fields{i_field});
%         thisdata(~filter_arr) = nan;
%         collect1.(fields{i_field}) = thisdata;
%     end
% end

x_cdp = cdp_mean;
means = [nanmean(collect1.cdpbin1),nanmean(collect1.cdpbin2),nanmean(collect1.cdpbin3),nanmean(collect1.cdpbin4),...
    nanmean(collect1.cdpbin5),nanmean(collect1.cdpbin6),nanmean(collect1.cdpbin7),nanmean(collect1.cdpbin8),...
    nanmean(collect1.cdpbin9),nanmean(collect1.cdpbin10),nanmean(collect1.cdpbin11),nanmean(collect1.cdpbin12),...
    nanmean(collect1.cdpbin13),nanmean(collect1.cdpbin14),nanmean(collect1.cdpbin15)];
y_cdp = means./cdp_diff.*cdp_mean;
x_cas = cas_mean;
y_cas = [nanmean(collect1.casbin1),nanmean(collect1.casbin2),nanmean(collect1.casbin3),nanmean(collect1.casbin4),...
    nanmean(collect1.casbin5),nanmean(collect1.casbin6),nanmean(collect1.casbin7),nanmean(collect1.casbin8),...
    nanmean(collect1.casbin9),nanmean(collect1.casbin10),nanmean(collect1.casbin11),nanmean(collect1.casbin12)]./cas_diff.*cas_mean;
   
figure;
plot(x_cdp, y_cdp, '-o', 'Color','red');
hold on;
plot(x_cas, y_cas, '-o', 'Color','blue');
legend('CDP', 'CAS');
xlabel('Diameter ($\mu$m)', 'Interpreter', 'latex');
ylabel('Diameter x Number concentration per diameter range (mm$^{-4}$)', 'Interpreter', 'latex');
title('Average over all flight dates')
saveas(gcf, strcat('ptcldiampdf_avg_volcorr.png'));