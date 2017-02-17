function obj = runFirstLevelFixed()

init();

obj = PRJ1206();
obj.subjects = 1:2;
obj.description = 'First Level Fixed';
obj.midLevel = 1;
obj.outDir = fullfile(obj.baseDir, obj.folderFLF, ['NORMAL_REST' sprintf( '_%i', obj.subjects )] );
obj.processarFirstLevelFixed();


obj = PRJ1206_SEP_EXE();
obj.subjects = 1:2;
obj.description = 'First Level Fixed';
obj.midLevel = 1;
obj.outDir = fullfile(obj.baseDir, obj.folderFLF, ['NORMAL_REST_EXE' sprintf( '_%i', obj.subjects )] );
obj.processarFirstLevelFixed();

obj = PRJ1206_SEP_1P();
obj.subjects = 1:2;
obj.description = 'First Level Fixed';
obj.midLevel = 1;
obj.outDir = fullfile(obj.baseDir, obj.folderFLF, ['NORMAL_REST_1P' sprintf( '_%i', obj.subjects )] );
obj.processarFirstLevelFixed();


obj = PRJ1206_SEP_3P();
obj.subjects = [1 3 5];
obj.description = 'First Level Fixed';
obj.midLevel = 1;
obj.outDir = fullfile(obj.baseDir, obj.folderFLF, ['NORMAL_REST_3P' sprintf( '_%i', obj.subjects )] );
obj.processarFirstLevelFixed();

end