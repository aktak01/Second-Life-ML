%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright @ 2022 Stanford Energy Control Laboratory (PI: simona onori), 
% Stanford University. All Rights Reserved. 
%
% FILE CONTENT >> Plotting boxplots for observing model performance
%
% Developed by Aki Takahashi 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set up work environment
clearvars
clc
close all

%% Create box plots

close all 

lco = load('LCO\LCO_Boxplot.mat');
lfp = load('LFP\LFP_Boxplot.mat');
nmc = load('NMC\NMC_Boxplot.mat');

datasetLabels = ['NMC'; 'LCO'; 'LFP'];

%plot results
figure; box on; hold on; grid on;
pos = [100 100 560 420];
set(gcf, 'position', pos);
%NOTE: For MATLAB versions before R2021a, please use the following line
%boxplot([nmc.listRMSE, lco.listRMSE, lfp.listRMSE ], 'labels', datasetLabels);
boxplot([nmc.listRMSE, lco.listRMSE, lfp.listRMSE ], Labels = datasetLabels);
ylabel('RMSPE [\%]', 'interpreter', 'latex');
xlim([0 4]); ylim([0 5]);
yticks([0:1:5]);
set(gca,'Fontsize',20);
set(findall(gcf,'-property','interpreter'),'interpreter','latex')
set(findall(gcf,'-property','ticklabelinterpreter'),'ticklabelinterpreter','latex')

figure; box on; hold on; grid on;
pos2 = [100 100 560  420];
set(gcf, 'position', pos2);
%NOTE: For MATLAB versions before R2021a, please use the following line
% boxplot([nmc.listMPE, lco.listMPE, lfp.listMPE ], 'labels', datasetLabels);
boxplot([nmc.listMPE, lco.listMPE, lfp.listMPE ], Labels = datasetLabels);
ylabel('MPE [\%]','interpreter','latex');
xlim([0 4]); ylim([0 5]);
yticks([0:1:5]);
set(gca,'Fontsize',20);
set(findall(gcf,'-property','interpreter'),'interpreter','latex')
set(findall(gcf,'-property','ticklabelinterpreter'),'ticklabelinterpreter','latex')



figure; box on; hold on; grid on;
pos3 = [100 100 560  420];
set(gcf, 'position', pos3);
%NOTE: For MATLAB versions before R2021a, please use the following line
% boxplot([nmc.listCalibration, lco.listCalibration, lfp.listCalibration ], 'labels', datasetLabels);
boxplot([nmc.listCalibration, lco.listCalibration, lfp.listCalibration ], Labels = datasetLabels);
xlim([0 4]);
ylabel('CS [-]','interpreter','latex');
set(gca,'Fontsize',20);
set(findall(gcf,'-property','interpreter'),'interpreter','latex')
set(findall(gcf,'-property','ticklabelinterpreter'),'ticklabelinterpreter','latex')

