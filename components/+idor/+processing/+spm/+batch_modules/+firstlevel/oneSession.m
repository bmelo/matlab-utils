function [fmri_spec] = oneSession( config, fmri_spec )

import idor.processing.spm.batch_modules.firstlevel.concatFiles;

for nS=1:length( fmri_spec.sess )
    if ~exist('sess', 'var')
        sess = fmri_spec.sess(1);
        continue;
    end

    startTime = (fmri_spec.timing.RT * length(sess.scans));
    sessCur = fmri_spec.sess(nS);
    sess.scans = [sess.scans; sessCur.scans];
    sess.multi_reg = [sess.multi_reg sessCur.multi_reg];
    
    %Juntando condições
    for nC = 1 : length(sessCur.cond)
        cond = sessCur.cond(nC);
        cond.onset = cond.onset + startTime;
        pos = idor.utils.findField(sess.cond, cond.name, 'name');
        if ~pos
            sess.cond(end+1) = cond;
            continue;
        end
        sess.cond(pos).onset = [sess.cond(nC).onset(:)' cond.onset(:)'];        
        sess.cond(pos).duration = [sess.cond(nC).duration(:)' cond.duration(:)'];
        
        %juntando modulações paramétricas
        for nP = 1 : length( cond.pmod )
            sess.cond(nC).pmod(nP).param = [sess.cond(nC).pmod(nP).param cond.pmod(nP).param];
        end
    end
end

%Trying to detect issues
for k=1:length(sess.cond)
    if( isempty( sess.cond(k).onset ) )
        error( '%s - Onsets must be filled.', sess.cond(k).name );
    end
end

if config.mov_regressor
    sess.multi_reg = concatFiles( sess.multi_reg, '../%s_allsessions.txt' );
else
    sess.multi_reg = {''};
end

fmri_spec.sess = sess;

