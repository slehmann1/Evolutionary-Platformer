classdef platformEvolution
    properties (Constant)
        generationSize=100;
    end
    properties
       level; 
    end
    methods (Static)
        function obj= platformEvolution()
            
            clear;
            clc;
            tic;
            clf;
            obj.level=Level();
            setupPlot(Character.maximumAllowedTime,obj.level);
            subplot(2,1,1);
            hold on;
            obj.level.drawLevel();
            
            characters(1,platformEvolution.generationSize) = Character();
            
            for i=1:platformEvolution.generationSize
                m=ActionHandler.randomizedActions();
                characters(i) = Character(m,obj.level);
                characters(i)=characters(i).run();
                characters(i).fitness=characters(i).calculateFitness(1,1,1);
            end
            
            for i=1:100
                platformEvolution.iterate(obj,characters);
                characters=Evolver.evolve(characters);
            end
            
            
            toc
            disp(toc);
            
        end
        %Runs a generation
        function iterate(platform_Evolution,characters)
            setupPlot(Character.maximumAllowedTime,platform_Evolution.level);
            subplot(2,1,1);
            hold on;
            platform_Evolution.level.drawLevel();
            for i=1:platformEvolution.generationSize
                characters(i)=characters(i).run();
                characters(i).fitness=characters(i).calculateFitness(1,1,1);
            end
            
            characters=sortByFitness(characters);
            generation(characters,10);
            pause(2);
            hold off;
        end
    end
end