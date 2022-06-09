function [qH2O,uQH2O] = CalculateChamberFlow(dataCalibrated,dataUncertainties,calibrationFile)
%CalculateChamberFlow finds the partial flow of water vapour in the chamber
%
% SYNOPSIS: [qH2O,uQH2O] = CalculateChamberFlow(dataCalibrated,dataUncertainties)
%
% INPUT dataCalibrated contains the calibrated sensor data + some
%		dataUncertainties contains the uncertainties of the measured and calculated data	  
%
% OUTPUT qH2O is the partial water vapour flow in the chamber
%			uQH2O is the uncertainty on qH2O                      
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

calParam = readtable(calibrationFile,'Sheet','calibration_constants','ReadRowNames',true,'basic',1);
tempSensors = calParam.Properties.RowNames(string(calParam.unit)=='K',:); % find all temperature sensors in calibration parameter-file
tempSensorsIdx = ismember(dataCalibrated.Properties.VariableNames,tempSensors); % find temperature sensors in measurement file
ovenSensorIdx = (dataCalibrated(end,tempSensorsIdx).Variables==max(dataCalibrated(end,tempSensorsIdx).Variables)); % find the sensor with the highest end-temperature
ovenSensorName = string(dataCalibrated(:,tempSensorsIdx).Properties.VariableNames(ovenSensorIdx));
ambientSensorName = string(dataCalibrated(:,tempSensorsIdx).Properties.VariableNames(~ovenSensorIdx));

qViscCorr = dataCalibrated.qVisc;
tChamberNorm = dataCalibrated.(ovenSensorName)+tNorm;
tAmbientNorm = dataCalibrated.(ambientSensorName)+tNorm;

qChamber = qViscCorr.*(tChamberNorm)./(tAmbientNorm);
uQChamber = sqrt((dataUncertainties.qVisc.*tChamberNorm./tAmbientNorm).^2 + ...
    (dataUncertainties.(ovenSensorName).*qViscCorr./tAmbientNorm).^2 + ...
    (dataUncertainties.(ambientSensorName).*qViscCorr.*tChamberNorm./tAmbientNorm.^2).^2);

pLFE = dataCalibrated.pLFE;
esf = dataCalibrated.esfChamber;
qH2O = qChamber.*(1+1./(pLFE./esf-1));
uQH2O = sqrt((uQChamber.*(1+1./(pLFE./esf-1))).^2 + ...
    (dataUncertainties.esfChamber.*(-1./((pLFE./esf).^2+1-pLFE./esf)).*(-pLFE./esf.^2)).^2 + ...
    (dataUncertainties.pLFE.*(-1./((pLFE./esf).^2+1-pLFE./esf)).*(1./esf)).^2);
