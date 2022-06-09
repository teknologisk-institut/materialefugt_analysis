function dataUncertainties = AccumulatedMoistureUncertainties(dataSynchronized,calibrationFile) 
%AccumulatedMoistureUncertainties finds the uncertainties for the different measurands
%
% SYNOPSIS: dataUncertainties = AccumulatedMoistureUncertainties(dataSynchronized,calibrationFile) 
%
% INPUT dataSynchronized is the timetable containing the synchronized data
%		calibrationFile is the file containing calibration data, including uncertainties  
%
% OUTPUT dataUncertainties contains a timetable with the absolute uncertainties for each timestep
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 19-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% read calibration parameters
calParam = readtable(calibrationFile,'Sheet','calibration_constants','ReadRowNames',1,'basic',1);

%% define constants
tNorm = 273.15; % 0 °C in Kelvin
Tv = 461.525; % gas constant for water vapour

%% find sensor containing ambient temperature and sensor containing chamber temperature
sensorNames = calParam.Properties.RowNames(string(calParam.unit)=='K',:); % find all temperature sensors in calibration parameter-file
tempSensors = ismember(dataSynchronized.Properties.VariableNames,sensorNames); % find temperature sensors in measurement file
ovenIdx = (dataSynchronized(end,tempSensors).Variables==max(dataSynchronized(end,tempSensors).Variables)); % find the sensor with the highest end-temperature
ovenSensorName = dataSynchronized(:,tempSensors).Properties.VariableNames(ovenIdx);
ambSensorName = dataSynchronized(:,tempSensors).Properties.VariableNames(~ovenIdx);

%%


