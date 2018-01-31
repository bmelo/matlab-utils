function [ v_cog ] = cog( vol, mask )
%COG - Center Of Gravity function
%   Based on COG function present in FSLSTATS
if nargin < 2, mask = []; end

v_cog = [0 0 0];
val   = 0;
total = 0;
vx    = 0;
vy    = 0;
vz    = 0;
tot   = 0;
n     = 0;


% Opening images
if ischar(vol)
    volnii = load_nii(vol);
else
    volnii = vol;
end

% Masking, if necessary
if ~isempty(mask)
    if ischar(mask)
        masknii = load_nii(mask);
    else
        masknii = mask;
    end
    volnii.img(~masknii.img) = NaN;
end


% More settings
vmin  = min(volnii.img(:));

%nlim  = sqrt(vol.nvoxels());
%if (nlim<1000)
%    nlim=1000;
%end
lims = utils.dimlims( volnii.img );

% Nothing to do
if isempty(lims)
    v_cog = [];
    return;
end

% Only one voxel. Returns its coordinate
if sum(lims(:,2) - lims(:, 1)) == 0
    v_cog = lims(:,1)';
    return;
end

% Computing COG
for z = lims(3,1):lims(3,2)
    for y = lims(2,1):lims(2,2)
        for x = lims(1,1):lims(1,2)
            n   = n+1;
            
            if( isnan(volnii.img(x,y,z)) )
                continue;
            end
            
            val = volnii.img(x,y,z) - vmin;
            vx  = vx + val*x;
            vy  = vy + val*y;
            vz  = vz + val*z;
            tot = tot+val;
            %if (n>nlim)
            %    total = total + tot; 
            %    v_cog = ( v_cog + [vx vy vz] );
            %    n = 0; tot = 0; vx = 0; vy = 0; vz = 0;
            %end
        end
    end
end

total = total + tot; 
v_cog = ( v_cog + [vx vy vz] ) / total;

end