constrast_dir = '\\10.36.4.201\dados3\Users\sebastian\My Documents\MATLAB\processingSPMworkInProgress\docs';

%% MOV REG
obj = PRJ_TEST();
obj.openSPM = 0;

obj.regressores=1;
obj.outrosRegressoresPrefix = 'REG*';
obj.outDir = [ obj.outDir '_MOV_REG'];
obj.contrastes = FirstLevel.importContrastsXls( fullfile( constrast_dir ,'\CONTRAST_TEST_MOV_REG.xlsx' ) );

obj.processarFirstLevel('prefix', 'swar*');

%% MOV
obj = PRJ_TEST();
obj.openSPM = 0;

obj.regressores=1;
obj.outrosRegressoresPrefix = '';
obj.outDir = [ obj.outDir '_MOV'];
obj.contrastes = FirstLevel.importContrastsXls( fullfile( constrast_dir ,'\CONTRAST_TEST_MOV.xlsx' ) );

obj.processarFirstLevel('prefix', 'swar*');

%% REG
obj = PRJ_TEST();
obj.openSPM = 0;

obj.regressores=0;
obj.outrosRegressoresPrefix = 'REG*';
obj.outDir = [ obj.outDir '_REG'];
obj.contrastes = FirstLevel.importContrastsXls( fullfile( constrast_dir ,'\CONTRAST_TEST_REG.xlsx' ) );

obj.processarFirstLevel('prefix', 'swar*');

%% sem nenhum regressor adicional
obj = PRJ_TEST();
obj.openSPM = 0;

obj.regressores=0;
obj.outrosRegressoresPrefix = '';
obj.contrastes = FirstLevel.importContrastsXls( fullfile( constrast_dir ,'\CONTRAST_TEST.xlsx' ) );

obj.processarFirstLevel('prefix', 'swar*');

%% FirstLevelFixed
obj = PRJ_TEST();
obj.openSPM = 0;

obj.pathSessions(2:end) = [];
obj.numSessions = 1;
obj.subjects = [1 5];
obj.regressores=0;
obj.outrosRegressoresPrefix = 'vol*';
obj.contrastes = FirstLevel.importContrastsXls( fullfile( constrast_dir ,'\CONTRAST_TEST_REG_MULTI.xlsx' ) );
obj.outDir = [ obj.outDir '_Fixed'];
obj.midLevel = true;

obj.processarFirstLevelFixed('prefix', 'swar*');

