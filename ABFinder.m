%% Finding the a-wave using raw data and B wave using filtered data
%This script finds the a wave and b wave using a simple min/max algorhithm. For the a wave, it takes the minimum value of the raw data within a
%certain bounds. For the b wave, it takes the max value within a certain bound. Afeter finding these points, it plots them retroactively on the plots
%from ExtractTraces.m

%This code should be run right after ExtractTraces.m to function, with no clearing of vars or closing of figures in the middle. 

%markers = [eye, marker, step, data]
%eye: 1 = right eye
%     2 = left eye
%marker: 1 = a wave
%        2 = B wave
%step:
%data:   1 = time
%        2 = voltage

markers = zeros(2,2,steps,2);   
markersindcs = zeros(2,2,steps,1);
%initializing markers array that will hold all of our marker times and voltages in the future
for i = 1:steps                                                                                                %for each step...
    for j = 1:2                                                                                                %for each eye...
        %A wave
        aBounds = [0 50];                                                                                      %declare the window we will search for the a wave in (in ms)
        timemin = data(1,1,1);                                                                                 %finding the minimum time
        timemindfz = 0-timemin;                                                                                %difference between this min time and 0
        tmdfzNindcs = round(timemindfz * (samplerate/1000));                                                   %the number of indcs between min time and zero
        aBoundsindcs = round(samplerate .* (aBounds./1000)+tmdfzNindcs+1);                                     %converting the bound in ms to index values in the data array by multiplying by samplerate and adding tmdfzNindcs + 1.
        [markers(j,1,i,2) tempindx] = min(data(aBoundsindcs(1):aBoundsindcs(end), j+1, i));                    %finding the minimum y-value (voltage) value between the bounds we set earlier and corresponding index value
                                                                                                               %and set that as the voltage of our a wave. We also save the index value for future use in tempindx
        markersindcs(j,1,i,1) = tempindx + (aBounds(1)-timemin)*round(samplerate/1000);                        %this tempindx does not contain the true index value in the data array, instead only holds the index of the array created by the min function
        markers(j,1,i,1) =data(markersindcs(j,1,i,1), 1, i);                                                   %so we take this index and add the number of indices between the first point in aBounds and the minimum point.                                                                                                                             
                                                                                                                    
        %B wave
        bBounds = [0 200];                                                                                     %same thing for b waves, except using the filtered data
        bBoundsindcs = round(samplerate .* (bBounds./1000) + tmdfzNindcs);
        [markers(j,2,i,2) tempindx] = max(data_filtered(bBoundsindcs(1):bBoundsindcs(end), j+1, i)); %
        markersindcs(j,2,i,1) = tempindx + (bBounds(1)-timemin)*round(samplerate/1000);
        markers(j,2,i,1) =data_filtered(markersindcs(j,2,i,1), 1, i);
    end
end

%% Plotting On Previous Plots 

%Uses a simple max/min algorithm to find a and B waves from raw data and
%filtered data respectively. Then plots these points on the figures from
%ExtractTraces.m retroactively. The retroactive fitting makes this code a
%little hard to read and complicated... It can be easily swapped out for a more simple
%plotting method that just makes new figures with the new markers
%superimposed. 

%Fig 1 (a marker) preprocessing: all necessary array declarations and manipulations that make it possible to retroactively plot on a figure we've already made. 
fig1Children = fig1.Children;                           %creates the graphical array fig1Children, which holds subobjects(children) of the fig1 figure object. 
                                                        %we need to access the "Line" object which is a child of "Axes" which is a child of the figure object (fig1).
                                                                       
tags1 = cell(1, size(fig1Children,1));                  %defining tags1 array which will hold "Tag"s, which identifies what type of information an object holds.
for i = 1:size(fig1Children)                            %for each element in the fig1Children array (the number of children fig1 has)
    tags1(1,i) = {fig1Children(i).Tag};                 %save the tag in our tags1 array.          
end 
suptitleindx = find(contains(tags1,'suptitle'));        %In this tags1 array we are looking for the tag "suptitle", which is the big title on top of our subplots.
                                                        %we want to remove this because for some reason it is also classified as an "Axes", but we do not need it. 
fig1.Children(suptitleindx).HandleVisibility = 'off';   %we set the 'suptitle' axis object handle to invisible so it cannot be seen by functions, but still visible on the plot. 
fig1axes = findobj(fig1, 'Type', 'Axes');               %declares fig1axes which is all of the children of fig1 that are of "Axes" type. the "Line object we're looking for is a child of "Axes". 
fig1axes = flipud(fig1axes);                            %for some reason this array is backwards, so invert it with flipud to be upright. 

%Fig 2 (b marker) preprocessing                              
fig2Children = fig2.Children;                           %same as above except we are using fig2's children. 
tags2 = cell(1, size(fig2Children,1));
for i = 1:size(fig1Children)
    tags2(1,i) = {fig2Children(i).Tag};
end 
suptitleindx = find(contains(tags2, 'suptitle'));
fig2.Children(suptitleindx).HandleVisibility = 'off';
fig2axes = findobj(fig2, 'Type', 'Axes');
fig2axes = flipud(fig2axes);

%Adding Points: this is where we retroactively put the markers on the plots. 
for i = 1:steps                                         %for each step
    %plotting a waves
    for j = 1:2                                         %for each eye
        lines = fig1axes(i).Children;                   %declare lines array which holds the "line" objects we've spent so much work getting to
        lines = flipud(lines);                          %lines array is also backwards, so we flip it
        lines(j).MarkerIndices = markersindcs(j,1,i);   %'MarkerIndices' are the indices of the points we want a marker on. We set this to position of a wave we found earlier.
        lines(j).Marker = 'o';
    end
    
    %plotting B waves
    for j = 1:2                                         %same as above
        lines = fig2axes(i).Children;   
        lines = flipud(lines);
        lines(j).MarkerIndices = markersindcs(j,2,i);
        lines(j).Marker = 'x';
    end 
end

%Note: this is the first time I plotted points retroactively on a figure, so this code looks ugly. The entire plotting section can be replaced by a more simple 
%plotting method that simply replots fig1 and fig2 from ExtractTraces.m, turn hold on, and then plot the a wave and b wave points on top. 

