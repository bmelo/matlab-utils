function populaMatlabbatch(obj, varargin)
%BATCH Summary of this function goes here
%   Detailed explanation goes here
if nargin == 0
    obj.populaMatlabbatch('realign');
    return;
end

%Montando scripts
pattern = [obj.prefixoAtual obj.prefixoRaw '*.nii'];
if strcmp(obj.prefixoAtual,'u')
    pattern = [obj.prefixoRaw '*.nii'];
end
prefixo = '';
switch(varargin{1})
    case 'realign'
        prefixo = obj.preRealign;
        matlabbatch.spm.spatial.realign.estwrite.data = obj.selectAllFiles(pattern, obj.unifiedRealign);
        if obj.unifiedRealign
            matlabbatch.spm.spatial.realign.estwrite.data = {matlabbatch.spm.spatial.realign.estwrite.data};
        end
        matlabbatch.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
        matlabbatch.spm.spatial.realign.estwrite.eoptions.sep = 4;
        matlabbatch.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
        matlabbatch.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        matlabbatch.spm.spatial.realign.estwrite.eoptions.interp = 4;
        matlabbatch.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch.spm.spatial.realign.estwrite.eoptions.weight = {''};
        matlabbatch.spm.spatial.realign.estwrite.roptions.which = [2 1];
        matlabbatch.spm.spatial.realign.estwrite.roptions.interp = 4;
        matlabbatch.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch.spm.spatial.realign.estwrite.roptions.prefix = prefixo;
        %Tratamento para quando for rodar unificado
        if obj.unifiedRealign & length(obj.prefixoAtual)==1
            matlabbatch.spm.spatial.realign.estwrite.roptions.prefix = [prefixo obj.prefixoAtual];
        end
    case 'slicetiming'
        prefixo = obj.preSlicetiming;
        matlabbatch.spm.temporal.st.scans = obj.selectAllFiles(pattern, obj.unifiedRealign);
        if ~isempty(matlabbatch.spm.temporal.st.scans) & ~iscell(matlabbatch.spm.temporal.st.scans{1})
            matlabbatch.spm.temporal.st.scans = {matlabbatch.spm.temporal.st.scans};
        end
        matlabbatch.spm.temporal.st.nslices = obj.nslices;
        matlabbatch.spm.temporal.st.tr = obj.tr;
        matlabbatch.spm.temporal.st.ta = obj.tr-(obj.tr/obj.nslices);
        matlabbatch.spm.temporal.st.so = 1:obj.nslices;
        matlabbatch.spm.temporal.st.refslice = floor(obj.nslices/2);
        matlabbatch.spm.temporal.st.prefix = prefixo;
    case 'normalization'
        prefixo = obj.preNormalization;
        matlabbatch.spm.spatial.normalise.estwrite.subj.source = ProcessamentoSPM.selectFilesDir(obj.subject.getSesDir(1), 'mean*.nii');
        matlabbatch.spm.spatial.normalise.estwrite.subj.source{1} = [matlabbatch.spm.spatial.normalise.estwrite.subj.source{1} ',1'];
        matlabbatch.spm.spatial.normalise.estwrite.subj.wtsrc = '';
        matlabbatch.spm.spatial.normalise.estwrite.subj.resample = obj.selectAllFiles(pattern,1);
        for j=1:size( matlabbatch.spm.spatial.normalise.estwrite.subj.resample, 1 )
            matlabbatch.spm.spatial.normalise.estwrite.subj.resample{j} = [matlabbatch.spm.spatial.normalise.estwrite.subj.resample{j} ',1'];
        end
        matlabbatch.spm.spatial.normalise.estwrite.subj.resample = [matlabbatch.spm.spatial.normalise.estwrite.subj.source{1}; matlabbatch.spm.spatial.normalise.estwrite.subj.resample];
        matlabbatch.spm.spatial.normalise.estwrite.eoptions.template = { [which('templates\EPI.nii') ',1' ] };
        matlabbatch.spm.spatial.normalise.estwrite.eoptions.weight = { [which('apriori\brainmask.nii') ',1' ] };
        matlabbatch.spm.spatial.normalise.estwrite.eoptions.smosrc = 8;
        matlabbatch.spm.spatial.normalise.estwrite.eoptions.smoref = 0;
        matlabbatch.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni';
        matlabbatch.spm.spatial.normalise.estwrite.eoptions.cutoff = 25;
        matlabbatch.spm.spatial.normalise.estwrite.eoptions.nits = 16;
        matlabbatch.spm.spatial.normalise.estwrite.eoptions.reg = 1;
        matlabbatch.spm.spatial.normalise.estwrite.roptions.preserve = 0;
        matlabbatch.spm.spatial.normalise.estwrite.roptions.bb = [-78 -112 -50 78 76 85];
        matlabbatch.spm.spatial.normalise.estwrite.roptions.vox = obj.voxelSize;
        matlabbatch.spm.spatial.normalise.estwrite.roptions.interp = 4;
        matlabbatch.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
        matlabbatch.spm.spatial.normalise.estwrite.roptions.prefix = prefixo;
    case 'smooth'
        prefixo = obj.preSmooth;
        matlabbatch.spm.spatial.smooth.data = obj.selectAllFiles(pattern,1);
        matlabbatch.spm.spatial.smooth.fwhm = obj.smoothing;
        matlabbatch.spm.spatial.smooth.dtype = 0;
        matlabbatch.spm.spatial.smooth.im = 0;
        matlabbatch.spm.spatial.smooth.prefix = prefixo;
    case 'detrend'
        prefixo = obj.preDetrend;
        matlabbatch = obj.selectAllFiles(pattern,1);
end
%Atualiza o prefixo do processamento
obj.prefixoAtual = [prefixo obj.prefixoAtual];
obj.matlabbatch = matlabbatch;

end