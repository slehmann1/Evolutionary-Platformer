classdef generation
    %GENERATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        averagePos;
        averageFitness;
        
        %Whether or not the characters all survived the time, its only
        %worth displaying x vs y if this is true
        allSurvived=true;
    end
    
    methods
        function obj = generation(characters)
            obj=obj.averageData(characters);
            obj=obj.checkSurvival(characters);
            obj.plotPositions(obj.averagePos,[1,0,0,0.1],obj.allSurvived);
            
        end
        %Plots the positions onto the x,y,time graphs
        function plotPositions(~,positions,color,plotXY)
            global AXES;
            %Plot Average Positions
            if plotXY
                axes(AXES(1));
                path=line(positions(2,:),positions(3,:));
                path.Color=color;
            end
            
            axes(AXES(3));
            path=line(positions(1,:),positions(3,:));
            path.Color=color;
            
            axes(AXES(4));
            path=line(positions(1,:),positions(2,:));
            path.Color=color;
        end
        
        %Verifies whether or not all of the characters survived
        function generation = checkSurvival(generation,characters)
            for i=1:size(characters,2)
                if(characters(i).maxTime~=characters(i).maximumAllowedTime)
                    generation.allSurvived=false;
                    break;
                end
            end
        end
        %Calculates average data for the generation
        function generation = averageData(generation,characters)
            %generate the average positions
            %Calculate Average Positions/fitness
            generation.averagePos = zeros(size(characters(1).positions));
            generation.averageFitness=0;
            
            for i=1:size(characters,2)
                generation.averagePos = generation.averagePos+characters(i).positions;
                generation.averageFitness=generation.averageFitness+characters(i).undifferentiatedFitness;
            end
            generation.averagePos=generation.averagePos/size(characters,2);
            generation.averageFitness =  generation.averageFitness/size(characters,2);
            
        end
    end
    
end

