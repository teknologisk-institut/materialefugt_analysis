function [dataCalibrated,dataUncertainties] = CalculateDewPoint(dataCalibrated,dataUncertainties)
%CalculateDewPoint finds the dew point based on water vapour pressure
%
% SYNOPSIS: [dataCalibrated,dataUncertainties] = CalculateDewPoint(dataCalibrated,dataUncertainties)
%
% INPUT dataCalibrated is a timetable containing the calibrated data
%		dataUncertainties is a timetable containing the measurement uncertainties  
%
% OUTPUT as above, but updated with new metrics
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 25-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataCalibrated.tdChamber = DewPoint(dataCalibrated.esChamber);

dataUncertainties.tdChamber = (DewPoint(dataCalibrated.esChamber + dataUncertainties.esChamber) - DewPoint(dataCalibrated.esChamber - dataUncertainties.esChamber))./2;