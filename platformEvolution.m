function platformEvolution()
    
    clear;
    clc;
    
    generationSize=100;
    
    
    tic;
    clf;
    level=Level();
    setupPlot(Character.maximumAllowedTime,level);
    subplot(2,1,1);
    hold on;
    level.drawLevel();
    
    characters(1,generationSize) = Character();
    
    for i=1:generationSize
        m=ActionHandler.randomizedActions();
        characters(i) = Character(m,level);
        characters(i)=characters(i).run();
        characters(i).fitness=characters(i).calculateFitness(1,1,1);
    end
    
    characters=sortByFitness(characters);
    generation(characters,10);
    
    
    toc
    disp(toc);
    
end

