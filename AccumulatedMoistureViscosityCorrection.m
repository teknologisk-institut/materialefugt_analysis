function [dataCalibrated,dataUncertainties] = AccumulatedMoistureViscosityCorrection(dataCalibrated,dataUncertainties,calibrationFile)
%AccumulatedMoistureViscosityCorrection calculates the viscosity of the air at the ambient temperature
%
% SYNOPSIS: [dataCalibrated,dataUncertainties] = AccumulatedMoistureViscosityCorrection(dataCalibrated,dataUncertainties,settings)
%
% INPUT dataCalibrated is the calibrated data from the sensors
%		dataUncertainties are the uncertainties of the measured sensors (k=1);
%		    
%
% OUTPUT dataCalibrated contains calibrated data for the measurands, including calculated values
%			dataUncertainties contains the uncertainties of the measurands, including calculated values  
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 19-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IDlfe = "111407";

% find name of temperature sensors
calParam = readtable(calibrationFile,'Sheet','calibration_constants','ReadRowNames',true,'basic',1);
tempSensors = calParam.Properties.RowNames(string(calParam.unit)=='K',:); % find all temperature sensors in calibration parameter-file
tempSensorsIdx = ismember(dataCalibrated.Properties.VariableNames,tempSensors); % find temperature sensors in measurement file
ovenSensorIdx = (dataCalibrated(end,tempSensorsIdx).Variables==max(dataCalibrated(end,tempSensorsIdx).Variables)); % find the sensor with the highest end-temperature
ovenSensorName = string(dataCalibrated(:,tempSensorsIdx).Properties.VariableNames(ovenSensorIdx));
ambientSensorName = string(dataCalibrated(:,tempSensorsIdx).Properties.VariableNames(~ovenSensorIdx));

% find values of ambient temperatures
tAmb = dataCalibrated.(ambientSensorName);
uTAmb = dataUncertainties.(ambientSensorName);

% find values of flow in LFE
q = dataCalibrated.(IDlfe);
uq = dataUncertainties.(IDlfe);

% Find viscosity corrected flow
qLFEViscCor = Sutherland(q,tAmb,2);

% find uncertainty of viscosity corrected flow
uqLFEViscCor = sqrt(((Sutherland(q+uq,tAmb,2) - Sutherland(q-uq,tAmb,2))/2).^2 + ...
    ((Sutherland(q,tAmb+uTAmb,2)-Sutherland(q,tAmb-uTAmb,2))/2).^2);

% write data to tables
dataCalibrated.qVisc = qLFEViscCor;
dataUncertainties.qVisc = uqLFEViscCor;