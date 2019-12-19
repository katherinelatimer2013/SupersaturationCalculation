%%% Create LAYER0pt5 in BG and PI datasets
%%% This layer contains functions of LAYER0 data and also uses dsd output
%%% files from wrf simulations

%%% Required files: BG_dataset_LAYER0.mat, 
%%%                 PI_dataset_LAYER0.mat, 
%%%                 read_wrf_study_domain_dsd.mat

%%% Output files: BG_dataset_LAYER0pt5.mat,
%%%               PI_dataset_LAYER0pt5.mat

% rhoo = 1.2754;% dry air std density kg/m^3
% Po = 1000;    % dry air std pressure hPa
% To = 273.15;  % dry air std temp K
% R = 8.314; % ideal gas const J/(mol K)
% vB = 4.1782e-5; % Boyle volume 1/(m^3 mol)
% TB = 1408.4; % Boyle temp K
% bSTAR = 1.0823*vB; % empirical constant 1/(m^3 mol)
% aVW = 0.5542; % empirical constant Pa m^6 1/mol^2
% alpha = 2.145*vB; % empirical constant 1/(m^3 mol)
% lambda = 0.3159; % empirical constant
% b0 = 0.25; % empirical constant
% b1 = 0.02774; % empirical constant
% b2 = 0.23578; % empirical constant

load('read_wrf_study_domain_dsd.mat');
% load('BG_dataset_LAYER0.mat');

% T = LAYER0_BG.T;
% P = LAYER0_BG.P;

ff = zeros([15, size(BG.ff1i01)]);
lwc_by_bin = zeros([15, size(BG.ff1i01)]);
% Nw_by_bin = zeros([15, size(BG.ff1i01)]);
% Nw_first_radial_moment_by_bin = zeros([15, size(BG.ff1i01)]);

BG_fieldnames = fieldnames(BG);

% % hack to make matlab not break bc of array dimensions
% T_by_bin = zeros([1, size(BG.ff1i01)]);
% P_by_bin = zeros([1, size(BG.ff1i01)]);
% T_by_bin(1, :, :, :) = T;
% P_by_bin(1, :, :, :) = P;
% rho_air = rhoo*To/Po.*P_by_bin(1, :, :, :)./T_by_bin(1, :, :, :); % density of dry air kg/m^3

% % liquid water density calculated based on quasi-empirical EOS from Jeffery
% % and Austin (1999)
% b = (b0*exp(0.5)*exp(2.3/TB*T) - b1*exp(2.3/TB*T) + b2)*vB;
% A = (ones(size(T))*bSTAR + aVW/R*1./T).*(lambda*b);
% B = ones(size(T))*alpha - lambda*b - (ones(size(T))*bSTAR + aVW/R*1./T);
% C = ones(size(T)) + lambda*b.*(100/R*P./T); %convert from hPa to Pa
% D = -100/R*P./T;
% rho_wat = zeros([1, size(T)]);
% disp('calc water density')
% for i = 1:size(T, 1)
%     disp(i)
%     for j = 1:size(T, 2)
%         for k = 1:size(T, 3)
%             rhoroots = roots([A(i, j, k), B(i, j, k), C(i, j, k), D(i, j, k)]);
%             rho_wat(1, i, j, k) = max(rhoroots)*0.018; % convert molar density to mass density kg/m^3
%         end
%     end
% end
% save('rho_wat.mat', 'rho_wat');

% disp('calc lwc and nconc')
for i = 1:15
%     disp(i)
%     r = bin_diameter(i)/2;
    ff(i, :, :, :) = getfield(BG, BG_fieldnames{i});
    lwc_by_bin(i, :, :, :) = ff(i, :, :, :)*2^(i-1);
%     Nw_by_bin(i, :, :, :) = (ff(i, :, :, :)/2^(i-1)).*rho_air./(4/3*pi*r^3*rho_wat);
%     Nw_first_radial_moment_by_bin(i, :, :, :) = Nw_by_bin(i, :, :, :)*r;
end

LAYER0pt5_BG.lwc = sum(lwc_by_bin, 1);
% LAYER0pt5_BG.Nw_kt = sum(Nw_by_bin, 1);
% LAYER0pt5_BG.rmeanw = sum(Nw_first_radial_moment_by_bin, 1)./LAYER0pt5_BG.Nw_kt;
save('BG_dataset_LAYER0pt5', 'LAYER0pt5_BG');

% load('PI_dataset_LAYER0.mat');

% T = LAYER0_PI.T;
% P = LAYER0_PI.P;

ff = zeros([15, size(PI.ff1i01)]);
lwc_by_bin = zeros([15, size(PI.ff1i01)]);
% Nw_by_bin = zeros([15, size(PI.ff1i01)]);
% Nw_first_radial_moment_by_bin = zeros([15, size(PI.ff1i01)]);

PI_fieldnames = fieldnames(PI);

% % hack to make matlab not break bc of array dimensions
% T_by_bin = zeros([1, size(PI.ff1i01)]);
% P_by_bin = zeros([1, size(PI.ff1i01)]);
% T_by_bin(1, :, :, :) = T;
% P_by_bin(1, :, :, :) = P;
% rho_air = rhoo*To/Po.*P_by_bin(1, :, :, :)./T_by_bin(1, :, :, :); % density of dry air kg/m^3

% % liquid water density calculated based on quasi-empirical EOS from Jeffery
% % and Austin (1999)
% b = (b0*exp(0.5)*exp(2.3/TB*T) - b1*exp(2.3/TB*T) + b2)*vB;
% A = (ones(size(T))*bSTAR + aVW/R*1./T).*(lambda*b);
% B = ones(size(T))*alpha - lambda*b - (ones(size(T))*bSTAR + aVW/R*1./T);
% C = ones(size(T)) + lambda*b.*(100/R*P./T); %convert from hPa to Pa
% D = -100/R*P./T;
% rho_wat = zeros([1, size(T)]);
% disp('calc water density')
% for i = 1:size(T, 1)
%     disp(i)
%     for j = 1:size(T, 2)
%         for k = 1:size(T, 3)
%             rhoroots = roots([A(i, j, k), B(i, j, k), C(i, j, k), D(i, j, k)]);
%             rho_wat(1, i, j, k) = max(rhoroots)*0.018; % convert molar density to mass density kg/m^3
%         end
%     end
% end
% save('rho_wat.mat', 'rho_wat');

% disp('calc lwc and nconc')
for i = 1:15
%     disp(i)
%     r = bin_diameter(i)/2;
    ff(i, :, :, :) = getfield(PI, PI_fieldnames{i});
    lwc_by_bin(i, :, :, :) = ff(i, :, :, :)*2^(i-1);
%     Nw_by_bin(i, :, :, :) = (ff(i, :, :, :)/2^(i-1)).*rho_air./(4/3*pi*r^3*rho_wat);
%     Nw_first_radial_moment_by_bin(i, :, :, :) = Nw_by_bin(i, :, :, :)*r;
end

LAYER0pt5_PI.lwc = sum(lwc_by_bin, 1);
% LAYER0pt5_PI.Nw_kt = sum(Nw_by_bin, 1);
% LAYER0pt5_PI.rmeanw = sum(Nw_first_radial_moment_by_bin, 1)./LAYER0pt5_PI.Nw_kt;
save('PI_dataset_LAYER0pt5', 'LAYER0pt5_PI');
