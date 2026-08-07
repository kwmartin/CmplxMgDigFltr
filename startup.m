RootDir = fileparts(mfilename('fullpath'));
setenv('CMPLXROOT', RootDir);
ExmplDir = fullfile(RootDir, 'examples');
LibDir = fullfile(RootDir, 'lib');
cd(ExmplDir);
path(LibDir, path);
path(ExmplDir, path);
s = warning('off', 'Control:ltiobject:ZPKComplex')
c = onCleanup(@() warning(s));
warning('off', 'Control:ltiobject:TFComplex');
