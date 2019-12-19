% for i = 1:12
%     daydata = match2.match(i);
%     for j = 1:numel(daydata.cas_meandp)
%         if daydata.cdp_meandp(j) > 22.2 && daydata.cdp_meandp(j) < 22.3
%             disp(daydata.date)
%             disp(daydata.utcsec(j))
%             disp(daydata.cdp_meandp(j))
%         end
%     end
% end

for i = 1:12
    daydata = match1.match(i);
    for j = 1:numel(daydata.cas_meandp)
        if daydata.cdp_meandp(j) > 4.6 && daydata.cdp_meandp(j) < 4.7 && daydata.cas_meandp(j) < 16.1 && daydata.cas_meandp(j) > 15.9
            disp(daydata.date)
            disp(daydata.utcsec(j))
            disp(daydata.cdp_meandp(j))
        end
    end
end