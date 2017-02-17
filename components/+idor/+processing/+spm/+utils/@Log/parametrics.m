function pmod = parametrics( obj, k )

%PARAMETRICS Summary of this function goes here
%   treat parametric modulations
def = obj.def(k);
pmod = struct;
for np = 1:length( def.spm_pmod )
    if isa( def.spm_pmod(np).name, 'function_handle' )
        obj.conditions.pmod(k) = def.spm_pmod(np).name( onset_matches, Code, def.spm_pmod(np).str );
    else
        mod_matches = get_code_matches_separate( def.pres_codes, Code);
        mod_values = zeros( length( onset_matches ), 1 );
        for c=1:length(def.pres_codes)
            mod_values( mod_matches{c} & onset_matches ) = def.spm_pmod(np).values(c);
        end
        mod_values( ~onset_matches ) = [];
        
        pmod(k).name{1} = def(k).spm_pmod(np).name;
        pmod(k).param{1} = mod_values;
        pmod(k).poly{1} = def(k).spm_pmod(np).poly;
    end
end

end

