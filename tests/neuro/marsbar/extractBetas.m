function [e_names b_evts medias] = extractBetas( subdir, roi_file )
curdir = pwd;

cd( subdir );
load SPM;
% Make marsbar design object
D = mardo(SPM);
% Make marsbar ROI object
R = maroi( roi_file );
% Fetch data into marsbar data object
Y = get_marsy(R, D, 'mean');
% Estimate design on ROI data
E = estimate(D, Y);
% get design betas
b = betas(E);
betas_labels = { SPM.Vbeta(:).descrip };
% Get definitions of all events in model
[e_specs, e_names] = event_specs(E);
n_events = size(e_specs, 2);
b_evts = zeros(1,n_events);
% Extracting betas from the right position
for e_s = 1:n_events
    nE = e_specs(1, e_s);
    condition = e_names{e_s};
    pattern = sprintf( 'Sn\\(%d\\) %s\\*', nE, condition );
    placeBeta = regexp( betas_labels, pattern );
    nPos = ~cellfun( @isempty, placeBeta );
    b_evts(e_s) = b(nPos);
end

if nargout == 1
    e_names = {e_names b_evts calcMedias( e_names, b_evts )};
end

cd( curdir );
end

%Extract means
function means = calcMedias(e_names, b_evts)

names = unique( e_names );
means = zeros( 1, length( names ) );
for e_s = 1 : length( names )
    pos = strcmp( e_names, names{e_s} );
    means(e_s) = mean( b_evts( pos ) );
end

end

