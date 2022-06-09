function [aw,uAw] = AccumulatedWater(dataCalibrated,dataUncertainties)
%AccumulatedWater sums up the contributions to the total water evaporated from the sample
%
% SYNOPSIS: [aw,uAw] = AccumulatedWater(dataCalibrated,dataUncertainties)
%
% INPUT 
%
% OUTPUT 
%
% REMARKS
%
% created with MATLAB ver.: 9.10.0.1602886 (R2021a) on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 30-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

timeSteps = zeros(size(dataCalibrated,1),1);

timeSteps(2:end) = seconds(dataCalibrated.Time(2:end)-dataCalibrated.Time(1:end-1));
awStep = dataCalibrated.ah.*(dataCalibrated.qChamberH2O./(60*1000)).*timeSteps;
aw = sum(awStep,1);


uAwStep = sqrt( ...
    (dataUncertainties.ah.*(dataCalibrated.qChamberH2O./(60*1000)).*timeSteps).^2 + ...
    (dataUncertainties.qChamberH2O.*dataCalibrated.ah./(60*1000).*timeSteps).^2);

uAw = sum(uAwStep,1);


% [aw,~]=accumulatedWater(ah,calData.Timestamp,flowChamberWater);
% [uncAhPlus,~]=accumulatedWater(ah+uah,calData.Timestamp,flowChamberWater);
% [uncAhMinus,~]=accumulatedWater(ah-uah,calData.Timestamp,flowChamberWater);
% [uncFlowPlus,~]=accumulatedWater(ah,calData.Timestamp,flowChamberWater+uFlowChamberWater);
% [uncFlowMinus,~]=accumulatedWater(ah,calData.Timestamp,flowChamberWater-uFlowChamberWater);
% 
% unc=sqrt(...
%     ((uncAhPlus-uncAhMinus)/2).^2+...
%     ((uncFlowPlus-uncFlowMinus)/2).^2);


