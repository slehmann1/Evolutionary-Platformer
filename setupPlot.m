

function [] = setupPlot(maxTime,level,generationNumber,iterationTime)

global FIGUREWINDOW;
if ~ishandle(FIGUREWINDOW)
    FIGUREWINDOW=figure('Position',[1 100 1000 700]);
end
%TITLE
global TITLEBOX
pos = get(gcf, 'Position');
TITLEBOX = uicontrol('style','text');
set(TITLEBOX,'FontSize',16);
set(TITLEBOX,'FontWeight','bold');
set(TITLEBOX,'HorizontalAlignment','center');
set(TITLEBOX,'String',['Generation number ' num2str(generationNumber)]);
set(TITLEBOX,'Position',[pos(3)/2-100 pos(4)-30 250 30]);
global GENERATIONBOX
%Generation time
GENERATIONBOX = uicontrol('style','text');
set(GENERATIONBOX,'FontSize',10);
set(GENERATIONBOX,'HorizontalAlignment','center');
set(GENERATIONBOX,'String',['Iteration time ' num2str(iterationTime) ' seconds']);
set(GENERATIONBOX,'Position',[0 0 200 20]);

global AXES;

%SETUPPLOT This sets up the plots
%   Detailed explanation goes here
AXES(1)=subplot(2,2,1);
title('Y vs X');
xlabel('X (meters)')
ylabel('Y (meters)')
axis([level.x(1) level.x(end) level.minAxisValue level.maxAxisValue]);

AXES(2)=subplot(2,2,2);
title('Fitness vs Generation');
xlabel('Generation Number')
ylabel('Average Fitness Score');
global LEGEND


%Create Legend
%Have to plot empty lines, cuz matlab
line(0,0,'Color',[1,0,0,0.5],'LineWidth',platformEvolution.fitnessLineWidth);
line(0,0,'Color',[0,0,1,0.2],'LineWidth',platformEvolution.fitnessLineWidth);

LEGEND=legend({'average fitness','best fitness'}, 'Position', [0.794,0.584,0.1,0.06]);

AXES(3)=subplot(2,2,3);
title('Y vs time');
xlabel('Time (seconds)')
ylabel('Y (meters)')
xlim([0,maxTime]);
ylim([level.minAxisValue,level.maxAxisValue]);

AXES(4)=subplot(2,2,4);
title('X vs time');
xlabel('Time (seconds)')
ylabel('X (meters)')



end

