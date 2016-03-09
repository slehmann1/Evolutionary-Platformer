classdef Evolver
    %EVOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        %whether or not attributes should be averaged when breeding
        average=true;
    end
    methods (Static)
        %Start a new generation by evolving
        function characters = evolve(characters)
            global evolverConfig;
            clones = characters(evolverConfig.generationSize-evolverConfig.numberOfClones+1:evolverConfig.generationSize);
            characters = Evolver.selectBreedingPairs(characters);
            characters = Evolver.breed(characters);
            characters = Evolver.mutate(characters);
            if evolverConfig.numberOfClones>0
                characters((evolverConfig.generationSize-evolverConfig.numberOfClones+1):evolverConfig.generationSize)=clones;
            end
        end
        function characters = mutate(characters)
            global evolverConfig;
            startPoint =1;
            for i=startPoint:size(characters,2)
                if(rand<=evolverConfig.mutationRate)
                    %Mutate
                    characters(i)=Evolver.mutateCharacter(characters(i));
                end
                
            end
        end
        function character= mutateCharacter(character)
            global evolverConfig;
            %Choose the mutation type
            mutationType = rand;
            if mutationType<=evolverConfig.addActionRate %Add an action
                character.actions(end+1) = ActionHandler.randomAction();
            elseif mutationType<=(evolverConfig.removeActionRate-evolverConfig.addActionRate) %Remove the action
                if size(character.actions,2)>=2
                    mutationLocation = Evolver.randomInt(2,size(character.actions,2));
                    %Delete the element
                    character.actions(mutationLocation) = [];
                end
            else %Change the action
                %Currently only mutates one point
                if size(character.actions,2)>=1
                    mutationLocation = Evolver.randomInt(2,size(character.actions,2));
                    character.actions(mutationLocation) = ActionHandler.randomAction();
                end
            end
            
            
        end
        %Uses roulette wheel selection (proportional to fitness)
        function breeders = selectBreedingPairs (characters)
            global evolverConfig;
            %Preallocate breeders
            breeders = [characters; characters];
            indices = zeros(size(breeders));
            %Generate a cumulative fitness list
            fitnesses = zeros([1,evolverConfig.generationSize]);
            fitnesses(1)=characters(1).fitness;
            for index=2:evolverConfig.generationSize
                fitnesses(index)= fitnesses(index-1)+characters(index).fitness;
            end
            
            %Assign breeding pairs using roulette wheel selection
            for index=1:evolverConfig.generationSize
                %Generate the two indices
                randomFitness = rand*(fitnesses(end)-fitnesses(1))+fitnesses(1);
                indexA=Evolver.getRouletteWheelIndex(fitnesses,randomFitness);
                randomFitness = rand*(fitnesses(end)-fitnesses(1))+fitnesses(1);
                indexB=Evolver.getRouletteWheelIndex(fitnesses,randomFitness);
                breeders(:,index)=[characters(indexA);characters(indexB)];
                indices(:,index)=[indexA;indexB];
            end
            
            
        end
        %Returns an index based on the fitnesses and the chosenFitness
        function index=getRouletteWheelIndex(fitnesses,chosenFitness)
            %Determine the index
            for index=1:size(fitnesses,2)
                if chosenFitness<=fitnesses(index)
                    return
                end
            end
            disp(index);
            error('No Index Selected');
        end
        function int = randomInt(startInt,endInt)
            int = startInt+round(rand(1)*(endInt-startInt));
        end
        function offspring = breed(breedingPair)
            %Prevents having to call the constructor
            offspring = breedingPair(1,1:end);
            
            if(~Evolver.average)
                %This simulation only does a single crossover, could implement
                %possibilities of more later
                for i=1:size(offspring,2)
                    crossoverPoint = min([size(breedingPair(1).actions,2),size(breedingPair(2).actions,2)]);
                    crossoverPoint=Evolver.randomInt(1,crossoverPoint);
                    actions = [breedingPair(1).actions(1:crossoverPoint) breedingPair(2).actions(crossoverPoint+1:end)];
                    %Have to resort actions
                    actions =ActionHandler.sortActions(actions);
                    offspring(i).actions=actions;
                end
            else
                for i=1:size(offspring,2)
                    actions=breedingPair(1).actions;
                    for ii=2:size(breedingPair(1).actions,2)
                        try
                            actions(ii).speed = (breedingPair(1).actions(ii).speed+breedingPair(2).actions(ii).speed)/2;
                            actions(ii).time = (breedingPair(1).actions(ii).time+breedingPair(2).actions(ii).time)/2;
                        catch
                      
                        end
                        
                    end
                    actions(1) = Move(0,2);
                    actions =ActionHandler.sortActions(actions);
                    offspring(i).actions=actions;
                end
                
            end
        end
    end
    
end

