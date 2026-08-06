RootDir = fileparts(mfilename('fullpath'));
setenv('CMPLXROOT', RootDir);
ExmplDir = fullfile(RootDir, 'examples');
LibDir = fullfile(RootDir, 'lib');
cd(ExmplDir);
path(LibDir, path);
path(ExmplDir, path);
warning('off', 'Control:ltiobject:ZPKComplex')
warning('off', 'Control:ltiobject:TFComplex');
