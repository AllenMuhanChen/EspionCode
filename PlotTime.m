%% reading marker table
% [step, channel, wave, uV and ms]

clear all;
%   Loading and Manipulating Marker Table to be a usable form 
[file, folder] = uigetfile('*.csv');
T = readtable(fullfile(folder,file));
T(:,end) = [];
names = table2cell(T(1,:)); 
names(3) = {'Cage'};
names(10) = {'Marker'};
T.Properties.VariableNames = names;
T(1:2,:) = [];

%extracting table data to cell
C = table2cell(T(:,{'Eye', 'Marker', 'uV', 'ms'}));

    
%Takes 'C' cell and divides the data into four arrays REa, REB, LEa and
%LEB to separate by eye and marker. 
      %eye = 1: LE      
      %eye = 2: RE
      %wave = 1: a
      %wave = 2: B
REa = [];
REB = [];
LEa = [];
LEB = [];
%for each data point 
for i=1:size(C,1)
    %scans eye and marker columns
    for j=1:2
        if strcmp(C{i,j}, {'LE'})
           eye = 1;
        elseif strcmp(C{i,j}, {'RE'})
           eye = 2;
        elseif strcmp(C{i,j}, {'a'})
           wave = 1;
        elseif strcmp(C{i,j}, {'B'})
           wave = 2;
        end 
    end 
    %divides data into REa, REB, LEa, LEB
        %row1: uV
        %row2: ms
    if eye==1 && wave==1
        LEa = cat(2, LEa, [str2num(C{i,3});str2num(C{i,4})]);
    elseif eye==1 && wave==2
        LEB = cat(2, LEB, [str2num(C{i,3});str2num(C{i,4})]);
    elseif eye==2 && wave==1
        REa = cat(2, REa,[str2num(C{i,3});str2num(C{i,4})]);
    elseif eye==2 && wave==2
        REB = cat(2, REB, [str2num(C{i,3});str2num(C{i,4})]);
    end 
end 

%stacks data into a 4D array. [eye, marker, uV or ms, data point)
markers(1,1,:,:) = LEa;
markers(1,2,:,:) = LEB;
markers(2,1,:,:) = REa;
markers(2,2,:,:) = REB;

%% plotting times for left and right eye "A"

afig = figure;
hold on;
x = 1:size(LEa,2);
% y = repmat(1,1,size(LEa,2));
scatter(x, reshape(markers(1,1,2,:),[1 size(LEa,2)]));
scatter(x, reshape(markers(2,1,2,:),[1 size(LEa,2)]));
title('Time distribution of "a" wave duration in left versus right eye');
legend('Left Eye', 'Right Eye');
