function reportDurationTasks( numJob )

sched = findResource('scheduler', 'type', 'local');

times = datenum({sched.jobs(numJob).startTime, sched.jobs(numJob).finishTime}, 'ddd mmm dd HH:MM:SS');
fprintf('\nDura��o total do job: %s\n\n', datestr( times(2)-times(1), 13));

numTasks = length(sched.jobs(numJob).tasks);
duration = zeros(numTasks,1);
disp('### DURA��O DAS TAREFAS ###');
for k=1:numTasks
    times = datenum({sched.jobs(numJob).tasks(k).startTime, sched.jobs(numJob).tasks(k).finishTime}, 'ddd mmm dd HH:MM:SS');
    duration(k) = times(2)-times(1);
    fprintf('Tarefa %03d. - %s\n', k, datestr( duration(k) ,13));
end
disp('#########################################');
fprintf('Dura��o m�dia: %s\n', datestr( mean(duration) ,13));
fprintf('Dura��o m�nima: %s\n', datestr( min(duration) ,13));
fprintf('Dura��o m�xima: %s\n', datestr( max(duration) ,13));

end