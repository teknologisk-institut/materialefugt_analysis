function [dataCalibrated,dataUncertainties] = calculateVapourPressure(dataCalibrated,dataUncertainties,dataSynchronized,calibrationFile,settings)
%calculateVapourPressure calculates the vapour pressure, given a dew point and an air pressure
%
% SYNOPSIS: [dataCalibrated,dataUncertainties] = calculateVapourPressure(dataCalibrated,dataUncertainties,dataSynchronized)
%
% INPUT dataCalibrated is a table containing the calibrated data
%		dataUncertainties is a table containing the uncertainties of the measured values at each timepoint
%		dataSynchronized contains data for the air pressure                                                 
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 20-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find vapourpressure at the mirror
dataCalibrated.esMirror = vapourPressure(dataCalibrated.DPref,dataSynchronized.P);

% find uncertainties. 
dataUncertainties.esMirror = sqrt(((vapourPressure(dataCalibrated.DPref+dataUncertainties.DPref,dataSynchronized.P) - ...
    vapourPressure(dataCalibrated.DPref-dataUncertainties.DPref,dataSynchronized.P))/2).^2 + ...
    ((vapourPressure(dataCalibrated.DPref,dataSynchronized.P+0) - ...
    vapourPressure(dataCalibrated.DPref,dataSynchronized.P-0))/2).^2 );

calParam = readtable(calibrationFile,'Sheet','calibration_constants','ReadRowNames',true,'basic',1);
IDgauge = string(calParam.ID(ismember(calParam.ID,settings.fluke(3,:)) & ismember(calParam.description,'gaugetrykmåler')));
dataCalibrated.pLFE = dataCalibrated.(IDgauge)+dataSynchronized.P;
dataUncertainties.pLFE = sqrt(dataUncertainties.(IDgauge).^2); % tager ikke højde for usikkerhed på atmosfæretryk (pHead)

dataCalibrated.esChamber = dataCalibrated.esMirror.*(dataCalibrated.pLFE)./dataSynchronized.P;
dataUncertainties.esChamber = sqrt((dataUncertainties.esMirror.*(dataCalibrated.pLFE./dataSynchronized.P)).^2 + ...
    (dataUncertainties.pLFE.*dataCalibrated.esMirror./dataSynchronized.P).^2); % + ... tager ikke højde for usikkerhed på atmosfæretryk 
    % (dataUncertainties.P.*dataCalibrated.esMirror.*dataCalibrated.pLFE./(dataCalibrated.pLFE.^2)).^2);