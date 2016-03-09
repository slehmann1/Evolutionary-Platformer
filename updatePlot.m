function   updatePlot(level,generationNumber,iterationTime)
%UPDATEPLOT Summary of this function goes here
%   Detailed explanation goes here
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

subplot(2,2,1);

title('Y vs X');
xlabel('X (meters)')
ylabel('Y (meters)')
axis([level.x(1) level.x(end) level.minAxisValue level.maxAxisValue]);
end

