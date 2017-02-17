function printRel( relatorio )

cont = 0;
for con = relatorio.contraste
    disp(['#####  CONTRASTE ' con.name]);
    fprintf('SUBJID\tRUN\tNUMBERS\tMAX\t\tMIN\t\tMEAN\n');
    for subj = fields(con.subjs)'
        nrun = 1;
        for run = con.subjs.(subj{1}).run
            if( run.number == 0 )
                run.max = 0.0; run.min = 0.0; run.mean = 0.0;
            end
            fprintf('%s\t%d\t%d\t%.2f\t%.2f\t%.2f\n', subj{1}, nrun, run.number, run.max, run.min, run.mean);
            nrun = nrun+1;
        end
    end
    cont=cont+1;
end

end