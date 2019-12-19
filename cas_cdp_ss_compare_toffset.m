match1 = load('halo_match_v9.mat', 'match');
match2 = load('halo_match_v14.mat', 'match');
% match1 = load('halo_match_v11.mat', 'match');
% match2 = load('halo_match_v9.mat', 'match');
match3 = load('halo_match_change_cas_corr_v2.mat', 'match');
offset = 1;

% %%bin corrections%%
% 
% collect1 = make_empty_struct_from_cell(fieldnames(match1.match));
% fields = fieldnames(match1.match);
% for i_field=1:numel(fields)
%     fieldnamecell = fields(i_field);
%     fieldname = fieldnamecell{1};
%     for i_day = 1:numel(match1.match)
%         if size(fieldname,2) > 2 && all(fieldname(1:3) == 'cas') && offset >= 0
%             collect1.(fields{i_field}) = cat(2, collect1.(fields{i_field}), match1.match(i_day).(fields{i_field})(1+offset:end));
%         elseif size(fieldname,2) > 2 && all(fieldname(1:3) == 'cas') && offset < 0
%             collect1.(fields{i_field}) = cat(2, collect1.(fields{i_field}), match1.match(i_day).(fields{i_field})(1:end+offset));
%         elseif offset >= 0
%             collect1.(fields{i_field}) = cat(2, collect1.(fields{i_field}), match1.match(i_day).(fields{i_field})(1:end-offset));
%         else
%             collect1.(fields{i_field}) = cat(2, collect1.(fields{i_field}), match1.match(i_day).(fields{i_field})(1-offset:end));
%         end
%     end
% end
% 
% if strcmpi('sim','sim')
%     filter_arr =  collect1.cdp_meandp >= 3 ...
%         & collect1.cas_meandp >= 3 & collect1.cdp_nconc >=10 ...
%         & collect1.cas_nconc >=10 & collect1.alt>0;
% %                 filter_arr = collect1.alt>0;
%     for i_field=1:numel(fields)
%         thisdata = collect1.(fields{i_field});
%         thisdata(~filter_arr) = nan;
%         collect1.(fields{i_field}) = thisdata;
%     end
% end
% 
% figure;
% numinds = ~(isnan(collect1.cdp_meandp) | isnan(collect1.cas_meandp));
% x = collect1.cdp_meandp(numinds);
% y = collect1.cas_meandp(numinds);
% p = polyfit(x, y, 1);
% yfit = p(1)*x + p(2);
% yresid = y - yfit;
% SSresid = sum(yresid.^2);
% SStotal = (length(y)-1) * var(y);
% rsq = 1 - SSresid/SStotal;
% 
% xmin = 0;
% xmax = 35;
% ymin = 0;
% ymax = 35;
% scatter(x, y, '.');
% title('Mean diameter (um) - with bin corrections')
% xlabel('CDP');
% ylabel('CAS');
% xlim([xmin xmax]);
% ylim([ymin ymax]);
% hold on;
% plot(linspace(xmin, xmax, 2), linspace(xmin, xmax, 2), '--r');
% hold on;
% plot(linspace(xmin, xmax, 2), [p(1)*xmin + p(2), p(1)*xmax + p(2)], '--k');
% legend('Data', '1:1', strcat('Linear fit, m=', num2str(p(1)),', b=', num2str(p(2)),', R^2=', num2str(rsq)));
% 
% figure;
% x = collect1.cdp_nconc(numinds);
% y = collect1.cas_nconc(numinds);
% p = polyfit(x, y, 1);
% yfit = p(1)*x + p(2);
% yresid = y - yfit;
% SSresid = sum(yresid.^2);
% SStotal = (length(y)-1) * var(y);
% rsq = 1 - SSresid/SStotal;
% xmin = 0;
% xmax = 3000;
% ymin = 0;
% ymax = 3000;
% scatter(x, y, '.');
% title('Number concentration (cm^{-3}) - with bin corrections')
% xlabel('CDP');
% ylabel('CAS');
% xlim([xmin xmax]);
% ylim([ymin ymax]);
% hold on;
% plot(linspace(xmin, xmax, 2), linspace(xmin, xmax, 2), '--r');
% hold on;
% plot(linspace(xmin, xmax, 2), [p(1)*xmin + p(2), p(1)*xmax + p(2)], '--k');
% legend('Data', '1:1', strcat('Linear fit, m=', num2str(p(1)),', b=', num2str(p(2)),', R^2=', num2str(rsq))); 

%%no corrections%%

collect2 = make_empty_struct_from_cell(fieldnames(match2.match));
fields = fieldnames(match2.match);
for i_field=1:numel(fields)
    fieldnamecell = fields(i_field);
    fieldname = fieldnamecell{1};
    for i_day = 1:numel(match2.match)
        if size(fieldname,2) > 2 && all(fieldname(1:3) == 'cas') && offset >= 0
            collect2.(fields{i_field}) = cat(2, collect2.(fields{i_field}), match2.match(i_day).(fields{i_field})(1+offset:end));
        elseif size(fieldname,2) > 2 && all(fieldname(1:3) == 'cas') && offset < 0
            collect2.(fields{i_field}) = cat(2, collect2.(fields{i_field}), match2.match(i_day).(fields{i_field})(1:end+offset));
        elseif offset >= 0
            collect2.(fields{i_field}) = cat(2, collect2.(fields{i_field}), match2.match(i_day).(fields{i_field})(1:end-offset));
        else
            collect2.(fields{i_field}) = cat(2, collect2.(fields{i_field}), match2.match(i_day).(fields{i_field})(1-offset:end));
        end
    end
end

if strcmpi('sim','sim')
    filter_arr =  collect2.cdp_meandp >= 3 ...
        & collect2.cas_meandp >= 3 & collect2.cdp_nconc >=10 ...
        & collect2.cas_nconc >=10 & collect2.alt>0;
%                 filter_arr = collect2.alt>0;
    for i_field=1:numel(fields)
        thisdata = collect2.(fields{i_field});
        thisdata(~filter_arr) = nan;
        collect2.(fields{i_field}) = thisdata;
    end
end

figure;
numinds = ~(isnan(collect2.cdp_meandp) | isnan(collect2.cas_meandp));
x = collect2.cdp_meandp(numinds);
y = collect2.cas_meandp(numinds);
p = polyfit(x, y, 1);
yfit = p(1)*x + p(2);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;

xmin = 0;
xmax = 35;
ymin = 0;
ymax = 35;
scatter(x, y, '.');
title('Mean diameter (um) - without corrections')
xlabel('CDP');
ylabel('CAS');
xlim([xmin xmax]);
ylim([ymin ymax]);
hold on;
plot(linspace(xmin, xmax, 2), linspace(xmin, xmax, 2), '--r');
hold on;
plot(linspace(xmin, xmax, 2), [p(1)*xmin + p(2), p(1)*xmax + p(2)], '--k');
legend('Data', '1:1', strcat('Linear fit, m=', num2str(p(1)),', b=', num2str(p(2)),', R^2=', num2str(rsq)));

figure;
x = collect2.cdp_nconc(numinds);
y = collect2.cas_nconc(numinds);
p = polyfit(x, y, 1);
yfit = p(1)*x + p(2);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;
xmin = 0;
xmax = 3000;
ymin = 0;
ymax = 3000;
scatter(x, y, '.');
title('Number concentration (cm^{-3}) - without corrections')
xlabel('CDP');
ylabel('CAS');
xlim([xmin xmax]);
ylim([ymin ymax]);
hold on;
plot(linspace(xmin, xmax, 2), linspace(xmin, xmax, 2), '--r');
hold on;
plot(linspace(xmin, xmax, 2), [p(1)*xmin + p(2), p(1)*xmax + p(2)], '--k');
legend('Data', '1:1', strcat('Linear fit, m=', num2str(p(1)),', b=', num2str(p(2)),', R^2=', num2str(rsq)));

% %%correction factors%%
% 
% collect3 = make_empty_struct_from_cell(fieldnames(match3.match));
% fields = fieldnames(match3.match);
% for i_field=1:numel(fields)
%     for i_day = 1:numel(match3.match)
%         collect3.(fields{i_field}) = cat(2, collect3.(fields{i_field}), match3.match(i_day).(fields{i_field}) );
%     end
% end
% 
% if strcmpi('sim','sim')
%     filter_arr =  collect3.cdp_meandp >= 3 ...
%         & collect3.cas_meandp >= 3 & collect3.cdp_nconc >=10 ...
%         & collect3.cas_nconc >=10 & collect3.alt>0;
% %                 filter_arr = collect1.alt>0;
%     for i_field=1:numel(fields)
%         thisdata = collect3.(fields{i_field});
%         thisdata(~filter_arr) = nan;
%         collect3.(fields{i_field}) = thisdata;
%     end
% end
% 
% figure;
% numinds = ~(isnan(collect3.cdp_meandp) | isnan(collect3.cas_meandp));
% x = collect3.cdp_meandp(numinds);
% y = collect3.cas_meandp(numinds);
% p = polyfit(x, y, 1);
% yfit = p(1)*x + p(2);
% yresid = y - yfit;
% SSresid = sum(yresid.^2);
% SStotal = (length(y)-1) * var(y);
% rsq = 1 - SSresid/SStotal;
% 
% xmin = 0;
% xmax = 35;
% ymin = 0;
% ymax = 35;
% scatter(x, y, '.');
% title('Mean diameter (um) - with same correction factors')
% xlabel('CDP');
% ylabel('CAS');
% xlim([xmin xmax]);
% ylim([ymin ymax]);
% hold on;
% plot(linspace(xmin, xmax, 2), linspace(xmin, xmax, 2), '--r');
% hold on;
% plot(linspace(xmin, xmax, 2), [p(1)*xmin + p(2), p(1)*xmax + p(2)], '--k');
% legend('Data', '1:1', strcat('Linear fit, m=', num2str(p(1)),', b=', num2str(p(2)),', R^2=', num2str(rsq)));
% 
% figure;
% x = collect3.cdp_nconc(numinds);
% y = collect3.cas_nconc(numinds);
% p = polyfit(x, y, 1);
% yfit = p(1)*x + p(2);
% yresid = y - yfit;
% SSresid = sum(yresid.^2);
% SStotal = (length(y)-1) * var(y);
% rsq = 1 - SSresid/SStotal;
% xmin = 0;
% xmax = 3000;
% ymin = 0;
% ymax = 3000;
% scatter(x, y, '.');
% title('Number concentration (cm^{-3}) - with same correction factors')
% xlabel('CDP');
% ylabel('CAS');
% xlim([xmin xmax]);
% ylim([ymin ymax]);
% hold on;
% plot(linspace(xmin, xmax, 2), linspace(xmin, xmax, 2), '--r');
% hold on;
% plot(linspace(xmin, xmax, 2), [p(1)*xmin + p(2), p(1)*xmax + p(2)], '--k');
% legend('Data', '1:1', strcat('Linear fit, m=', num2str(p(1)),', b=', num2str(p(2)),', R^2=', num2str(rsq)));
