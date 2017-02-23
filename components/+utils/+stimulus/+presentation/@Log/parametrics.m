function pmod = parametrics( obj, k )

%PARAMETRICS Summary of this function goes here
%   treat parametric modulations
def = obj.def(k);
pmod = struct('name',{},'param',{},'poly',{});
[~, ~, onsetM] = obj.getMatches();
for np = 1:length( def.spm_pmod )
    if isa( def.spm_pmod(np).name, 'function_handle' )
        pmod(np) = def.spm_pmod(np).name( obj );
    else
        mod_matches = get_code_matches_separate( def.pres_codes, obj.Code);
        mod_values = zeros( length( onsetM ), 1 );
        for c=1:length(def.pres_codes)
            mod_values( mod_matches{c} & onsetM ) = def.spm_pmod(np).values(c);
        end
        mod_values( ~onsetM ) = [];
        
        pmod(np).name{1} = def(k).spm_pmod(np).name;
        pmod(np).param{1} = mod_values;
        pmod(np).poly{1} = def(k).spm_pmod(np).poly;
    end
end

if isempty( pmod(np).param )
    pmod = struct('name', {}, 'param', {}, 'poly', {});
elseif ~iscell( pmod(np).param )
    pmod(np).param = pmod(np).param;
end

end

