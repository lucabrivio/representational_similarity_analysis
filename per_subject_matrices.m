subjects = {'1603' '1604' '1605' '1606' '1607' '1608' '1609' '1611' '1612' '1613' '1615' '1616' '1617' '1618' '1619' '1620' '1621' '1622'};
conditions = {'BF_Happy' 'BF_Fear' 'BF_Neu' 'FR_Happy' 'FR_Fear' 'FR_Neu' 'STR_Happy' 'STR_Fear' 'STR_Neu'};
nr_electrodes = 64;
nr_timePoints = 225;

nr_subjects = length(subjects);
nr_conditions = length(conditions);

Timepoint_RDMs = zeros(nr_conditions,nr_conditions,nr_timePoints,nr_subjects);

for currSubject = 1:nr_subjects
    Ave_Conditions = zeros(nr_electrodes,nr_timePoints,nr_conditions);
    for i = 1:nr_conditions
        Ave_Conditions(:,:,i) = table2array(readtable(strcat(subjects{currSubject}, '_faces_Ave_', conditions{i}, '.txt'),'ReadRowNames',true));
    end
    A = zeros(nr_electrodes,nr_conditions,nr_timePoints);
    for i = 1:nr_timePoints
        A(:,:,i) = Ave_Conditions(:,i,:);
        Timepoint_RDMs(:,:,i,currSubject) = 1 - corrcoef(A(:,:,i));
    end
%     Mean_RDM = mean(Timepoint_RDMs,3);
end
