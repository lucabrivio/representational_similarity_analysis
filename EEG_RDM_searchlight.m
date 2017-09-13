cosmomvpaToolboxRoot = '~/lib/MATLAB/CoSMoMVPA/'; addpath(genpath(cosmomvpaToolboxRoot));
input_path_EEG = 'EEG_txtfiles_RSA';
input_path_fMRI = 'fMRI_zmaps';
subjects = {'1606'};
conditions = {'BF_Happy' 'BF_Fear' 'BF_Neu' 'FR_Happy' 'FR_Fear' 'FR_Neu' 'STR_Happy' 'STR_Fear' 'STR_Neu'};
nr_electrodes = 64;
nr_timePoints = 225;

nr_subjects = length(subjects);
nr_conditions = length(conditions);

% EEG
EEG_timepoint_RDMs = zeros(nr_conditions,nr_conditions,nr_timePoints,nr_subjects);
for currSubject = 1:nr_subjects
    Ave_Conditions = zeros(nr_electrodes,nr_timePoints,nr_conditions);
    for i = 1:nr_conditions
        Ave_Conditions(:,:,i) = table2array(readtable(fullfile(input_path_EEG, strcat(subjects{currSubject}, '_faces_Ave_', conditions{i}, '.txt')),'ReadRowNames',true));
    end
    A = zeros(nr_electrodes,nr_conditions,nr_timePoints);
    for i = 1:nr_timePoints
        A(:,:,i) = Ave_Conditions(:,i,:);
        EEG_timepoint_RDMs(:,:,i,currSubject) = 1 - corrcoef(A(:,:,i));
    end
%     Mean_RDM = mean(EEG_timepoint_RDMs,3);
end


% fMRI searchlight
for currSubject = 1 : nr_subjects

    for currCondition = 1 : nr_conditions
        currFilename = fullfile(input_path_fMRI, strcat(subjects{currSubject}, '_', conditions{currCondition}, '.nii'));
        if (currCondition == 1)
            fMRI_dataset = cosmo_fmri_dataset(currFilename, 'mask', false);
        else
            fMRI_dataset = cosmo_stack({fMRI_dataset, cosmo_fmri_dataset(currFilename, 'mask', false)}, 1);
        end
    end
    fMRI_dataset.sa.targets = (1 : nr_conditions)';
    fMRI_dataset.sa.chunks = ones(nr_conditions, 1);

    neighborhood = cosmo_spherical_neighborhood(fMRI_dataset, 'radius', 4);
    args = struct();
    args.target_dsm = EEG_timepoint_RDMs(:,:,1,currSubject);
    args.metric = 'correlation';
    rsa_time1 = cosmo_searchlight(fMRI_dataset, neighborhood, @cosmo_target_dsm_corr_measure, args);
    cosmo_plot_slices(rsa_time1);
end
