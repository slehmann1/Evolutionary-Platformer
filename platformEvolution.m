classdef platformEvolution
    properties
        level;
        averageFitness;
        topXAverageFitness;
        topFitness;
        generationCount;
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
            
            characters(1,Evolver.generationSize) = Character();
            obj.averageFitness=double.empty(2,0);
            obj.topXAverageFitness=double.empty(2,0);
            obj.topFitness=double.empty(2,0);
            for i=1:Evolver.generationSize
                m=ActionHandler.randomizedActions();
                characters(i) = Character(m,obj.level);
                characters(i)=characters(i).run();
                characters(i).fitness=characters(i).calculateFitness(1,1,20);
            end
            obj.generationCount=1;
            
            %Iterate more
            for i=1:100000
                [obj,characters]= platformEvolution.iterate(obj,characters);
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
        function [platform_Evolution,characters] = iterate(platform_Evolution,characters)
                
            clf;
            setupPlot(Character.maximumAllowedTime,platform_Evolution.level);
            subplot(2,2,1);
            hold on;
            platform_Evolution.level.drawLevel();
            for i=1:Evolver.generationSize
                characters(i)=characters(i).run();
                characters(i).fitness=characters(i).calculateFitness(1,1,20);
            end
            characters=sortByFitness(characters);
            gen = generation(characters,10);
            platform_Evolution.averageFitness( 1,size(platform_Evolution.averageFitness,2)+1) = gen.averageFitness;
            platform_Evolution.averageFitness( 2,size(platform_Evolution.averageFitness,2)) = size(platform_Evolution.averageFitness,2);
            platform_Evolution.topXAverageFitness( 1,size(platform_Evolution.topXAverageFitness,2)+1) = gen.topXAverageFitness;
            platform_Evolution.topXAverageFitness( 2,size(platform_Evolution.topXAverageFitness,2)) = size(platform_Evolution.topXAverageFitness,2);
            platform_Evolution.topFitness( 1,size(platform_Evolution.topFitness,2)+1) = characters(end).fitness;
            platform_Evolution.topFitness( 2,size(platform_Evolution.topFitness,2)) = size(platform_Evolution.topFitness,2);
            %Draw character graphs
            
            %draws the character's path
            subplot(2,2,1);
            platformEvolution.drawGraph(characters,2,3,[0,0,0,0.5]);
            
            subplot(2,2,2);
            line(platform_Evolution.averageFitness(2,:),platform_Evolution.averageFitness(1,:));
            line(platform_Evolution.topXAverageFitness(2,:),platform_Evolution.topXAverageFitness(1,:));
            line(platform_Evolution.topFitness(2,:),platform_Evolution.topFitness(1,:));
            
            
            subplot(2,2,1);
            platformEvolution.drawGraph(characters,2,3,[0,0,0,0.5]);
            
            subplot(2,2,3);
            platformEvolution.drawGraph(characters,1,3,[0,0,0,0.5]);
            
            subplot(2,2,4);
            platformEvolution.drawGraph(characters,1,2,[0,0,0,0.5]);
            drawnow();
            platform_Evolution.generationCount=platform_Evolution.generationCount+1;
        end
        
    end
end
