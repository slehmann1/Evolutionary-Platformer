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
        function drawGraph(characters,a,b,Color)
            for i=1:size(characters,2)
                path=line(characters(i).positions(a,:),characters(i).positions(b,:));
                path.Color=Color;
            end
        end
        %Runs a generation
        function iterate(platform_Evolution,characters)
            clf;
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
            
            %Draw character graphs
            
            %draws the character's path
            subplot(2,1,1);
            platformEvolution.drawGraph(characters,2,3,[0,0,0,0.5]);
            
            subplot(2,2,3);
            platformEvolution.drawGraph(characters,1,3,[0,0,0,0.5]);
            
            subplot(2,2,4);
            platformEvolution.drawGraph(characters,1,2,[0,0,0,0.5]);
            drawnow();
            
        end
        
    end
end
