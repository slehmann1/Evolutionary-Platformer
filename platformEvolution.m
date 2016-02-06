function platformEvolution()
    
    clear;
    clc;
    
    generationSize=100;
    
    
    tic;
    clf;
    setupPlot();
    subplot(2,1,1);
    level=Level();
    characters(1,generationSize) = Character();
    
    for i=1:generationSize
        m=ActionHandler.randomizedActions();
        characters(i) = Character(m,level);
        characters(i)=characters(i).run();
        characters(i).fitness=characters(i).calculateFitness(1,1,1);
    end
    averagePositions(characters,[1,0,0]);
    characters=sortByFitness(characters);
    averagePositions(characters(90:end),[0,1,0]);
    toc
    disp(toc);
    
end
%generate and plot the average positions
function averagePositions(characters,Color)
    %Calculate Average Positions
    averagePos = zeros(size(characters(2).positions));
    for i=1:size(characters(2))
        averagePos = averagePos+characters(i).positions;
    end
    averagePos=averagePos/size(characters,2);
    %Plot Average Positions
    
    subplot(2,1,1);
    path=line(averagePos(2,:),averagePos(3,:));
    path.Color=Color;
   
    
    subplot(2,2,3);
    path=line(averagePos(1,:),averagePos(3,:));
    path.Color=Color;
    
    subplot(2,2,4);
    path=line(averagePos(1,:),averagePos(2,:));
    path.Color=Color;
    

    
end
