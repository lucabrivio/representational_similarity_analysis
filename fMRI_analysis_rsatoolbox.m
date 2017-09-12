% FIXME problem with the .img format!

RSAtoolboxRoot = '~/lib/MATLAB/rsatoolbox/'; addpath(genpath(RSAtoolboxRoot));

subjects = {'1606'};
conditions = {'BF_Happy' 'BF_Fear' 'BF_Neu' 'FR_Happy' 'FR_Fear' 'FR_Neu' 'STR_Happy' 'STR_Fear' 'STR_Neu'};

userOptions = defineUserOptions();
userOptions.analysisName = 'faces';
userOptions.betaPath = 'fMRI_zmaps/[[subjectName]]_[[betaIdentifier]]';
userOptions.rootPath = 'RSA_output';
userOptions.subjectNames = subjects;
userOptions.conditionLabels = conditions;

for currCondition = 1:length(conditions)
                betas(1,currCondition).identifier = [conditions{currCondition} '.img'];
end
fullBrainVols = rsa.fmri.fMRIDataPreparation(betas, userOptions);

% binaryMasks_nS = fMRIMaskPreparation(userOptions);
% responsePatterns = fMRIDataMasking(fullBrainVols, binaryMasks_nS, 'SPM', userOptions);

% RDMs = constructRDMs(responsePatterns, 'SPM', userOptions);