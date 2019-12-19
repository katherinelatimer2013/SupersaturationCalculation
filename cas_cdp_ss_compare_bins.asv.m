classdef misc_halo_analysis
    methods(Static = true)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % Property like methods %
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        function value = box_dir()
            value = 'C:\Users\Katherine\Documents\Berkeley Grad\eps_work\insanity closet';
        end
        
        function value = halo_csv_dir()
            value = fullfile(misc_halo_analysis.box_dir, 'HALO_cleanup_csv');
        end
        
        function Dp = cdp_diameter(cutoff_bins)
            if cutoff_bins ~= true
                Dp = struct('low',[2.5, 2.9, 5, 7.5, 10.2, 11.8, 15.6, 18.7, 20.7, 24.6, 27.4, 29.2, 34.4, 39, 42.5],...
                            'up',[2.9, 5, 7.5, 10.2, 11.8, 15.6, 18.7, 20.7, 24.6, 27.4, 29.2, 34.4, 39, 42.5, 46],...
                            'mean',[2.69, 3.81, 6.12, 8.75, 10.97, 13.57, 17.08, 19.67, 22.57, 25.96, 28.29, 31.69, 36.63, 40.71, 44.22]);
            else
                Dp = struct('low',[2.9, 5, 7.5, 10.2, 11.8, 15.6, 18.7, 20.7, 24.6, 27.4, 29.2, 34.4, 39, 42.5],...
                            'up',[5, 7.5, 10.2, 11.8, 15.6, 18.7, 20.7, 24.6, 27.4, 29.2, 34.4, 39, 42.5, 46],...
                            'mean',[3.81, 6.12, 8.75, 10.97, 13.57, 17.08, 19.67, 22.57, 25.96, 28.29, 31.69, 36.63, 40.71, 44.22]);
            end
        end
        
        function Dp = cas_diameter(cutoff_bins)
            % remaining issue, the first two bins may be aerosols instead
            % of cloud droplet
            if cutoff_bins ~= true
                Dp = struct('low',[0.89,0.96,3,5,7.2,15,20,25,30,35,40,45],...
                            'up',[0.96,3,5,7.2,15,20,25,30,35,40,45,50]);
            else
                Dp = struct('low',[3,5,7.2,15,20,25,30,35,40,45],...
                            'up',[5,7.2,15,20,25,30,35,40,45,50]);
            end
                    
        end
        %%%%%%%%%%%%%%%%%%%
        % Utility methods %
        %%%%%%%%%%%%%%%%%%%
        
        % return CDPFILE structure including two fields, filename
        % and the date extracted from the filename
        function cdpfile = read_cdp_file()
            filepattern = '*CCP_CDP*';
            cdpdir = dir(fullfile(misc_halo_analysis.halo_csv_dir, filepattern));
            cdpfile = make_empty_struct_from_cell({'name','date'});
            for i=1:numel(cdpdir)
                cdpfile(i).('name') = fullfile(misc_halo_analysis.halo_csv_dir, cdpdir(i).name);
                cdpfile(i).('date') = datenum(misc_halo_analysis.date_from_halo_filename(cdpdir(i).name));
            end
        end
        
        function casfile = read_cas_file()
            %disp('hello again')
            filepattern = '*CAS_DPOL*';
            %disp(misc_halo_analysis.halo_csv_dir)
            casdir = dir(fullfile(misc_halo_analysis.halo_csv_dir, filepattern));
            %disp(casdir)
            casfile = make_empty_struct_from_cell({'name','date'});
            for i=1:numel(casdir)
                casfile(i).('name') = fullfile(misc_halo_analysis.halo_csv_dir, casdir(i).name);
                % time formate dd_mm_yyyy
                thisdate = regexp(casdir(i).name, '\d\d_\d\d_\d\d\d\d','match','once');
                casfile(i).('date') = datenum(strcat(thisdate(7:10),'-',thisdate(4:5),'-',thisdate(1:2)));
            end
        end
        
        function adlrfile = read_adlr_file()
            filepattern = '*adlr*';
            adlrdir = dir(fullfile(misc_halo_analysis.halo_csv_dir, filepattern));
            %disp(struct2table(adlrdir))
            adlrfile = make_empty_struct_from_cell({'name','date'});
            for i=1:numel(adlrdir)
                adlrfile(i).('name') = fullfile(misc_halo_analysis.halo_csv_dir, adlrdir(i).name);
                adlrfile(i).('date') = datenum(misc_halo_analysis.date_from_halo_filename(adlrdir(i).name));
            end
        end
        
        function date = date_from_halo_filename(filename)
            % the date formate is yyyymmdd
            dstr = regexp(filename, '\d\d\d\d\d\d\d\d','match','once');
            date = strcat(dstr(1:4),'-',dstr(5:6),'-',dstr(7:8));
        end
        
        function matchfile = read_file_match()
            %disp('hello')
            cdpfile = misc_halo_analysis.read_cdp_file;
            casfile = misc_halo_analysis.read_cas_file;
            adlrfile = misc_halo_analysis.read_adlr_file;
            %disp(casfile)
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
%             cdpdata.meandp_file = file(:,2);% convert from diameter to radius
%             
%             cdpdata.effrad_calc_numerator = zeros(size(cdpdata.utcsec));%effective radius as defined in Braga, 2017 
%             cdpdata.effrad_calc_denominator = zeros(size(cdpdata.utcsec)); 
            
            lowdp = misc_halo_analysis.cdp_diameter(cutoff_bins).low;
            updp = misc_halo_analysis.cdp_diameter(cutoff_bins).up;
            meandp = (lowdp+updp)/2;
%             dlogdp = log(updp)-log(lowdp);
            
%             nconc = zeros(size(cdpdata.utcsec));
            nconc_by_bins = zeros([size(cdpdata.utcsec), 15]);
%             meandp_time_nconc = zeros(size(cdpdata.utcsec));
%             lwc_calc = zeros(size(cdpdata.utcsec)); %calculated using rho_h2o = 1g/cm^3 after Braga, 2017...but their formula is wrong so not using it.
%             effrad_calc_numerator = zeros(size(cdpdata.utcsec));
%             effrad_calc_denominator = zeros(size(cdpdata.utcsec));
            
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
%                     if cutoff_bins == true
%                         meandp(1) = 4.0;
%                     else
%                         meandp(2) = 4.0;
%                     end
                else
                    chop_factor = 1.0;
                end
                
%                 nconc = nconc + chop_factor*file(:,bin_indx)./file(:,3); %third column is sample volume, bins are ptcl count 
                nconc_by_bins(:, i_bin - dp_shift) = chop_factor*file(:,bin_indx)./file(:,3); %third column is sample volume, bins are ptcl count 
%                 meandp_time_nconc = meandp_time_nconc + chop_factor*file(:,bin_indx)./file(:,3)*meandp(i_bin);
%                 lwc_calc = lwc_calc + 10^(-12)*4*pi/3*(file(:,bin_indx)./file(:,3).*((0.5*meandp(i_bin)).^3));%convert radius to cm
%                 effrad_calc_numerator = effrad_calc_numerator + (file(:,bin_indx)./file(:,3).*((0.5*meandp(i_bin)).^3.*(0.5*updp(i_bin) - 0.5*lowdp(i_bin))));
%                 effrad_calc_denominator = effrad_calc_denominator + (file(:,bin_indx)./file(:,3).*((0.5*meandp(i_bin)).^2.*(0.5*updp(i_bin) - 0.5*lowdp(i_bin))));
                
                % ignore the missing value
                indx = file(:,bin_indx) == 999999;
%                 nconc(indx) = nan;
                nconc_by_bins(indx, i_bin) = nan;
%                 meandp_time_nconc(indx) = nan;
%                 lwc_calc(indx) = nan;
%                 effrad_calc_numerator(indx) = nan;
%                 effrad_calc_denominator(indx) = nan;            
            end
            
%             cdpdata.meandp = meandp_time_nconc./nconc;
%             cdpdata.nconc = nconc;
%             cdpdata.lwc_calc = lwc_calc;
%             cdpdata.effrad_calc = effrad_calc_numerator./effrad_calc_denominator;
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
            
            % remove the filling value
%             cdpdata.meandp(cdpdata.meandp > 10000 | cdpdata.meandp < 0 )= nan;
%             cdpdata.nconc(cdpdata.nconc > 10000 | cdpdata.nconc < 0) = nan;
%             cdpdata.lwc_calc(cdpdata.lwc_calc > 10000 | cdpdata.lwc_calc < 0) = nan;
%             cdpdata.effrad_calc(cdpdata.effrad_calc > 10000 | cdpdata.effrad_calc < 0) = nan;
%             if cutoff_effrad == true
%                 cdpdata.effrad_calc(cdpdata.effrad_calc > 13 | cdpdata.effrad_calc < 5) = nan;
%             end
        end
        
        function casdata = read_cas_data(casname, cutoff_bins, cutoff_effrad, change_cas_corr)
            file = csvread(casname, 3, 0);            
            casdata = make_empty_struct_from_cell({'utcsec','meandp','nconc','lwc'});
            
            casdata.utcsec = fix(file(:,1));
%             casdata.lwc_file = file(:,end-3)*10^(-6);%change to g/cm^3
%             casdata.effrad_file = file(:,15)/2;%effective radius as defined in Braga, 2017 (from file directly) - convert from diameter to radius
%             
%             casdata.effrad_calc_numerator = zeros(size(casdata.utcsec));%effective radius as defined in Braga, 2017 (calculate to check against file value)
%             casdata.effrad_calc_denominator = zeros(size(casdata.utcsec));           
            
            lowdp = misc_halo_analysis.cas_diameter(cutoff_bins).low;
            updp = misc_halo_analysis.cas_diameter(cutoff_bins).up;
            meandp = (lowdp+updp)/2;
            
%             nconc = zeros(size(casdata.utcsec));
            nconc_by_bins = zeros([size(casdata.utcsec), 10]);
%             nconc_by_bin = zeros([size(casdata.utcsec), 12]);
%             meandp_time_nconc = zeros(size(casdata.utcsec));
%             lwc_calc = zeros(size(casdata.utcsec)); %calculated using rho_h2o = 1g/cm^3 after Braga, 2017...but their formula is wrong so not using it.
%             effrad_calc_numerator = zeros(size(casdata.utcsec));
%             effrad_calc_denominator = zeros(size(casdata.utcsec));
            
            file_shift = 1;
            if cutoff_bins == true %only take mean diameter >3um (per Braga, 2017)
                dp_shift = 2;
            else
                dp_shift = 2;
            end
            
            chop_bins = false;
            for i_bin = 1+dp_shift:numel(lowdp)
                bin_indx = i_bin + file_shift;
                if i_bin == 12 && chop_bins
                    disp('warning: chopping bins!')
                    chop_factor = 1.0/5.0;
                    meandp(12) = 45.5;
%                     if cutoff_bins == true
%                         meandp(11) = 45.5;
%                     else
%                         meandp(12) = 45.5;
%                     end
                else
                    chop_factor = 1.0;
                end
                
                if change_cas_corr == true %**note**: only corrects nconc and meandp in current version.
                    corr_factor = file(:,19).*file(:,20)./file(:,18);
                else
                    corr_factor = 1;
                end
                
%                 nconc = nconc+chop_factor*corr_factor.*file(:,bin_indx);
                nconc_by_bins(:, i_bin - dp_shift) = chop_factor*corr_factor.*file(:,bin_indx);
%                 nconc_by_bin(:,i_bin) = chop_factor*corr_factor.*file(:,bin_indx);
%                 meandp_time_nconc = meandp_time_nconc + chop_factor*corr_factor.*file(:,bin_indx)*meandp(i_bin);
%                 disp(size(lwc_calc))
%                 disp(size(10^(-12)*4*pi/3*(file(:,bin_indx).*(0.5*meandp(i_bin).^3))))
%                 lwc_calc = lwc_calc + 10^(-12)*4*pi/3*(file(:,bin_indx).*((0.5*meandp(i_bin)).^3));%convert radius to cm
%                 effrad_calc_numerator = effrad_calc_numerator + (file(:,bin_indx).*((0.5*meandp(i_bin)).^3.*(0.5*updp(i_bin) - 0.5*lowdp(i_bin))));
%                 effrad_calc_denominator = effrad_calc_denominator + (file(:,bin_indx).*((0.5*meandp(i_bin)).^2.*(0.5*updp(i_bin) - 0.5*lowdp(i_bin))));
%                 if i_bin == 1
%                     disp(effrad_calc_denominator)
%                 end
                % ignore the missing value
                indx = file(:,bin_indx) < 0;
%                 nconc(indx) = nan;
                nconc_by_bin(indx,:) = nan;
%                 meandp_time_nconc(indx) = nan;
%                 lwc_calc(indx) = nan;
%                 effrad_calc_numerator(indx) = nan;
%                 effrad_calc_denominator(indx) = nan;
            end
            
%             casdata.meandp = meandp_time_nconc./nconc;
%             casdata.nconc = nconc;
%             casdata.nconc_by_bin = nconc_by_bin;
%             disp(size(nconc_by_bin))
%             disp(size(casdata.nconc_by_bin))
            casdata.lwc_calc = lwc_calc;
            casdata.effrad_calc = effrad_calc_numerator./effrad_calc_denominator;
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
            
            % remove the filling value
%             casdata.meandp(casdata.meandp > 10000 | casdata.meandp < 0 )= nan;
%             casdata.nconc(casdata.nconc > 10000 | casdata.nconc < 0) = nan;
%             casdata.lwc_file(casdata.lwc_file > 10000 | casdata.lwc_file < 0) = nan;
%             casdata.lwc_calc(casdata.lwc_calc > 10000 | casdata.lwc_calc < 0) = nan;
%             casdata.effrad_file(casdata.effrad_file > 10000 | casdata.effrad_file < 0 )= nan;
%             casdata.effrad_calc(casdata.effrad_calc > 10000 | casdata.effrad_calc < 0 )= nan;
%             if cutoff_effrad == true
%                 casdata.effrad_file(casdata.effrad_file > 13 | casdata.effrad_file < 5) = nan;
%                 casdata.effrad_calc(casdata.effrad_calc > 13 | casdata.effrad_calc < 5) = nan;
%             end
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
            matchfile = misc_halo_analysis.read_file_match;
            %disp(matchfile)
            match = make_empty_struct_from_cell({'utcsec','date',...
                'cdpbin1','cdpbin2','cdpbin3','cdpbin4','cdpbin5','cdpbin6','cdpbin7','cdpbin8','cdpbin9','cdpbin10','cdpbin11','cdpbin12',...
                'cdpbin13','cdpbin14','cdpbin15','casbin1','casbin2','casbin3','casbin4','casbin5','casbin6','casbin7','casbin8','casbin9','casbin10',});
            for i_date = 1:numel(matchfile)
                cdpdata = misc_halo_analysis.read_cdp_data(matchfile(i_date).cdpname, cutoff_bins, cutoff_effrad);
                casdata = misc_halo_analysis.read_cas_data(matchfile(i_date).casname, cutoff_bins, cutoff_effrad, change_cas_corr);
                adlrdata = misc_halo_analysis.read_adlr_data(matchfile(i_date).adlrname, cutoff_temp);
                % do data filter based on the utcsec
                match(i_date).date = matchfile(i_date).date;
                match(i_date).utcsec = misc_halo_analysis.common_utcsec(extractfield(cdpdata,'utcsec'), extractfield(casdata,'utcsec'), extractfield(adlrdata,'utcsec'));
                
                %cdp_indx = ismember(cdpdata.utcsec, match(i_date).utcsec);
                
                match(i_date).cdpbin1 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin1');
                match(i_date).cdpbin2 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin2');
                match(i_date).cdpbin3 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin3');
                match(i_date).cdpbin4 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin4');
                match(i_date).cdpbin5 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin5');
                match(i_date).cdpbin6 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin6');
                match(i_date).cdpbin7 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin7');
                match(i_date).cdpbin8 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin8');
                match(i_date).cdpbin9 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin9');
                match(i_date).cdpbin10 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin10');
                match(i_date).cdpbin11 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin11');
                match(i_date).cdpbin12 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin12');
                match(i_date).cdpbin13 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin13');
                match(i_date).cdpbin14 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin14');
                match(i_date).cdpbin15 = misc_halo_analysis.struct_filter(cdpdata, match(i_date).utcsec, 'bin15');
              
                match(i_date).casbin1 = misc_halo_analysis.struct_filter(casdata, match(i_date).utcsec, 'bin1');
                match(i_date).casbin2 = misc_halo_analysis.struct_filter(casdata, match(i_date).utcsec, 'bin2');
                match(i_date).casbin3 = misc_halo_analysis.struct_filter(casdata, match(i_date).utcsec, 'bin3');
                match(i_date).casbin4 = misc_halo_analysis.struct_filter(casdata, match(i_date).utcsec, 'bin4');
                match(i_date).casbin5 = misc_halo_analysis.struct_filter(casdata, match(i_date).utcsec, 'bin5');
                match(i_date).casbin6 = misc_halo_analysis.struct_filter(casdata, match(i_date).utcsec, 'bin6');
                match(i_date).casbin7 = misc_halo_analysis.struct_filter(casdata, match(i_date).utcsec, 'bin7');
                match(i_date).casbin8 = misc_halo_analysis.struct_filter(casdata, match(i_date).utcsec, 'bin8');
                match(i_date).casbin9 = misc_halo_analysis.struct_filter(casdata, match(i_date).utcsec, 'bin9');
                match(i_date).casbin10 = misc_halo_analysis.struct_filter(casdata, match(i_date).utcsec, 'bin10');
            end
            
            if cutoff_bins == true
                save('halo_match_3um_bin_cutoff_chopped_v4.mat','match');
            elseif cutoff_temp == true
                save('halo_match_0C_temp_cutoff.mat','match');
            elseif cutoff_effrad == true
                save('halo_match_5to13um_effrad_cutoff.mat','match');
            elseif change_cas_corr == true
                save('halo_match_change_cas_corr_v2.mat','match');
            else
                save('halo_match_v9.mat','match');
            end
        end
        
        end       
end