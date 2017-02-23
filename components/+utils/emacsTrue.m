com.mathworks.services.Prefs.setBooleanPref('EditorEmacsTab', true);
optEmacs = com.mathworks.services.Prefs.getBooleanPref('EditorEmacsTab');
fprintf( 'Editor Emacs Tab: %d\n', optEmacs );