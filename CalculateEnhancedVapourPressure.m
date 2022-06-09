function [esf,uEsf] = CalculateEnhancedVapourPressure(dataCalibrated,dataUncertainties)
%CalculateEnhancedVapourPressure gets the enhanced vapour pressure plus uncertainty
%
% SYNOPSIS: [esf,uEsf] = CalculateEnhancedVapourPressure(td,p)
%
% INPUT td is the dew point temperature in °C
%		p is the pressure in Pa                
%
% OUTPUT esf is the enhanced vapour pressure in Pa
%			uEsf is the uncertainty (k=1) of the vapour pressure in Pa  
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 29-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,~,esf] = vapourPressure(dataCalibrated.tdChamber,dataCalibrated.pLFE);


[~,~,tdPlus] = vapourPressure(dataCalibrated.tdChamber + dataUncertainties.tdChamber,dataCalibrated.pLFE);
[~,~,tdMinus] = vapourPressure(dataCalibrated.tdChamber - dataUncertainties.tdChamber,dataCalibrated.pLFE);
[~,~,pLFEPlus] = vapourPressure(dataCalibrated.tdChamber,dataCalibrated.pLFE + dataUncertainties.pLFE);
[~,~,pLFEMinus] = vapourPressure(dataCalibrated.tdChamber,dataCalibrated.pLFE - dataUncertainties.pLFE);

uTd = (tdPlus-tdMinus)./2;
upLFE = (pLFEPlus - pLFEMinus)./2;

uEsf = sqrt(uTd.^2 + upLFE.^2);