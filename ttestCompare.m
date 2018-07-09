%This code compares espion markers with algorhithm (ABFinder.m) found. 
%beggining half of the code is heavily based off of MasterScript.m. Should
%be ran after MasterScript.m

%% Going from filename and path --> LIGHT & DARK arrays that enable group t-test comparisons
%%Compiling handpicked markers
%Beginning Parameters
savefigs = 0; %save figures? 1 = yes, 0 = no. 
savemarkers = 1; %save markers?
LIGHTsteps = 5;
DARKsteps = 8;

%allows user to choose base directory with individual animal folders and
%then processes this path down to a list of animals. 
basefolder = uigetdir;
allmembers = dir(basefolder);
allmembers = struct2cell(allmembers);
allnames = allmembers(1,:);
removeindcs = find(contains(allnames,'.'));
allnames(removeindcs) = [];

filenames = {'DarkMarker', 'LightMarker'};
ALLESPIONMarkers = cell(2,size(allnames,2));
%ALLESPIONMarkers = {individual, adaption}

%iterates through each individual folder
for a=1:size(allnames,2)
    folder = fullfile(basefolder, allnames{a});
    %iterates through each Data file (Light or Dark adapteD)
    for b=1:size(filenames,2)
        file = [filenames{b} '.csv'];
        ExtractMarkers
%         if savefigs
%             savefig(fig1,fullfile(folder, strcat(adaption, '_', animal,'.fig')));              %save .fig under folder we opened in the beginning
%             saveas(fig1,fullfile(folder, strcat(adaption, '_', animal,'.png')));               %save .png under folder we opened in the beginning
%             savefig(fig2,fullfile(folder, strcat(adaption, '_', animal,'_filtered','.fig')));
%             saveas(fig2,fullfile(folder, strcat(adaption, '_', animal,'_filtered','.png')));
%         end
        if savemarkers
            ALLESPIONMarkers{a,b} = markers;
        end 
    end
end

DARKESPION = [];
LIGHTESPION = [];
%pulling out ESPION alg markers. 
for a=1:size(ALLESPIONMarkers,1) %for each animal
    for b=1:size(ALLESPIONMarkers,2) %for each marker
        if b==1
            DARKESPION = cat(3, DARKESPION, ALLESPIONMarkers{a,b});
        elseif b==2
            LIGHTESPION = cat(3, LIGHTESPION, ALLESPIONMarkers{a,b});
        end 
    end
end

DARKABF = [];
LIGHTABF = [];
%pulling out ABFinder markers
for a=1:size(ALLmarkers,1) %for each animal
    for b=1:size(ALLmarkers,2) %for each marker
        if b==1
            DARKABF = cat(3, DARKABF, ALLmarkers{a,b});
        elseif b==2
            LIGHTABF = cat(3, LIGHTABF, ALLmarkers{a,b});
        end 
    end
end

%% T-Tests

%ESPION DARK A vs ABF DARK A Voltage. Both eyes combined. 
    %RE (RIGHT EYE)
ttests(1).name = 'DARK ESPION A vs DARK ABF A';
numinds = size(DARKESPION,3);
ttests(1).RE.ESPION.vals = reshape(DARKESPION(1,1,:,2),numinds,1);
ttests(1).RE.ABFINDER.vals = reshape(DARKABF(1,1,:,2),numinds,1);
ttests(1).RE.ESPION.adaption = 'DARK';ttests(1).RE.ESPION.alg = 'ESPION'; ttests(1).RE.ESPION.wave = 'A'; ttests(1).RE.ESPION.eyes = 'RIGHT'; ttests(1).RE.ESPION.unit = 'uV'; ttests(1).RE.ESPION.mean = mean(ttests(1).RE.ESPION.vals);
ttests(1).RE.ABFINDER.adaption = 'DARK';ttests(1).RE.ABFINDER.alg = 'ABFINDER'; ttests(1).RE.ABFINDER.wave = 'A'; ttests(1).RE.ABFINDER.eyes = 'RIGHT'; ttests(1).RE.ABFINDER.unit = 'uV'; ttests(1).RE.ABFINDER.mean = mean(ttests(1).RE.ABFINDER.vals);
[ttests(1).RE.stats.result ttests(1).RE.stats.p ttests(1).RE.stats.ci ttests(1).RE.stats.stats] = ttest2(ttests(1).RE.ESPION.vals,ttests(1).RE.ABFINDER.vals);
ttests(1).RE.figure = figure;
hold on;
scatter(ttests(1).RE.ESPION.vals,zeros(size(ttests(1).RE.ESPION.vals)));
scatter(ttests(1).RE.ABFINDER.vals,zeros(size(ttests(1).RE.ABFINDER.vals)));


    %LE (LEFT EYE)
ttests(1).LE.ESPION.vals = reshape(DARKESPION(2,1,:,2),numinds,1);
ttests(1).LE.ABFINDER.vals = reshape(DARKABF(2,1,:,2),numinds,1);
ttests(1).LE.ESPION.adaption = 'DARK';ttests(1).LE.ESPION.alg = 'ESPION'; ttests(1).LE.ESPION.wave = 'A'; ttests(1).LE.ESPION.eyes = 'LEFT'; ttests(1).LE.ESPION.unit = 'uV'; ttests(1).LE.ESPION.mean = mean(ttests(1).LE.ESPION.vals);
ttests(1).LE.ABFINDER.adaption = 'DARK';ttests(1).LE.ABFINDER.alg = 'ABFINDER'; ttests(1).LE.ABFINDER.wave = 'A'; ttests(1).LE.ABFINDER.eyes = 'LEFT'; ttests(1).LE.ABFINDER.unit = 'uV'; ttests(1).LE.ABFINDER.mean = mean(ttests(1).LE.ABFINDER.vals);
[ttests(1).LE.stats.result ttests(1).LE.stats.p ttests(1).LE.stats.ci ttests(1).LE.stats.stats] = ttest2(ttests(1).LE.ESPION.vals,ttests(1).LE.ABFINDER.vals);
ttests(1).LE.figure = figure;
hold on;
scatter(ttests(1).LE.ESPION.vals,zeros(size(ttests(1).LE.ESPION.vals)));
scatter(ttests(1).LE.ABFINDER.vals,zeros(size(ttests(1).LE.ABFINDER.vals)));


ttests(1).REResult = ttests(1).RE.stats.result;
ttests(1).LEResult = ttests(1).LE.stats.result;
%ESPION DARK B vs ABF DARK B
%   RIGHT EYE
ttests(2).name = 'DARK ESPION B vs DARK ABF B';
numinds = size(DARKESPION,3);
ttests(2).RE.ESPION.vals = reshape(DARKESPION(1,2,:,2),numinds,1);
ttests(2).RE.ABFINDER.vals = reshape(DARKABF(1,2,:,2),numinds,1);
ttests(2).RE.ESPION.adaption = 'DARK';ttests(2).RE.ESPION.alg = 'ESPION'; ttests(2).RE.ESPION.wave = 'B'; ttests(2).RE.ESPION.eyes = 'RIGHT'; ttests(2).RE.ESPION.unit = 'uV'; ttests(2).RE.ESPION.mean = mean(ttests(2).RE.ESPION.vals);
ttests(2).RE.ABFINDER.adaption = 'DARK';ttests(2).RE.ABFINDER.alg = 'ABFINDER'; ttests(2).RE.ABFINDER.wave = 'B'; ttests(2).RE.ABFINDER.eyes = 'RIGHT'; ttests(2).RE.ABFINDER.unit = 'uV'; ttests(2).RE.ABFINDER.mean = mean(ttests(2).RE.ABFINDER.vals);
[ttests(2).RE.stats.result ttests(2).RE.stats.p ttests(2).RE.stats.ci ttests(2).RE.stats.stats] = ttest2(ttests(2).RE.ESPION.vals,ttests(2).RE.ABFINDER.vals);
ttests(2).RE.figure = figure;
hold on;
scatter(ttests(2).RE.ESPION.vals,zeros(size(ttests(2).RE.ESPION.vals)));
scatter(ttests(2).RE.ABFINDER.vals,zeros(size(ttests(2).RE.ABFINDER.vals)));

%   LEFT EYE
numinds = size(DARKESPION,3);
ttests(2).LE.ESPION.vals = reshape(DARKESPION(2,2,:,2),numinds,1);
ttests(2).LE.ABFINDER.vals = reshape(DARKABF(2,2,:,2),numinds,1);
ttests(2).LE.ESPION.adaption = 'DARK';ttests(2).LE.ESPION.alg = 'ESPION'; ttests(2).LE.ESPION.wave = 'B'; ttests(2).LE.ESPION.eyes = 'LEFT'; ttests(2).LE.ESPION.unit = 'uV'; ttests(2).LE.ESPION.mean = mean(ttests(2).LE.ESPION.vals);
ttests(2).LE.ABFINDER.adaption = 'DARK';ttests(2).LE.ABFINDER.alg = 'ABFINDER'; ttests(2).LE.ABFINDER.wave = 'B'; ttests(2).LE.ABFINDER.eyes = 'LEFT'; ttests(2).LE.ABFINDER.unit = 'uV'; ttests(2).LE.ABFINDER.mean = mean(ttests(2).LE.ABFINDER.vals);
[ttests(2).LE.stats.result ttests(2).LE.stats.p ttests(2).LE.stats.ci ttests(2).LE.stats.stats] = ttest2(ttests(2).LE.ESPION.vals,ttests(2).LE.ABFINDER.vals);
ttests(2).LE.figure = figure;
hold on;
scatter(ttests(2).LE.ESPION.vals,zeros(size(ttests(2).LE.ESPION.vals)));
scatter(ttests(2).LE.ABFINDER.vals,zeros(size(ttests(2).LE.ABFINDER.vals)));

ttests(2).REResult = ttests(2).RE.stats.result;
ttests(2).LEResult = ttests(2).LE.stats.result;
%ESPION LIGHT A vs ABF LIGHT A
%   RIGHT EYE
ttests(3).name = 'LIGHT ESPION A vs LIGHT ABF A';
numinds = size(LIGHTESPION,3);
ttests(3).RE.ESPION.vals = reshape(LIGHTESPION(1,1,:,2),numinds,1);
ttests(3).RE.ABFINDER.vals = reshape(LIGHTABF(1,1,:,2),numinds,1);
ttests(3).RE.ESPION.adaption = 'LIGHT';ttests(3).RE.ESPION.alg = 'ESPION'; ttests(3).RE.ESPION.wave = 'A'; ttests(3).RE.ESPION.eyes = 'RIGHT'; ttests(3).RE.ESPION.unit = 'uV'; ttests(3).RE.ESPION.mean = mean(ttests(2).LE.ESPION.vals);
ttests(3).RE.ABFINDER.adaption = 'LIGHT';ttests(3).RE.ABFINDER.alg = 'ABFINDER'; ttests(3).RE.ABFINDER.wave = 'A'; ttests(3).RE.ABFINDER.eyes = 'RIGHT'; ttests(3).RE.ABFINDER.unit = 'uV'; ttests(3).RE.ABFINDER.mean = mean(ttests(2).LE.ABFINDER.vals);
[ttests(3).RE.stats.result ttests(3).RE.stats.p ttests(3).RE.stats.ci ttests(3).RE.stats.stats] = ttest2(ttests(3).RE.ESPION.vals,ttests(3).RE.ABFINDER.vals);
ttests(3).RE.figure = figure;
hold on;
scatter(ttests(3).RE.ESPION.vals,ones(size(ttests(3).RE.ESPION.vals)));
scatter(ttests(3).RE.ABFINDER.vals,zeros(size(ttests(3).RE.ABFINDER.vals)));
%   LEFT EYE
numinds = size(LIGHTESPION,3);
ttests(3).LE.ESPION.vals = reshape(LIGHTESPION(2,1,:,2),numinds,1);
ttests(3).LE.ABFINDER.vals = reshape(LIGHTABF(2,1,:,2),numinds,1);
ttests(3).LE.ESPION.adaption = 'LIGHT';ttests(3).LE.ESPION.alg = 'ESPION'; ttests(3).LE.ESPION.wave = 'A'; ttests(3).LE.ESPION.eyes = 'LEFT'; ttests(3).LE.ESPION.unit = 'uV'; ttests(3).LE.ESPION.mean = mean(ttests(2).LE.ESPION.vals);
ttests(3).LE.ABFINDER.adaption = 'LIGHT';ttests(3).LE.ABFINDER.alg = 'ABFINDER'; ttests(3).LE.ABFINDER.wave = 'A'; ttests(3).LE.ABFINDER.eyes = 'LEFT'; ttests(3).LE.ABFINDER.unit = 'uV'; ttests(3).LE.ABFINDER.mean = mean(ttests(2).LE.ABFINDER.vals);
[ttests(3).LE.stats.result ttests(3).LE.stats.p ttests(3).LE.stats.ci ttests(3).LE.stats.stats] = ttest2(ttests(3).LE.ESPION.vals,ttests(3).LE.ABFINDER.vals);
ttests(3).LE.figure = figure;
hold on;
scatter(ttests(3).LE.ESPION.vals,ones(size(ttests(3).LE.ESPION.vals)));
scatter(ttests(3).LE.ABFINDER.vals,zeros(size(ttests(3).LE.ABFINDER.vals)));

ttests(3).REResult = ttests(3).RE.stats.result;
ttests(3).LEResult = ttests(3).LE.stats.result;
%ESPION LIGHT B vs ABF LIGHT B
%RIGHT EYE
ttests(4).name = 'LIGHT ESPION B vs LIGHT ABF B';
numinds = size(LIGHTESPION,3);
ttests(4).RE.ESPION.vals = reshape(LIGHTESPION(1,2,:,2),numinds,1);
ttests(4).RE.ABFINDER.vals = reshape(LIGHTABF(1,2,:,2),numinds,1);
ttests(4).RE.ESPION.adaption = 'LIGHT';ttests(4).RE.ESPION.alg = 'ESPION'; ttests(4).RE.ESPION.wave = 'B'; ttests(4).RE.ESPION.eyes = 'RIGHT'; ttests(4).RE.ESPION.unit = 'uV'; ttests(4).RE.ESPION.mean = mean(ttests(2).LE.ESPION.vals);
ttests(4).RE.ABFINDER.adaption = 'LIGHT';ttests(4).RE.ABFINDER.alg = 'ABFINDER'; ttests(4).RE.ABFINDER.wave = 'B'; ttests(4).RE.ABFINDER.eyes = 'RIGHT'; ttests(4).RE.ABFINDER.unit = 'uV'; ttests(4).RE.ABFINDER.mean = mean(ttests(2).LE.ABFINDER.vals);
[ttests(4).RE.stats.result ttests(4).RE.stats.p ttests(4).RE.stats.ci ttests(4).RE.stats.stats] = ttest2(ttests(4).RE.ESPION.vals,ttests(4).RE.ABFINDER.vals);
ttests(4).RE.figure = figure;
hold on;
scatter(ttests(4).RE.ESPION.vals,ones(size(ttests(4).RE.ESPION.vals)));
scatter(ttests(4).RE.ABFINDER.vals,zeros(size(ttests(4).RE.ABFINDER.vals)));
%LEFT EYE
numinds = size(LIGHTESPION,3);
ttests(4).LE.ESPION.vals = reshape(LIGHTESPION(2,2,:,2),numinds,1);
ttests(4).LE.ABFINDER.vals = reshape(LIGHTABF(2,2,:,2),numinds,1);
ttests(4).LE.ESPION.adaption = 'LIGHT';ttests(4).LE.ESPION.alg = 'ESPION'; ttests(4).LE.ESPION.wave = 'B'; ttests(4).LE.ESPION.eyes = 'LEFT'; ttests(4).LE.ESPION.unit = 'uV'; ttests(4).LE.ESPION.mean = mean(ttests(2).LE.ESPION.vals);
ttests(4).LE.ABFINDER.adaption = 'LIGHT';ttests(4).LE.ABFINDER.alg = 'ABFINDER'; ttests(4).LE.ABFINDER.wave = 'B'; ttests(4).LE.ABFINDER.eyes = 'LEFT'; ttests(4).LE.ABFINDER.unit = 'uV'; ttests(4).LE.ABFINDER.mean = mean(ttests(2).LE.ABFINDER.vals);
[ttests(4).LE.stats.result ttests(4).LE.stats.p ttests(4).LE.stats.ci ttests(4).LE.stats.stats] = ttest2(ttests(4).LE.ESPION.vals,ttests(4).LE.ABFINDER.vals);
ttests(4).LE.figure = figure;
hold on;
scatter(ttests(4).LE.ESPION.vals,ones(size(ttests(4).LE.ESPION.vals)));
scatter(ttests(4).LE.ABFINDER.vals,zeros(size(ttests(4).LE.ABFINDER.vals)));

ttests(4).REResult = ttests(4).RE.stats.result;
ttests(4).LEResult = ttests(4).LE.stats.result;


