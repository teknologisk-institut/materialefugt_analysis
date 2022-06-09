function td = DewPoint(es)
%DewPoint calculates the dew point based on a water vapour pressure
%
% SYNOPSIS: td = DewPoint(es)
%
% INPUT es is the water vapour pressure in Pa
%
% OUTPUT td is the dew point temperature in °C
%
% REMARKS
%
% created with MATLAB ver.: 9.12.0.1927505 (R2022a) Update 1 on Microsoft Windows 10 Enterprise Version 10.0 (Build 19042)
%
% created by: PEO
% DATE: 25-May-2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tNorm=273.15;
c = [2.0798233e2 -2.0156028e1 4.6778925e-1 -9.2288067e-6];
d = [1 -1.3319669e-1 5.6577518e-3 -7.5172865e-5];
td=((c(1)+c(2)*log(es).^1+c(3)*log(es).^2+c(4)*log(es).^3)./(d(1)+d(2)*log(es).^1+d(3)*log(es).^2+d(4)*log(es).^3)-tNorm);