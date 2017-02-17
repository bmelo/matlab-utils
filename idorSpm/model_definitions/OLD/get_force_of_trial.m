function pmod = get_force_of_trial( onset_matches, Code, str )

    force = [];
    
    inds = [find( onset_matches ) ; length(onset_matches)];
    for k=1:length(inds)-1
       
        % search between two trials the str
        for k2=inds(k):inds(k+1)
           
            if strfind( Code{k2}, str )
               force = [force ; str2num( Code{k2}(length(str)+1:end) )];
               break;
            end
            
        end
        
    end
    
     pmod.name = 'FORCE';
     pmod.param = force;
     pmod.poly = 1;

end