function [PPs] = findPP( signal )

    zerocross_neg_pos = find( diff( sign( signal ) ) == 2 );
    
    figure,
    plot(  1:length(signal), signal )
    hold on
    plot( zerocross_neg_pos, signal( zerocross_neg_pos ), 'or' );
    
    PPs = zeros( length(zerocross_neg_pos)-1, 1 );
    
    for k = 1:length( zerocross_neg_pos )-1
       
        period = signal( zerocross_neg_pos(k):zerocross_neg_pos(k+1) ); 
        PPs(k) = max( period ) - min( period );
        
        plot( [zerocross_neg_pos(k) zerocross_neg_pos(k)], [max(period) min(period)])
    end
    
    
end