function matlabbatch = explode_trials( matlabbatch, ignore )
%EXPLODE_TRIALS Summary of this function goes here
%   Detailed explanation goes here

sess = matlabbatch.spm.stats.fmri_spec.sess;
nses = length(sess);
for nSes = 1:nses
    newSess = sess(nSes);
    newSess.cond = sess(nSes).cond(1);
    posfixSes = '';
    if(nses > 1)
        posfisSes = sprintf('_%d', nses);
    end
    for nC = 1 : length(sess(nSes).cond) %Varre as condicoes e quebra em varias
        % Ignoring matches with ignore parameter
        if nargin > 1 && any( strcmp( sess(nSes).cond(nC).name, ignore ) )
            newSess.cond(end) = sess(nSes).cond(nC);
            newSess.cond(end+1) = sess(nSes).cond(nC);
            continue;
        end
        % Exploding conditions
        for nT = 1:length(sess(nSes).cond(nC).onset)
            newCond = sess(nSes).cond(nC);
            newCond.name = sprintf('%s%s_%d',newCond.name, posfixSes, nT);
            newCond.onset = sess(nSes).cond(nC).onset(nT);
            newCond.duration = sess(nSes).cond(nC).duration(nT);
            newSess.cond(end) = newCond;
            newSess.cond(end+1) = newCond;
        end        
    end
    newSess.cond(end) = [];
    sess(nSes) = newSess;
end
matlabbatch.spm.stats.fmri_spec.sess = sess;

end