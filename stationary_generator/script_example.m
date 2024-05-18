
% This script shows how to use the streamflow generator available in the
% Kirsch-Nowak_Streamflow_Generator repository on a test dataset 
% (Periyar River Basin).
%
% Copyright 2017 Matteo Giuliani, Jon Herman and Julianne Quinn
% 


%% prepare workspace
clear all
clc

% load multi-site observations of daily streamflow
Qdaily = load('E:\OneDrive - Indian Institute of Technology Bombay\APS3\Kirsch-Nowak_Streamflow_Generator-master\data\Qdaily.txt');

% make normally distributed evaporation log-normal like flows
% (monthly_gen.m takes the log of Qdaily to make all columns normally
% distributed)
sites = {'qIdukki'};
Nyears = size(Qdaily,1)/365;
% Nsites = size(Qdaily,2);


%% Kirsch + Nowak generation
clc
% 100 realizations of 100 years
% and then 1000 realizations of 1 year
num_realizations = 100000;
num_years = 1;
dimensions = {'-100000x1'};
% directory to write output to
% mkdir('E:\OneDrive - Indian Institute of Technology Bombay\APS3\Kirsch-Nowak_Streamflow_Generator-master\validation\synthetic');
for k=1:length(num_realizations)
    Qd_cg = combined_generator(Qdaily, num_realizations(k), num_years(k) );
    % write simulated data to file
    for i=1
        q_ = [];
        for j=1:num_realizations(k)
            qi = nan(365*num_years(k),1);
            qi(1:size(Qd_cg,2)) = Qd_cg(j,:,i)';
            q_ = [q_ reshape(qi,365,num_years(k))];
        end
        Qd2(:,i) = reshape(q_(:),[],1);
        saveQ = reshape(Qd2(:,i), num_years(k)*365, num_realizations(k))';
        dlmwrite(['E:\OneDrive - Indian Institute of Technology Bombay\APS3\Kirsch-Nowak_Streamflow_Generator-master\validation\synthetic' sites{i} dimensions{k} '-daily.csv'], saveQ);
    end
    synMonthlyQ = convert_data_to_monthly(Qd2);
    for i=1
        saveMonthlyQ = reshape(synMonthlyQ{i}',12*num_years(k),num_realizations(k))';
        dlmwrite(['E:\OneDrive - Indian Institute of Technology Bombay\APS3\Kirsch-Nowak_Streamflow_Generator-master\validation\synthetic' sites{i} dimensions{k} '-monthly.csv'], saveMonthlyQ);
    end
    dlmwrite(['E:\OneDrive - Indian Institute of Technology Bombay\APS3\Kirsch-Nowak_Streamflow_Generator-master\validation\synthetic\Qdaily' dimensions{k} '.csv'], Qd2);
    clear Qd2;
end


% %% Plotting
% 
% % Step 1: Calculate the mean across the 100 realizations for each month
% mean_across_realizations = mean(S,1);
% 
% % Step 2: Calculate the historical mean for each month from the idukki_inflow variable
% idukki_inflow = readmatrix('qIdukki-monthly.csv');
% historical_mean = mean(idukki_inflow, 1);
% 
% % Step 3: Plot both means on the same plot
% months = {'Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec'};
% figure;
% plot(1:12, mean_across_realizations, 'b.-', 'LineWidth', 2, 'MarkerSize', 15);
% hold on;
% plot(1:12, historical_mean, 'r.-', 'LineWidth', 2, 'MarkerSize', 15);
% hold off;
% 
% xlabel('Month',"FontSize",12);
% ylabel('Inflow (Mm3)',"FontSize",12);
% title('Observed Vs Synthetic',"FontSize",12);
% legend('Synthetic', 'Observed', 'Location', 'best');
% 
% % Set the x-axis tick labels to month names
% xticks(1:12);
% xticklabels(months);
% xlim([0, 13]);
% f=gca;
% set(f, 'XTickLabelRotation', 0);
% 
% exportgraphics(f,'Mean inflow.png','Resolution',300)
% 
% 
