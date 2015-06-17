clear;
clc;
baseAddressToSave = 'alldata';
fileAddress = '../../../database_correct/data_26_6_88_ENDTaging.lbl';
numberToSave = 500000;
tic;
readData(fileAddress,numberToSave,baseAddressToSave);
readFileTime = toc;
tic;
[mapping] = mappingExtraction(baseAddressToSave,1,21);
mappingExtractionTime = toc;
fprintf('Saving mapping\n');
save('mapping','mapping');



