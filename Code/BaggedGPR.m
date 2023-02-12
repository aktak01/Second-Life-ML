%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright @ 2022 Stanford Energy Control Laboratory (PI: simona onori, sonori@stanford.edu), 
% Stanford University. All Rights Reserved. 
%
% FILE CONTENT >> Bagged GPR Model main file
%
% Developed by Aki Takahashi 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
addpath Functions
%%
clearvars
clc
close all

%% specify settings for running program

names = {'LFP'; 'NMC'; 'LCO'};

name = names{3}; %choose chemistry


if(strcmp(name, 'LFP'))
    load('LFP/CCCVData_LFP.mat');
    numIterations = 6;
    numBags = 20;
    sampleSize = 200;
    numFeatures = 10;  
elseif(strcmp(name, 'NMC'))
    load('NMC/CCCVData_NMC.mat');
    currList = {};
    numIterations = 150;
    numBags = 3;
    sampleSize = 20;
    numFeatures = 7;
else
    load('LCO/CCCVData_LCO.mat');
    numIterations = 50;
    numBags = 7;
    sampleSize = 30;
    numFeatures = 10;
end

totalCells = length(socList);

%turn on for baseline model performance
numBags = 1;
sampleSize = -1;
%% Comprehensive Bagging Analysis. Iterate process multiple times

[listRMSE, listMPE, listCalibration, trainError, testError] = IterativeGPR(numIterations, numBags, sampleSize, numFeatures, totalCells, resList, currList, socList);


disp(['median RMSPE = ' num2str(nanmedian(listRMSE))]);
disp(['mean RMSPE = ' num2str(nanmean(listRMSE))]);
disp(['median MPE =  ' num2str(nanmedian(listMPE))]);
disp(['mean MPE =  ' num2str(nanmean(listMPE))]);
disp(['mean CS = ' num2str(nanmean(listCalibration))]);



%plot training and test error
testError = vertcat(testError{:});
figure; hold on
h = histogram(trainError, 30);
histogram(testError, h.BinEdges);
grid on; box on;
xlabel('SOH Error (Actual - Predicted) [\%]','fontsize',20,'interpreter','latex');
ylabel('Frequency [-]','fontsize',20,'interpreter','latex');
legend('Train','Test','location','northeast')
set(gca,'Fontsize',20);
set(findall(gcf,'-property','interpreter'),'interpreter','latex')
set(findall(gcf,'-property','ticklabelinterpreter'),'ticklabelinterpreter','latex')
%%
rmpath Functions