classdef misc_halo_analysis_bins
    methods(Static = true)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % Property like methods %
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        function value = box_dir()
            value = 'C:\Users\Katherine\Documents\Berkeley Grad\eps_work\insanity closet';
        end
        
        function value = halo_csv_dir()
            value = fullfile(misc_halo_analysis_bins.box_dir, 'HALO_cleanup_csv');
        end
        
        function Dp = cdp_diameter()
            Dp = struct('low',[2.5, 2.9, 5, 7.5, 10.2, 11.8, 15.6, 18.7, 20.7, 24.6, 27.4, 29.2, 34.4, 39, 42.5],...
                        'up',[2.9, 5, 7.5, 10.2, 11.8, 15.6, 18.7, 20.7, 24.6, 27.4, 29.2, 34.4, 39, 42.5, 46]);
        end
        
        function Dp = cas_diameter()
            % remaining issue, the first two bins may be aerosols instead
            % of cloud droplet          
            Dp = struct('low',[0.89,0.96,3,5,7.2,15,20,25,30,35,40,45],...
                        'up',[0.96,3,5,7.2,15,20,25,30,35,40,45,50]);         
        end
        %%%%%%%%%%%%%%%%%%%
        % Utility methods %
        %%%%%%%%%%%%%%%%%%%
        
        % return CDPFILE structure including two fields, filename
        % and the date extracted from the filename
        function cdpfile = read_cdp_file()
            filepattern = '*CCP_CDP*';
            cdpdir = dir(fullfile(misc_halo_analysis_bins.halo_csv_dir, filepattern));
            cdpfile = make_empty_struct_from_cell({'name','date'});
            for i=1:numel(cdpdir)
                cdpfile(i).('name') = fullfile(misc_halo_analysis_bins.halo_csv_dir, cdpdir(i).name);
                cdpfile(i).('date') = datenum(misc_halo_analysis_bins.date_from_halo_filename(cdpdir(i).name));
            end
        end
        
        function casfile = read_cas_file()
            filepattern = '*CAS_DPOL*';
            casdir = dir(fullfile(misc_halo_analysis_bins.halo_csv_dir, filepattern));
            casfile = make_empty_struct_from_cell({'name','date'});
            for i=1:numel(casdir)
                casfile(i).('name') = fullfile(misc_halo_analysis_bins.halo_csv_dir, casdir(i).name);
                % time formate dd_mm_yyyy
                thisdate = regexp(casdir(i).name, '\d\d_\d\d_\d\d\d\d','match','once');
                casfile(i).('date') = datenum(strcat(thisdate(7:10),'-',thisdate(4:5),'-',thisdate(1:2)));
            end
        end
        
        function adlrfile = read_adlr_file()
            filepattern = '*adlr*';
            adlrdir = dir(fullfile(misc_halo_analysis_bins.halo_csv_dir, filepattern));
            adlrfile = make_empty_struct_from_cell({'name','date'});
            for i=1:numel(adlrdir)
                adlrfile(i).('name') = fullfile(misc_halo_analysis_bins.halo_csv_dir, adlrdir(i).name);
                adlrfile(i).('date') = datenum(misc_halo_analysis_bins.date_from_halo_filename(adlrdir(i).name));
            end
        end
        
        function date = date_from_halo_filename(filename)
            % the date formate is yyyymmdd
            dstr = regexp(filename, '\d\d\d\d\d\d\d\d','match','once');
            date = strcat(dstr(1:4),'-',dstr(5:6),'-',dstr(7:8));
        end
        
        function matchfile = read_file_match()
            cdpfile = misc_halo_analysis_bins.read_cdp_file;
            casfile = misc_halo_analysis_bins.read_cas_file;
            adlrfile = misc_halo_analysis_bins.read_adlr_file;
            matchfile = make_empty_struct_from_cell({'cdpname','casname','adlrname','date'});
            n = numel(cdpfile); %% cdp has the least observation days
            
            for i=1:n
                matchfile(i).('cdpname') = cdpfile(i).('name');
                matchfile(i).('date') = datestr(cdpfile(i).('date'));
                matchfile(i).('casname') = casfile(extractfield(casfile,'date') == cdpfile(i).('date')).('name');
                matchfile(i).('adlrname') = adlrfile(extractfield(adlrfile,'date') == cdpfile(i).('date')).('name');
            end
            
            
        end
        
        
        
        function time = common_utcsec(t1,t2,t3)
            time = unique([t1,t2,t3]);
            indx = false(size(time));
            for i=1:numel(time)
                if ismember(time(i), t1) && ismember(time(i), t2) && ismember(time(i), t3)
                    indx(i) = true;
                end
            end
            time = time(indx);
        end
        
        function cdpdata = read_cdp_data(cpdname, cutoff_bins, cutoff_effrad)
            file = csvread(cpdname,3,0);
            cdpdata = make_empty_struct_from_cell({'utcsec','meandp','nconc'});
            
            cdpdata.utcsec = fix(file(:,1));
            
            lowdp = misc_halo_analysis_bins.cdp_diameter().low;
            updp = misc_halo_analysis_bins.cdp_diameter().up;
            meandp = (lowdp+updp)/2;
%             dlogdp = log(updp)-log(lowdp);

            nconc_by_bins = zeros([size(cdpdata.utcsec), 15]);
            
            file_shift = 3;
            if cutoff_bins == true %only take mean diameter >3um (per Braga, 2017)
                dp_shift = 1;
            else               
                dp_shift = 0;
            end
            
            chop_bins = false;
            for i_bin = 1+dp_shift:numel(lowdp)
                bin_indx = i_bin + file_shift;
                
                if i_bin == 1+dp_shift && chop_bins == true
                    disp('warning: chopping bins!')
                    chop_factor = 20.0/21.0;
                    meandp(2) = 4;
                else
                    chop_factor = 1.0;
                end
                
                nconc_by_bins(:, i_bin - dp_shift) = chop_factor*file(:,bin_indx)./file(:,3); %third column is sample volume, bins are ptcl count 
                
                % ignore the missing value
                indx = file(:,bin_indx) == 999999;
                nconc_by_bins(indx, i_bin - dp_shift) = nan;         
            end
            
            cdpdata.bin1 = nconc_by_bins(:,1);
            cdpdata.bin2 = nconc_by_bins(:,2);
            cdpdata.bin3 = nconc_by_bins(:,3);
            cdpdata.bin4 = nconc_by_bins(:,4);
            cdpdata.bin5 = nconc_by_bins(:,5);
            cdpdata.bin6 = nconc_by_bins(:,6);
            cdpdata.bin7 = nconc_by_bins(:,7);
            cdpdata.bin8 = nconc_by_bins(:,8);
            cdpdata.bin9 = nconc_by_bins(:,9);
            cdpdata.bin10 = nconc_by_bins(:,10);
            cdpdata.bin11 = nconc_by_bins(:,11);
            cdpdata.bin12 = nconc_by_bins(:,12);
            cdpdata.bin13 = nconc_by_bins(:,13);
            cdpdata.bin14 = nconc_by_bins(:,14);
            cdpdata.bin15 = nconc_by_bins(:,15);

        end
        
        function casdata = read_cas_data(casname, cutoff_bins, cutoff_effrad, change_cas_corr)
            file = csvread(casname, 3, 0);            
            casdata = make_empty_struct_from_cell({'utcsec','meandp','nconc','lwc'});
            
            casdata.utcsec = fix(file(:,1));          
            
            lowdp = misc_halo_analysis_bins.cas_diameter().low;
            updp = misc_halo_analysis_bins.cas_diameter().up;
            meandp = (lowdp+updp)/2;
            
            nconc_by_bin = zeros([size(casdata.utcsec), 12]);
            
            file_shift = 1;
            if cutoff_bins == true %compare to david's results - take bins incl. mean diameter <3um (cf Braga, 2017)
                dp_shift = 0;
            else
                dp_shift = 0;
            end            
            chop_bins = false;
            for i_bin = 1+dp_shift:numel(lowdp)
                bin_indx = i_bin + file_shift;
                if i_bin == 12 && chop_bins
                    disp('warning: chopping bins!')
                    chop_factor = 1.0/5.0;
                    meandp(12) = 45.5;
                else
                    chop_factor = 1.0;
                end
                
                if change_cas_corr == true %**note**: only corrects nconc and meandp in current version.
                    corr_factor = file(:,19).*file(:,20)./file(:,18);
                else
                    corr_factor = 1;
                end

                nconc_by_bins(:, i_bin - dp_shift) = chop_factor*corr_factor.*file(:,bin_indx);

                % ignore the missing value
                neg_indx = file(:,bin_indx) < 0;
                nconc_by_bins(neg_indx,i_bin - dp_shift) = nan;
                inf_indx = nconc_by_bins(:, i_bin - dp_shift) == inf;
                nconc_by_bins(inf_indx,i_bin - dp_shift) = nan;
            end

            casdata.bin1 = nconc_by_bins(:,1);
            casdata.bin2 = nconc_by_bins(:,2);
            casdata.bin3 = nconc_by_bins(:,3);
            casdata.bin4 = nconc_by_bins(:,4);
            casdata.bin5 = nconc_by_bins(:,5);
            casdata.bin6 = nconc_by_bins(:,6);
            casdata.bin7 = nconc_by_bins(:,7);
            casdata.bin8 = nconc_by_bins(:,8);
            casdata.bin9 = nconc_by_bins(:,9);
            casdata.bin10 = nconc_by_bins(:,10);
            casdata.bin11 = nconc_by_bins(:,11);
            casdata.bin12 = nconc_by_bins(:,12);

        end
        
        function adlrdata = read_adlr_data(adlrname, cutoff_temp)
            file = csvread(adlrname, 3, 0);
            adlrdata = make_empty_struct_from_cell({'utcsec','temp','w','alt'});
            adlrdata.utcsec = fix(file(:,1));
            adlrdata.alt = file(:,5);
            adlrdata.temp = file(:,21);
            adlrdata.w = file(:,18);
            adlrdata.w(adlrdata.w<=-100) = nan;
            adlrdata.temp(adlrdata.temp<=-100) = nan;
            if cutoff_temp == true
                adlrdata.temp(adlrdata.temp<=273) = nan;
            end
        end
        
        function struc_field = struct_filter(istruc, target_sec, fieldname)
            istruc_field = extractfield(istruc, fieldname);
            istruc_utcsec = extractfield(istruc, 'utcsec');
            struc_field = nan(size(target_sec));
            for i=1:numel(target_sec)
                indx = istruc_utcsec == target_sec(i);
                struc_field(i) = nanmean(istruc_field(indx));
            end
        end
        
        %%%%%%%%%%%%%%%%%%%
        % Make methods    %
        %%%%%%%%%%%%%%%%%%%
        
        % return a data struct including all necessary fields for future
        % calculation/analysis
        function make_match_data(cutoff_bins, cutoff_temp, cutoff_effrad, change_cas_corr)
            matchfile = misc_halo_analysis_bins.read_file_match;
            match = make_empty_struct_from_cell({'utcsec','date',...
                'cdpbin1','cdpbin2','cdpbin3','cdpbin4','cdpbin5','cdpbin6','cdpbin7','cdpbin8','cdpbin9','cdpbin10','cdpbin11','cdpbin12',...
                'cdpbin13','cdpbin14','cdpbin15','casbin1','casbin2','casbin3','casbin4','casbin5','casbin6','casbin7','casbin8','casbin9','casbin10',});
            for i_date = 1:numel(matchfile)
                cdpdata = misc_halo_analysis_bins.read_cdp_data(matchfile(i_date).cdpname, cutoff_bins, cutoff_effrad);
                casdata = misc_halo_analysis_bins.read_cas_data(matchfile(i_date).casname, cutoff_bins, cutoff_effrad, change_cas_corr);
                adlrdata = misc_halo_analysis_bins.read_adlr_data(matchfile(i_date).adlrname, cutoff_temp);
                % do data filter based on the utcsec
                match(i_date).date = matchfile(i_date).date;
                match(i_date).utcsec = misc_halo_analysis_bins.common_utcsec(extractfield(cdpdata,'utcsec'), extractfield(casdata,'utcsec'), extractfield(adlrdata,'utcsec'));
                
                %cdp_indx = ismember(cdpdata.utcsec, match(i_date).utcsec);
                
                match(i_date).cdpbin1 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin1');
                match(i_date).cdpbin2 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin2');
                match(i_date).cdpbin3 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin3');
                match(i_date).cdpbin4 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin4');
                match(i_date).cdpbin5 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin5');
                match(i_date).cdpbin6 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin6');
                match(i_date).cdpbin7 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin7');
                match(i_date).cdpbin8 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin8');
                match(i_date).cdpbin9 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin9');
                match(i_date).cdpbin10 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin10');
                match(i_date).cdpbin11 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin11');
                match(i_date).cdpbin12 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin12');
                match(i_date).cdpbin13 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin13');
                match(i_date).cdpbin14 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin14');
                match(i_date).cdpbin15 = misc_halo_analysis_bins.struct_filter(cdpdata, match(i_date).utcsec, 'bin15');
              
                match(i_date).casbin1 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin1');
                match(i_date).casbin2 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin2');
                match(i_date).casbin3 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin3');
                match(i_date).casbin4 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin4');
                match(i_date).casbin5 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin5');
                match(i_date).casbin6 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin6');
                match(i_date).casbin7 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin7');
                match(i_date).casbin8 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin8');
                match(i_date).casbin9 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin9');
                match(i_date).casbin10 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin10');
                match(i_date).casbin11 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin11');
                match(i_date).casbin12 = misc_halo_analysis_bins.struct_filter(casdata, match(i_date).utcsec, 'bin12');
            end
            
            if cutoff_bins == true
                save('halo_match_3um_bin_cutoff_chopped_v4.mat','match');
            elseif cutoff_temp == true
                save('halo_match_0C_temp_cutoff.mat','match');
            elseif cutoff_effrad == true
                save('halo_match_5to13um_effrad_cutoff.mat','match');
            elseif change_cas_corr == true
                save('halo_match_change_cas_corr_bins.mat','match');
            else
                save('halo_match_bins.mat','match');
            end
        end
        
        end       
end