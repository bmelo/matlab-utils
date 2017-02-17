function filename = ps2pdf( filename )
%PS2PDF Function to convert a PostScript file to PDF using Ghostscript

%First try with system (need returns status 0), then try by another way.
if system( sprintf('ps2pdf "%s" "%s"', filename, [filename '.pdf'])) > 0  
    try
        ps2pdf_alt( 'psfile', filename, 'pdffile', [filename '.pdf'] );
        filename = [filename '.pdf'];
    catch
        error('Failed to convert PS to PDF! [%s]', filename);
    end
end
