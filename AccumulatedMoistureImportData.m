function sensorRawData = AccumulatedMoistureImportData(dataPath,dataFileName)
%AccumulatedMoistureImportData imports the sensor data from a material moisture experiment
%
% SYNOPSIS: sensorRawData = AccumulatedMoistureImportData(dataPath,dataFileName)
%
% INPUT dataPath is the path to the folder, containing the sensordata
%		dataFileName is the name of the file contianing the sensor data                                                      
%
% OUTPUT sensorRawData contains the raw data (unprocesses in any way), from the sensors
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 17-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==2 
    combinedFilePath = strcat(dataPath,dataFileName);
    if exist(combinedFilePath,"file")==2
    else
        [dataFileName,dataPath]=uigetfile('.mat')
        combinedFilePath = strcat(dataPath,dataFileName);
    end
else
    [dataFileName,dataPath]=uigetfile('.mat')
    combinedFilePath = strcat(dataPath,dataFileName);
end
sensorRawData = load(combinedFilePath);

disp(combinedFilePath)