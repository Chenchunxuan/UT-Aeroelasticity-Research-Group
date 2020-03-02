% PROCESS MISC LOADS DATA 
% CMJOHNSON UPDATED: 03/02/2020
clear; clc; %close all

% PROCESSES STREAMING DATA AND MEAN DATA FILE, CHECKS CORRELATION OF DATA 
% FOR ERRORS IN RECODING (MOTOR BUMPS), WRITES TO XLXS FILE
% 
% INPUTS
%     directory         -> location of streaming data files + corresponding mean data files 
%                        mean data files only required for writing to xlxs file
%     conditons = [Temperature [F], % Humidity, Pressure[in-Hg]]
%     flip      = true  -> inner load cell in same oriendtation as outer load cell
%               = false -> inner load cell is flipped with reference to outer load cell (small axial spacings)
%     filename          -> xlxs file name to write data to
%     write_directory   -> location to write xlsx file to
% 
% OUTPUTS
%     MeanData          -> structure containing each mean data file
%     StreamData        -> structure containing info from streaming data
%                          files; each cell = one mean data file
%     SortedData        -> structure containing streaming data sorted into matrices;
%                          each cell = one mean data file; each row matrix = one revolution
%                          calculates ct/sigma,cp/sigma, and FM's
%     RevData           -> cells containg structure of azimuthally averaged data 
%                          1 cell for each data set
%                          each cell contains avg and err for each variable in RevData
%     AvgData           -> single cell containing avgerage and error of
%                          each calculated variale in single streaming data file
%     XLSX FILE         -> with given file name, compiles data from AvgData
%                          and test conditions (colelctive, index angle, axial spacing) 
%                          from MeanData

%% INPUTS

directory = '/Users/cmj2855/Box Sync/Chloe Lab Stuff/Acoustics Spring 2020/Uber Acoustics 200227/Loads Files/4 bladed';
conditions = [45	54	29.11]; %[T(Farhen), % humidity, P(in.Hg)]
flip = true;
filename = 'IsolatedRotor_Outdoors_200227.xlsx';
write_directory = '/Users/cmj2855/Box Sync/Chloe Lab Stuff/Acoustics Spring 2020/Compiled Data';

%% PROCESS

[MeanData,StreamData] = LoadData(directory,flip);
[StreamData,SortedData] = SortStream(StreamData, conditions);
% SortedData = CheckCorrelation(SortedData);
RevData = RevolutionAvg(SortedData);
AvgData = TotalAvg(RevData,StreamData);

%% PLOT

load('colors.mat')
figure()
plot([AvgData.avg_cps_inner{1:9}],[AvgData.avg_cts_inner{1:9}], 's','color',colors{2})
hold on
plot([AvgData.avg_cps_outer{1:9}],[AvgData.avg_cts_outer{1:9}], '^','color',colors{5})
plot([AvgData.avg_cps_total{1:9}],[AvgData.avg_cts_total{1:9}], 'o','color',colors{1})

%% WRITE TO FILE

CompileData(MeanData,AvgData,filename,write_directory)
