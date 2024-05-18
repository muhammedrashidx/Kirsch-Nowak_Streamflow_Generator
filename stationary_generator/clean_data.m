% This loads the mat files and combines the Q (Mm3/day) time series into one
% txt file. Removes leap years by averaging with the prior date.

clc; clear all;
datadir = './../data/';
files = { 'qIdukki_1990-2022.csv'};
hist_data = [];

% load the historical data
for i=1:length(files)
    M{i} = readmatrix([datadir   files{i}]);
end

% find indices of leap years
leaps = 731:365*3+366:365*(2022-1990+1)+ceil(2022-1990)/4;
all = 1:1:365*(2022-1990+1)+ceil(2020-1990)/4+1;
non_leaps = setdiff(all,leaps);

Qfinal = zeros(length(non_leaps),length(files));

for i=1:length(files)
    Q = M{i};
    Qfinal(:,i) = Q(non_leaps);
end

dlmwrite('./../data/Qdaily.txt', Qfinal, ' ');

% reshape into nyears x 365 and nyears x 12 for daily and monthly 
% statistical validation figures
Qfinal_monthly = convert_data_to_monthly(Qfinal);



% create directories to write files to
mkdir('./../validation/historical');
for i=1:length(files)
   q_nx365 = reshape(Qfinal(:,i),365, [])';
   dlmwrite(['./../validation/historical/' files{i}(1:(length(files{i})-14)) '-daily.csv'], q_nx365);
   dlmwrite(['./../validation/historical/' files{i}(1:(length(files{i})-14)) '-monthly.csv'], Qfinal_monthly{i}); 
end
