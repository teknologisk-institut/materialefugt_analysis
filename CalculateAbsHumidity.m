function [ah,uAh] = CalculateAbsHumidity(dataCalibrated,dataUncertainties,calibrationFile)
%CalculateAbsHumidity finds the absolute humidity in g/s of the air exiting the sample chamber
%
% SYNOPSIS: [ah,uAh] = CalculateAbsHumidity(dataCalibrated,dataUncertainties,calibrationFile)
%
% INPUT 
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 29-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tNorm = 273.15;
Rv = 461.525;       % J/(kg*K) Gass constant for water vapor

calParam = readtable(calibrationFile,'Sheet','calibration_constants','ReadRowNames',true,'basic',1);
tempSensors = calParam.Properties.RowNames(string(calParam.unit)=='K',:); % find all temperature sensors in calibration parameter-file
tempSensorsIdx = ismember(dataCalibrated.Properties.VariableNames,tempSensors); % find temperature sensors in measurement file
ovenSensorIdx = (dataCalibrated(end,tempSensorsIdx).Variables==max(dataCalibrated(end,tempSensorsIdx).Variables)); % find the sensor with the highest end-temperature
ovenSensorName = string(dataCalibrated(:,tempSensorsIdx).Properties.VariableNames(ovenSensorIdx));
ambientSensorName = string(dataCalibrated(:,tempSensorsIdx).Properties.VariableNames(~ovenSensorIdx));

esf = dataCalibrated.esfChamber;
tChamberNorm = dataCalibrated.(ovenSensorName)+tNorm;

ah = esf./(Rv*tChamberNorm)*1e3; % g/m^3
uAh = sqrt( (dataUncertainties.esfChamber./(Rv*(tChamberNorm))*1e3).^2 + ...
    (dataUncertainties.(ovenSensorName).*(-esf./(Rv*tChamberNorm.^2)*1e3)).^2);
