%ExtractTraces.m takes a .csv that contains raw data (only) from Espion,
%extacts out the data organized by step and eye, and plots it in stacked
%rows. Then, it will lowpass the data using and infinite impulse response
%filter and replot the filtered data. 

%Adaptable to:
%   folder organization: folders can be organized in any format AS LONG AS
%       the folder path contains the animal name i.e 'RHO-DTR N3'. This
%       info is used to plot the animal ID in the title

%Considerations:
%   File name of .csv raw data should contain 'Light' or 'Dark' (case-sensitive) depending
%       on whether it is light or dark adapted. 
%   This code as it is will only process 'RHO-DTR' labelled animals. For
%       other groups, find this line of code and change it: indx = find(contains(folderseparated,'RHO-DTR'));
%   This code is meant to be called by MasterScript.m. 


%UNCOMMENT THESE to run without MasterScript.m
%[file, folder] = uigetfile('*.csv');                   %load file from UI. This is commented out because MasterScript.m loads the files automatically
%                                                       if you're not using the masterscript, uncomment this line. 
%savefigs = 0;                                          %save figs if == 1.
                                                        %MasterScript.m declares this before ExtractTraces.m is ran. 
%Loading and Manipulating Data Table to be a usable form
T = readtable(fullfile(folder,file));                   %extract .csv into table data structure
T(:,end) = [];                                          %removing last column of table because it is empty and causes errors
contents = T(:,1:6);                                    %calling the first 6 columns of the table the "contents" table. 
idx=all(cellfun(@isempty,contents{:,:}),2);              %getting indcs of all empty elements from the contents table 
contents(idx,:)=[];                                     %using indcs to remove all empty elements
steps = str2num(cell2mat(table2cell(contents(end,1)))); %counting the number of steps by looking at the last row first column of contents
T=T(:,7:end);                                           %declaring Table T. The table we will extract raw data from 

%extracting data from table 
data = repmat(0, size(T,1) - 2,3,steps);                    %initializing matrix to hold our extracted and organized data
for i=1:steps                                               %for each step, 
    tempcell = table2cell(T(3:end, 1+3*(i-1):1+3*(i-1)+2)); %increments through the columns associated with each step and converts from table to cell
    tempmat = zeros(size(tempcell,1),size(tempcell,2));     %converts from cell to matrix
    data(:,:,i) = str2double(tempcell);                     %adds that data to our main data matrix and converts it from nV to uV
    data(:,2:3,i) = data(:,2:3,i) ./ 1000;                   %converting all nV to uV
end 

%data (data points, data type, step number)
%data types:
%   1: time (ms)
%   2: channel 1 uV (Right Eye)
%   3: channel 2 uV (Left Eye)

%extracting name from file name
if strfind(file, 'Light')       %if the string 'Light' is present in our filename
    adaption = 'Light';         %label this as a light adapted experiment. 
elseif strfind(file, 'Dark')    %.....
    adaption = 'Dark';
end 

%extracting animal name from folder path. Adaptable to changing folder
%structure but not to changing the name of animal. Recognizes RHO-DTR
folderseparated = regexp(folder, '\', 'split');     %separates the folder path into a cell with each component path piece
indx = find(contains(folderseparated,'RHO-DTR'));   %find the piece that contains 'RHO-DTR'. THIS MUST BE CHANGED IF YOUR ANIMAL NAME LABELLING SYSTEM IS DIFFERENT
animal = folderseparated{indx};                     %labels the animal name i.e 'RHO-DTR N1' under the animal var. 
%% Plotting 1: One panel per step. Both eyes on each panel 
fig1 = figure;

yrange = [min(min(min(data(:,2:3,:)))) max(max(max(data(:,2:3,:))))]; %finds the minimum and maximum nV values of our data, out all of the steps and eyes. For the purpose of standardizing axis ranges

for i=1:steps                                                         %For every step
    subplot(steps,1,i);                                               %declare subplot with number of rows = steps and one column
    hold on;                                                          %allows multiple lines to be plotted on each subplot
    plot(data(:,1,i),data(:,2,i));                                    %Plots RE nV
    plot(data(:,1,i),data(:,3,i));                                    %Plots LE nv
    title(['Step ' int2str(i)]);                                      %sets title to 'Step i' 
    legend('Right Eye', 'Left Eye');                                  %sets legend
    ylim(yrange);                                                     %sets y-axis limits we found earlier
    ylabel('Voltage (uV)');                                           %setting y-axis label
end     
xlabel('Time (ms)');                                                  %setting x-axis label
suptitle([animal ': ' adaption ' Adapted']);                          %sets a super title that goes over all of the subplots
set(gcf, 'position', [0 0 560 1080]);                                 %sets position of the plot generated [x y w h]. (x,y): bottom left corner. w: width. h: height. all in pixels
if savefigs
    savefig(fig1,fullfile(folder, strcat(adaption, '_', animal,'.fig')))  %save .fig under folder we opened in the beginning
    saveas(fig1,fullfile(folder, strcat(adaption, '_', animal,'.png')))   %save .png under folder we opened in the beginning
end
 %% Plotting 2: One panel per eye. all steps on each panel
% lighttrace2 = figure;
% hold on;
% eyes = {"Right Eye" "Left Eye"};
% for i=1:2
%     subplot(1,2,i);
%     hold on;
%     for j=1:steps
%         plot(data(:,1,j),data(:,i+1,j));
%     end 
%     title(eyes{i});
%     legend('Step 1','Step 2','Step 3','Step 4','Step 5')
% end 

%% Low Pass Filtering
samplerate = round(size(data,1)/((data(end,1,1)-data(1,1))/1000));                                                                                                %defining our sample rate
fpass = 15;                                                                                                       %(allow everything fpass and below) 
steepness = 0.95;                                                                                                 %setting steepness of filter
data_filtered = repmat(0, size(T,1) - 2,3,steps);                                                                 %initializing array that will hold filtered data
data_filtered(:,1,:) = data(:,1,:);                                                                               %copying & pasting over time data, as that will not be impacted by the filter
for i=1:steps                                                                                                     %for each step,
    data_filtered(:,2,i) = lowpass(data(:,2,i),fpass, samplerate,'ImpulseResponse','iir','Steepness',steepness);  %lowpass infinite impulse response on right eye
    data_filtered(:,3,i) = lowpass(data(:,3,i),fpass, samplerate,'ImpulseResponse','iir','Steepness',steepness);  %lowpass iir on left eye
end 

%yrange = [min(min(min(data_filtered(:,2:3,:)))) max(max(max(data_filtered(:,2:3,:))))];                           %min and max nV values

fig2 = figure;                                                                                                    %plotting again:
for i=1:steps                                                                                                     %everything the same as before with new vars
    subplot(steps,1,i);
    hold on;
    plot(data_filtered(:,1,i),data_filtered(:,2,i)); %RE nV
    plot(data_filtered(:,1,i),data_filtered(:,3,i)); %LE nv
    title(['Step ' int2str(i)]);
    legend('Right Eye', 'Left Eye');
    ylim(yrange); %y-axis limits in nV
    ylabel('Voltage (uV)');
end 
xlabel('Time (ms)');
suptitle([animal ': ' adaption ' Adapted. Filtered at ' int2str(fpass) ' Hz']);
set(gcf, 'position', [560 0 560 1080]);
if savefigs
    savefig(fig2,fullfile(folder, strcat(adaption, '_', animal,'_filtered','.fig')))
    saveas(fig2,fullfile(folder, strcat(adaption, '_', animal,'_filtered','.png')))
end


% lighttrace4 = figure;
% hold on;
% eyes = {"Right Eye" "Left Eye"};
% for i=1:2
%     subplot(1,2,i);
%     hold on;
%     for j=1:steps
%         plot(data_filtered(:,1,j),data_filtered(:,i+1,j));
%     end 
%     title(eyes{i});
%     legend('Step 1','Step 2','Step 3','Step 4','Step 5')
% end 