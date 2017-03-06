function reportDurationTasks( numJob )

sched = findResource('scheduler', 'type', 'local');

times = datenum({sched.jobs(numJob).startTime, sched.jobs(numJob).finishTime}, 'ddd mmm dd HH:MM:SS');
fprintf('\nDuração total do job: %s\n\n', datestr( times(2)-times(1), 13));

numTasks = length(sched.jobs(numJob).tasks);
duration = zeros(numTasks,1);
disp('### DURAÇÃO DAS TAREFAS ###');
for k=1:numTasks
    times = datenum({sched.jobs(numJob).tasks(k).startTime, sched.jobs(numJob).tasks(k).finishTime}, 'ddd mmm dd HH:MM:SS');
    duration(k) = times(2)-times(1);
    fprintf('Tarefa %03d. - %s\n', k, datestr( duration(k) ,13));
end
disp('#########################################');
fprintf('Duração média: %s\n', datestr( mean(duration) ,13));
fprintf('Duração mínima: %s\n', datestr( min(duration) ,13));
fprintf('Duração máxima: %s\n', datestr( max(duration) ,13));

end