function plotCalibracao( x, y_mean, y_std, xlab, ylab, tit )

figure
h = plot( x, y_mean );
set(h,'Linewidth',2 )
hold on
h = errorbar( x, y_mean, y_std );

set(h,'Linewidth',2 )
set(gca,'FontSize',10,'FontWeight','bold')

xlabel( xlab );
ylabel( ylab );

grid on

title( tit );

end