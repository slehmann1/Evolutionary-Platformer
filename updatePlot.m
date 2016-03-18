function   updatePlot(generationNumber,iterationTime)
    %UPDATEPLOT Summary of this function goes here
    %   Detailed explanation goes here
    %TITLE
    
    pos = get(gcf, 'Position');
    global TITLEBOX
    set(TITLEBOX,'String',['Generation number ' num2str(generationNumber)]);
    set(TITLEBOX,'Position',[pos(3)/2-100 pos(4)-30 250 30]);
    global GENERATIONBOX
    %Generation time
    set(GENERATIONBOX,'String',['Iteration time: ' num2str(iterationTime) ' seconds']);
end

