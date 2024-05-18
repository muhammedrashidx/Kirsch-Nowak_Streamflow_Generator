function Qmonthly = convert_data_to_monthly(Qt)

Nyears = size(Qt,1)/365;
Nmonths = 12;
DaysPerMonth = [31 28 31 30 31 30 31 31 30 31 30 31];

for i=1
    Qmonthly{i} = zeros(Nyears, Nmonths);
end

for year=1:Nyears
    for month=1:Nmonths
        
        start = (year-1)*365 + sum(DaysPerMonth(1:(month-1)))+1;
        
        % total flow in each month
        for i=1
            Qmonthly{i}(year,month) = sum(Qt(start:start+DaysPerMonth(month)-1,i));
        end
    end
end
end

