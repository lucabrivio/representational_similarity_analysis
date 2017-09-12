cosmomvpaToolboxRoot = '~/lib/MATLAB/CoSMoMVPA/'; addpath(genpath(cosmomvpaToolboxRoot));

subjects = {'1606'};
conditions = {'BF_Happy' 'BF_Fear' 'BF_Neu' 'FR_Happy' 'FR_Fear' 'FR_Neu' 'STR_Happy' 'STR_Fear' 'STR_Neu'};

nr_subjects = length(subjects);
nr_conditions = length(conditions);

study_path = 'fMRI_zmaps';
% output_path =

for currSubject = 1 : nr_subjects
    for currCondition = 1 : nr_conditions
        currFilename = fullfile(study_path, strcat(subjects{currSubject}, '_', conditions{currCondition}, '.nii'));
        if (currCondition == 1)
            fMRI_dataset = cosmo_fmri_dataset(currFilename, 'mask', false);
        else
            fMRI_dataset = cosmo_stack({fMRI_dataset, cosmo_fmri_dataset(currFilename, 'mask', false)}, 1);
        end
        % fMRI_dataset(currCondition,currSubject) = fMRI_data;
    end
    fMRI_dataset.sa.targets = (1 : nr_conditions)';
    fMRI_dataset.sa.chunks = ones(nr_conditions, 1);
    % fMRI_dataset.sa.targets = repelem(1 : nr_conditions, 400000)';
    % dsm1=cosmo_squareform(cosmo_pdist(fMRI_dataset.samples, 'correlation'))
    dsm = cosmo_dissimilarity_matrix_measure(fMRI_dataset, 'metric', 'spearman');
    fMRI_dsm(:,:,currSubject) = cosmo_squareform(dsm.samples);
end
