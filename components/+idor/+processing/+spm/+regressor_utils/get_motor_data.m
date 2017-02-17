function [regfile name columns] = get_motor_data( logdir, subj, run_nr, start_time_seg, nvol, out_dir )


    mot = load( fullfile( logdir , subj, [subj sprintf( '-%iRun_data.txt', run_nr )] ) );
    
    TR = 2;
    
    xx = [1:TR:TR*(nvol-1)];
    x = mot(:,1) / 1000 - start_time_seg;
    y = mot(:,2);
    
    for n=1:nvol
        a = 2*n-1 - TR/2;
        b = 2*n-1 + TR/2;
        inds = find( x > a & x < b );
        if ~isempty( inds )
            data(n,1) = mean( y( inds ) );
        else
            first_before = find( x < a, 1, 'last' );
            first_after  = find( x > b, 1, 'first' );
            if isempty( first_after ), first_after = first_before; end
            data(n,1) = mean( y(first_before:first_after) );
            warning( sprintf( 'no data found for volume %i. Take mean of time points at %.1f and %.1f', n, x(first_before), x(first_after) ) )
        end
    end
    
    data_conv = convolveHRF( data, 1/TR );
    
    % scale that maximum is 1 in order to facilitate beta comparisons
    % (http://blogs.warwick.ac.uk/nichols/entry/spm_plot_units/)
    data_conv_scaled = data_conv / max(data_conv) ;
    
    regfile = fullfile( out_dir, sprintf( 'RUN%i', run_nr), 'reg_motor.txt' );
    dlmwrite( regfile, data_conv_scaled );
    
    name = 'HANDGRIP';
    
    columns = 1;
    
end


