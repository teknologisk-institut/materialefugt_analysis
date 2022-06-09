clear variables

filePath = 'C:\Users\peo\Documents\GitHub\materialefugt\';
addpath('../VaisalaHMT330/','../FLUKE1586A','../MEMMERT/','../MBW573', '../materialefugt_analysis/')
addpath('../materialefugt/')
settings = MaterialMoistureReadSettings('C:\Users\peo\Documents\GitHub\materialefugt\');

calibrationFile="C:\Users\peo\Documents\GitHub\materialefugt_analysis\calibration_constants.xlsx";

dataRaw = AccumulatedMoistureImportData();
dataSynchronized = AccumulatedMoistureSyncData(dataRaw);
[dataCalibrated,dataUncertainties] = AccumulatedMoistureCalibrateData(dataSynchronized,calibrationFile,settings); % perfom adjustments of sensor data based on calibrations
[dataCalibrated,dataUncertainties] = AccumulatedMoistureViscosityCorrection(dataCalibrated,dataUncertainties,calibrationFile); % correct air flow for viscosity effects
[dataCalibrated,dataUncertainties] = AccumulatedMoistureDewPointCorrection(dataCalibrated,dataUncertainties,dataRaw); % find consensus dewpoint by adjusting secondary dew point sensor to mirror
[dataCalibrated,dataUncertainties] = calculateVapourPressure(dataCalibrated,dataUncertainties,dataSynchronized,calibrationFile,settings); % calculate the vapour pressure at the mirror
[dataCalibrated,dataUncertainties] = CalculateDewPoint(dataCalibrated,dataUncertainties);
[dataCalibrated.esfChamber,dataUncertainties.esfChamber] = CalculateEnhancedVapourPressure(dataCalibrated,dataUncertainties);
[dataCalibrated.qChamberH2O,dataUncertainties.qChamberH2O] = CalculateChamberFlow(dataCalibrated,dataUncertainties,calibrationFile);
[dataCalibrated.ah,dataUncertainties.ah] = CalculateAbsHumidity(dataCalibrated,dataUncertainties,calibrationFile);

[aw,uAw] = AccumulatedWater(dataCalibrated,dataUncertainties)

display(strcat('water content equals ', string(aw),'g ± ',string(2*uAw), 'g'))

