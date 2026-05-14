[inFile, inPath] = uigetfile('*.trc', 'Select trc file to remap');
inputFile = fullfile(inPath, inFile);

[outFile, outPath] = uiputfile('*.trc', 'Save remapped file');

if isequal(outFile,0)
    disp('No output file selected. Exiting...');
    return;
end

outputFile = fullfile(outPath, outFile);

map = containers.Map();

map('R.ASIS') = 'RASI';
map('L.ASIS') = 'LASI';
map('V.Sacral') = 'COX';

map('R.Thigh.Upper') = 'RTHI1';
map('R.Thigh.Front') = 'RTHI2';
map('R.Thigh.Rear')  = 'RTHI3';

map('L.Thigh.Upper') = 'LTHI1';
map('L.Thigh.Front') = 'LTHI2';
map('L.Thigh.Rear')  = 'LTHI3';

map('R.Shank.Upper') = 'RSHA1';
map('R.Shank.Front') = 'RSHA2';
map('R.Shank.Rear')  = 'RSHA3';

map('L.Shank.Upper') = 'LSHA1';
map('L.Shank.Front') = 'LSHA2';
map('L.Shank.Rear')  = 'LSHA3';

map('R.Heel') = 'RHEEL';
map('L.Heel') = 'LHEEL';
map('R.Toe.Tip') = 'RTOE';
map('L.Toe.Tip') = 'LTOE';

map('Sternum') = 'MAN';
map('R.Acromium') = 'RSH';
map('L.Acromium') = 'LSH';


fid = fopen(inputFile,'r');

h1 = fgetl(fid);
h2 = fgetl(fid);
h3 = fgetl(fid);

line4 = fgetl(fid);  

rest = fread(fid, '*char')';
fclose(fid);

names = strsplit(strtrim(line4), '\t');

newNames = {};

for i = 1:length(names)

    name = names{i};

    if isKey(map, name)
        names{i} = map(name);   % rename only
    end
    
end

newLine4 = strjoin(newNames, '\t');

fid = fopen(outputFile,'w');

fprintf(fid,'%s\n',h1);
fprintf(fid,'%s\n',h2);
fprintf(fid,'%s\n',h3);
fprintf(fid,'%s\n',newLine4);

fprintf(fid,'%s',rest);

fclose(fid);

disp('TRC conversion complete!');
disp(['Saved to: ', outputFile]);