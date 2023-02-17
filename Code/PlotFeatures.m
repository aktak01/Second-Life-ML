%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright @ 2022 Stanford Energy Control Laboratory (PI: simona onori), 
% Stanford University. All Rights Reserved. 
%
% FILE CONTENT >> Plotting SOH vs. features
%
% Developed by Aki Takahashi 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set up work environment
clearvars
clc
close all
%% specify settings for running program

names = {'LFP'; 'NMC'; 'LCO'};

name = names{3}; %choose chemistry

if(strcmp(name, 'LFP'))
    load('LFP/CCCVData_LFP.mat');
    cellNum = 4;  
elseif(strcmp(name, 'NMC'))
    load('NMC/CCCVData_NMC.mat');
    currList = {};
    cellNum = 4;
else
    load('LCO/CCCVData_LCO.mat');  
    cellNum = 7;
end

totalCells = length(socList);


%%
m = totalCells;
P = 0.7;
cutEnd = 0;
cycleList = [];

%eliminate current data for currList
yTrain = cell2mat(socList(cellNum));
if(strcmp(name, 'NMC'))
    xTrain = [cell2mat(resList(cellNum,1:7)) ];   
    rows = 2; 
    featureNum = 7;
else
    xTrain = [cell2mat(resList(cellNum,1:7)) cell2mat(currList(cellNum,1:7)) ];   
    rows = 3;
    featureNum = 14;
end

load('heatmapLabels');

%plot features in subplots
figure
for i = 1:featureNum
    
    subplot(rows,5,i);
    scatter(xTrain(:,i), yTrain, 2);
    xlabel(strjoin(['$\mathrm{' heatmapLabels(i) '}$']), 'interpreter', 'latex');
    if(mod(i,5) == 1)
        ylabel('SOH [\%]');
    end    
    box on
    grid on
    set(gca,'Fontsize',20);
    xlim([-inf inf]);
    
end
set(findall(gcf,'-property','interpreter'),'interpreter','latex')
set(findall(gcf,'-property','ticklabelinterpreter'),'ticklabelinterpreter','latex')
pos = [0 0 560*3.2   420*rows*1.5];
set(gcf, 'position', pos);

