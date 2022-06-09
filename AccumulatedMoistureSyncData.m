function [dataSynchronized] = AccumulatedMoistureSyncData(data)
%AccumulatedMoistureSyncData synchronizes the data from all tables in the input structure
%
% SYNOPSIS: [dataSynchronized] = AccumulatedMoistureSyncData(data)
%
% INPUT data is a structure containing timetables to be synchronized
%
% OUTPUT dataSynchronized is one large table containing all the data with synchronized timestamps.
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 18-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% extract table names
tableNames = fieldnames(data);

% find size of each table
tableSize=zeros(size(tableNames));
for i=1:size(tableNames,1)
    tableSize(i)=size(data.(tableNames{i}),1);
end

% order tables based on number of measurements, descending order
[~,idx]=sort(tableSize,'descend');
tableNames=tableNames(idx);

% create combined, synchronized table
dataSynchronized = data.(tableNames{1});
for i=2:size(tableNames)
    dataSynchronized=synchronize(dataSynchronized,data.(tableNames{i}),dataSynchronized.Time,"nearest");
end
dataSynchronized(1,:)=[];