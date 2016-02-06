classdef generation
    %GENERATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        averagePos;
        averageFitness;
        topXAveragePos;
        topXAverageFitness;
        %Whether or not the characters all survived the time, its only
        %worth displaying x vs y if this is true
        allSurvived=true;
        allXSurvived=true;
        %The topX fittest characters will be considered when calculating
        %topX data
        topX;
    end
    
    methods
        function obj = generation(characters,topX)
            obj.topX=topX;
            obj=obj.averageData(characters);
            obj=obj.xAverageData(characters);
            obj=obj.checkSurvival(characters);
            obj.plotPositions(obj.averagePos,[1,0,0],obj.allSurvived);
            obj.plotPositions(obj.topXAveragePos,[0,1,0],obj.allXSurvived);
            
        end
        %Plots the positions onto the x,y,time graphs
        function plotPositions(~,positions,color,plotXY)
            %Plot Average Positions
            if plotXY
                subplot(2,1,1);
                path=line(positions(2,:),positions(3,:));
                path.Color=color;
            end
            
            subplot(2,2,3);
            path=line(positions(1,:),positions(3,:));
            path.Color=color;
            
            subplot(2,2,4);
            path=line(positions(1,:),positions(2,:));
            path.Color=color;
        end
        %Calculates average data for the topX
        function generation = xAverageData(generation,characters)
            %generate the average positions
            %Calculate Average Positions/fitness
            generation.topXAveragePos = zeros(size(characters(2).positions));
            generation.topXAverageFitness=0;
            
            %The characters are ordered from least to greatest fitness,
            %start at the topX position, work to the most fit
            characters = characters(size(characters,2)-generation.topX:size(characters,2));
            for i=1:size(characters,2)
                generation.topXAveragePos = generation.topXAveragePos+characters(i).positions;
                generation.topXAverageFitness=generation.topXAverageFitness+characters(i).fitness;
            end
            
            generation.topXAveragePos=generation.topXAveragePos/generation.topX;
            generation.topXAverageFitness =  generation.topXAverageFitness/generation.topX;
            
        end
        %Verifies whether or not all of the characters survived
        function generation = checkSurvival(generation,characters)
            for i=1:size(characters,2)
                if(characters(i).maxTime~=characters(i).maximumAllowedTime)
                    generation.allSurvived=false;
                    break;
                end
            end
            characters = characters(size(characters,2)-generation.topX:size(characters,2));
            for i=1:size(characters,2)
                if(characters(i).maxTime~=characters(i).maximumAllowedTime)
                    generation.allXSurvived=false;
                    break;
                end
            end
        end
        %Calculates average data for the generation
        function generation = averageData(generation,characters)
            %generate the average positions
            %Calculate Average Positions/fitness
            generation.averagePos = zeros(size(characters(2).positions));
            generation.averageFitness=0;
            
            for i=1:size(characters,2)
                generation.averagePos = generation.averagePos+characters(i).positions;
                generation.averageFitness=generation.averageFitness+characters(i).fitness;
            end
            generation.averagePos=generation.averagePos/size(characters,2);
            generation.averageFitness =  generation.averageFitness/size(characters,2);
            
        end
    end
    
end

