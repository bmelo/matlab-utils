classdef Parallel < handle
  %PARALLEL Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    cluster;
  end
  
  methods
    function obj = Parallel( profile )
      if(exist( 'profile', 'var' ))
        obj.clusterInit( profile );
      end
    end
    
    function clusterInit( obj, profile )
      if( exist('parcluster', 'file') )
        obj.cluster = parcluster(profile);
      else
        obj.cluster = findResource( 'scheduler', 'configuration', profile );
      end
    end
    
    function addJob( obj )
      obj.cluster.createJob();
    end
    
    function addTask( obj, numJob, func, numOut, args )
      numJob = obj.treatNumJob( numJob );
      obj.cluster.Jobs(numJob).createTask(func, numOut, args);
    end
    
    function submitJob( obj, numJob )
      numJob = obj.treatNumJob(numJob);
      obj.cluster.Jobs(numJob).submit();
    end
    
    function delete(obj)
      obj.cluster.Jobs(1:end).clear();
      obj.cluster.Jobs(1:end).delete();
      obj.cluster.Jobs(1:end).destroy();      
    end
  end
  
  methods ( Access=private )
    function numJob = treatNumJob( obj, numJob )
      if(~exist('numJob','var')) %Valor default
        numJob = 0;
      end
      if(numJob == 0) %Utiliza o último
        numJob = length(obj.cluster.Jobs);
      end
    end
  end
  
end

