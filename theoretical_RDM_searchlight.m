cosmomvpaToolboxRoot = '~/lib/MATLAB/CoSMoMVPA/'; addpath(genpath(cosmomvpaToolboxRoot));
input_path_RDMs = 'RDMs_theoretical';
input_path_fMRI = 'fMRI_zmaps';
subjects = {'1606'};
conditions = {'BF_Happy' 'BF_Fear' 'BF_Neu' 'FR_Happy' 'FR_Fear' 'FR_Neu' 'STR_Happy' 'STR_Fear' 'STR_Neu'};

nr_subjects = length(subjects);
nr_conditions = length(conditions);

% load(fullfile(input_path_RDMs, 'emo_RDM.mat'));
load(fullfile(input_path_RDMs, 'fam_RDM.mat'));

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
    args.target_dsm = fam_RDM;
    args.metric = 'correlation';
    rsa_theoretical = cosmo_searchlight(fMRI_dataset, neighborhood, @cosmo_target_dsm_corr_measure, args);
    cosmo_plot_slices(rsa_theoretical);
end
