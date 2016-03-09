

function [] = setupPlot(maxTime,level,generationNumber,iterationTime)


%TITLE
pos = get(gcf, 'Position');
titleBox = uicontrol('style','text');
set(titleBox,'FontSize',16);
set(titleBox,'FontWeight','bold');
set(titleBox,'HorizontalAlignment','center');
set(titleBox,'String',['Generation number ' num2str(generationNumber)]);
set(titleBox,'Position',[pos(3)/2-100 pos(4)/1.06 250 50]);

%Generation time
generationBox = uicontrol('style','text');
set(generationBox,'FontSize',8);
set(generationBox,'HorizontalAlignment','center');
set(generationBox,'String',['Iteration time ' num2str(iterationTime) ' seconds']);
set(generationBox,'Position',[50 50 250 50]);

%SETUPPLOT This sets up the plots
%   Detailed explanation goes here
subplot(2,2,1);

title('Y vs X');
xlabel('X (meters)')
ylabel('Y (meters)')
axis([level.x(1) level.x(end) level.minAxisValue level.maxAxisValue]);

subplot(2,2,2);
title('Average Fitness vs Generation');
xlabel('Generation Number')
ylabel('Average Fitness Score')

subplot(2,2,3);
title('Y vs time');
xlabel('Time (seconds)')
ylabel('Y (meters)')
xlim([0,maxTime]);
ylim([level.minAxisValue,level.maxAxisValue]);

subplot(2,2,4);
title('X vs time');
xlabel('Time (seconds)')
ylabel('X (meters)')


end

