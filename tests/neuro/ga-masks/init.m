matlab_utils_dir = '../../init.m';

run(matlab_utils_dir);
utils.path.includeSubdirs({ 'core', 'atlas', 'vendors/nifti_tools' });

clear matlab_utils_dir;