function [dataCalibrated,dataUncertainties] = AccumulatedMoistureDewPointCorrection(dataCalibrated,dataUncertainties,rawData)
%AccumulatedMoistureDewPointCorrection combines data from dew point hygrometer (mirror) and capacitive meter to try to remove biases from mirror contamination
%
% SYNOPSIS: dataCalibrated = AccumulatedMoistureDewPointCorrection(dataCalibrated, rawData)
%
% INPUT dataCalibrated contains the calibrated dew point values
%		dataSynchronized contains extra data for the sensors, including data on mirror-cleaning, purging of RH-sensor etc.  
%
% OUTPUT dataCalibrated contains the calibrated sensor data
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 20-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% find most stable mirror readings in 5 minute period after mirror cleaning
mirrorCleanEnd = rawData.mbw.Time(rawData.mbw.MirrorCheck(2:end)==0 & rawData.mbw.MirrorCheck(1:end-1)==1);
calibrationTable = table('Size',[size(mirrorCleanEnd,1),2],'VariableTypes',["double","double"],'VariableNames',["reference","secondary"]);

dT = minutes(7);
for i=1:size(mirrorCleanEnd,1)
    TR = timerange(mirrorCleanEnd(i),mirrorCleanEnd(i)+dT);
    tempData =dataCalibrated(TR,:);
    stability = movstd(tempData.DP,10); % find stability of data
    bestFit = (stability==min(stability));
    calibrationTable(i,:)=table(tempData.DP(bestFit),tempData.Td(bestFit));
end

[fitParameters,S] = polyfit(calibrationTable.secondary,calibrationTable.reference,4);
referenceDewPoint = polyval(fitParameters,dataCalibrated.Td);
dataCalibrated.DPref = referenceDewPoint;
dataUncertainties.DPref = sqrt(dataUncertainties.DP.^2+(S.normr^2/(size(calibrationTable,1)-1)));