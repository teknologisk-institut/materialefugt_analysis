function [flowCorrected]=Sutherland(flow,temp,gasType)
%Sutherland calculates the flow, including effects from temperature dependend viscosity
%
% SYNOPSIS: [flowCorrected]=Sutherland(flow,temp,gasType)
%
% INPUT flow is the uncorrected flow, found by the sensors
%		temp is the temperature of the gas
%		gasType is the type of gas (air,N2)                 
%
% OUTPUT flowCorrected is the viscosity-adjusted flow rate
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 19-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  sutherland parameters for air and N2
sland = {[111 273 17.16e-6] [107 273 16.63e-6]};
tNorm = 273.15;

%  standard viscosity for air at 21 °C
% Sutherlands formula is replace by standard value from calibration certificate
eta0 = 18.2565e-6;
% eta0 = sland{1}(3)*(sland{1}(2)+sland{1}(1))/(tNorm + 21.1 +sland{1}(1))*((tNorm+21.1)/sland{1}(2))^(3/2);

%  viscosity of the applied gas at the room temperature
eta = (sland{gasType}(3)*(sland{gasType}(2)+sland{gasType}(1))*(tNorm + temp+sland{gasType}(1)).^-1).*((tNorm+temp)/sland{gasType}(2)).^(3/2);

%  find relative viscosity throughout the test
etaEfficient = eta0./eta;
%  adjust the flow with regards to gas type and temperature
flowCorrected = flow.*etaEfficient;
