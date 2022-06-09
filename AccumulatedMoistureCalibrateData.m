function [dataCalibrated,dataUncertainty] = AccumulatedMoistureCalibrateData(data,calibrationFile,settings)
%AccumulatedMoistureCalibrateData calibrates the sensor data using the most recent instrument calibrations available
%
% SYNOPSIS: dataCalibrated = AccumulatedMoistureCalibrateData(rawData,calibrationFile)
%
% INPUT rawData is the sensor output without any corrections
%		calibrationFile is the path + filename of the file containing calibration data for the instruments  
%
% OUTPUT cataCalibrated contains the calibrated sensor data
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 17-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% create structure for uncertainties
dataUncertainty = timetable(data.Time);
dataCalibrated = timetable(data.Time);

%% read calibration parameters from file
calParam = readtable(calibrationFile,'Sheet','calibration_constants','ReadRowNames',true,'basic',1);
tempSensors = calParam.Properties.RowNames(string(calParam.unit)=='K',:); % find all temperature sensors in calibration parameter-file

%% calibrate data from MBW dew point hygrometer
IDmbw = "122486";
dataCalibrated.DP = polyval(table2array(calParam(IDmbw,5:-1:2)),data.DP);
dataUncertainty.DP(:) = calParam(IDmbw,"U").Variables/2;

%% calibrate data form vaisala RH sensor
IDvaisala = "114367";
dataCalibrated.Td=polyval(table2array(calParam(IDvaisala,5:-1:2)),data.Td);
dataUncertainty.Td(:) = calParam(IDvaisala,"U").Variables/2;

%% calibrate data from FLUKE DMM
for i=1:size(settings.fluke,2)
    ID = string(settings.fluke(3,i));
    if ismember(ID,tempSensors)
        dataCalibrated.(ID)=(calParam(ID,:).a0 + calParam(ID,:).a1*log(data.(ID)) + calParam(ID,:).a2*(log(data.(ID)).^2) + calParam(ID,:).a3*(log(data.(ID)).^3)).^(-1)-273.15;
    else
        dataCalibrated.(ID)=polyval(table2array(calParam(ID,5:-1:2)),data.(ID));
    end
    dataUncertainty.(ID)(:)=calParam(ID,"U").Variables/2;
end

%% create column for laminar flow element
IDdiff = "115885"; % differential pressure module
IDlfe = "111407"; % id of LFE
dataCalibrated.(IDlfe) = polyval(table2array(calParam(IDlfe,5:-1:2)),dataCalibrated.(IDdiff));
dataUncertainty.(IDlfe) = sqrt((calParam(IDlfe,"U").Variables/2)^2 +...
    (polyval(table2array(calParam(IDlfe,5:-1:2)),dataCalibrated.(IDdiff)+calParam(IDdiff,"U").Variables/2)-...
    polyval(table2array(calParam(IDlfe,5:-1:2)),dataCalibrated.(IDdiff)-calParam(IDdiff,"U").Variables/2)).^2);
