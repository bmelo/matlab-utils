function V = spm_check_filename(V)
% Checks paths are valid and tries to restore path names
% FORMAT V = spm_check_filename(V)
%
% V - struct array of file handles
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_check_filename.m 3934 2010-06-17 14:58:25Z guillaume $

if isdeployed, return; end

% check filenames
%--------------------------------------------------------------------------
for i = 1:length(V)
  
  
  % see if file exists
  %----------------------------------------------------------------------
  if ~spm_existfile(V(i).fname)
    
    % try current directory
    %------------------------------------------------------------------
    [p,n,e] = fileparts(V(i).fname);
    fname   = which([n,e]);
    if ~isempty(fname)
      V(i).fname = fname;
    else
      
      % try parent directory
      %--------------------------------------------------------------
      cwd = pwd;
      cd('..')
      fname  = which([n,e]);
      if ~isempty(fname)
        V(i).fname = fname;
      else
        %Modificado por IDOR - BRUNO MELO
        fullfname = fullfile(p,[n,e]);
        if( ~isempty(p) ) %Check if p is defined
          if( ~exist('new_dir','var') ) %Check if new_dir already was selected
            msg = {'Caminho abaixo não foi encontrado: ';' '; fullfname ;' ';'Será aberta uma janela de seleção de pastas! Informe o novo caminho das imagens ou feche a janela para manter o arquivo SPM.mat inalterado'};
            uiwait( warndlg( msg, 'Arquivo não encontrado!' ) );
            new_dir = regexprep(spm_select(1,'dir'), '[\/\\]$', '');
            if( ~isempty(new_dir) ) %Check if will change or not
              spm_changepath(fullfile(cwd, 'SPM.mat'), p, new_dir);
            else %If not, finish the function
              cd(cwd)
              return;
            end
          end
          V(i).fname = fullfile(new_dir, [n,e]);
        else
          % try children of parent
          %----------------------------------------------------------
          V = spm_which_filename(V);
          cd(cwd)
          return
        end
      end
      cd(cwd)
    end
    
  end
  
end


%==========================================================================
function V = spm_which_filename(V)


% get children directories of parent
%--------------------------------------------------------------------------
cwd = pwd;
cd('..')
%gwd = genpath(pwd);
%addpath(gwd);

% cycle through handles
%--------------------------------------------------------------------------
for i = 1:length(V)
  
  try
    % get relative path (directory and filename) and find in children
    %------------------------------------------------------------------
    j     = strfind(V(i).fname,filesep);
    fname = which(fname(j(end - 1):end));
    if ~isempty(fname)
      V(i).fname = fname;
    end
  end
end

% reset paths
%--------------------------------------------------------------------------
rmpath(gwd);
cd(cwd);
