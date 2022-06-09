% find the ideal vapour pressure, based on the dew point temperature
function [es,f,esf] = vapourPressure(td,pHead)

%constants
tNorm = 273.15;
pNorm = 101325;

%  constants from Hardy: ITS-90 formulations for vapor pressure, frostpoint temperature, dewpoint temperature, and enhancement factors in the range -100 to +100C, "The Proceedings of the Third International Symposium on Humidity & Moisture. April 1998
g = [-2.8365744E3 -6.028076559E3 1.954263612E1 -2.737830188E-2 1.6261698E-5 7.0229056E-10 -1.8680009E-13 2.7150305];
k = [-5.8666426e3 2.232870244e1 1.39387003e-2 -3.4262402e-5 2.7040955e-8 6.7063522e-1];
temp = td+tNorm;

%  ideal vapour pressure
esTotalHelper=zeros(size(temp,1),1);
esTotalHelper(td>0)= g(1)*temp(td>0).^-2+g(2)*temp(td>0).^-1 + g(3) +g(4)*temp(td>0) + g(5)*temp(td>0).^2 + g(6)*temp(td>0).^3 + g(7)*temp(td>0).^4 + g(8)*log(temp(td>0));
esTotalHelper(td<0) = k(1)*temp(td<0).^-1+k(2)*temp(td<0).^0+k(3)*temp(td<0).^1+k(4)*temp(td<0).^2+k(5)*temp(td<0).^3+k(6)*log(temp(td<0));
es = exp(esTotalHelper);

%  enhancement factor
% for td>0 °C (to be calculated in absolute temperatures)
A1 = [-1.6302041e-1 1.8071570e-3 -6.7703064e-6 8.5813609e-9];
B1 = [-5.9890467e1 3.4378043e-1 -7.7326396e-4 6.3405286e-7];
% for td<0 °C (to be calculated in absolute temperatures)
A2 = [-7.1044201e-2 8.6786223e-4 -3.5912529e-6 5.0194210e-9];
B2 = [-8.2308868e1 5.6519110e-1 -1.5304505e-3 1.5395086e-6];

alpha = zeros(size(temp,1),1);
beta = zeros(size(temp,1),1);

alpha(td>0) = A1(1)+A1(2)*temp(td>0)+A1(3)*temp(td>0).^2+A1(4)*temp(td>0).^3;
alpha(td<0) = A2(1)+A2(2)*temp(td<0)+A2(3)*temp(td<0).^2+A2(4)*temp(td<0).^3;

beta(td>0) = exp(B1(1)+B1(2)*temp(td>0)+B1(3)*temp(td>0).^2+B1(4)*temp(td>0).^3);
beta(td<0) = exp(B2(1)+B2(2)*temp(td<0)+B2(3)*temp(td<0).^2+B2(4)*temp(td<0).^3);

f=exp(alpha.*(1-(es./pHead))+beta.*(pHead./es-1));

%  vapour pressure compensated with enhancement factor
esf = es.*f;