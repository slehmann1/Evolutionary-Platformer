classdef Evolver
    %EVOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        %whether or not attributes should be averaged when breeding
        average=true;
        topBreeders=30;
        generationSize=500;
        %If this is true, then the best character will breed with itself
        numberOfClones=2;
        mutationRate=0.1;
    end
    methods (Static)
        %Start a new generation by evolving
        function characters = evolve(characters)
            clones = characters(Evolver.generationSize-Evolver.numberOfClones+1:Evolver.generationSize);
            characters = Evolver.selectBreedingPairs(characters);
            characters = Evolver.breed(characters);
            characters = Evolver.mutate(characters);
            if Evolver.numberOfClones>0
                characters((Evolver.generationSize-Evolver.numberOfClones+1):Evolver.generationSize)=clones;
            end
        end
        function characters = mutate(characters)
            startPoint =1;
            for i=startPoint:size(characters,2)
                if(rand<=Evolver.mutationRate)
                    %Mutate
                    characters(i)=Evolver.mutateCharacter(characters(i));
                end
                
            end
        end
        function character= mutateCharacter(character)
            %Currently only mutates one point
            mutationLocation = Evolver.randomInt(1,size(character.actions,2));
            character.actions(mutationLocation) = ActionHandler.randomAction();
            
        end
        function breeders = selectBreedingPairs (characters)
            %Preallocate breeders
            breeders = [characters; characters];
            %The progress in assigning breedingPairs
            
            currentIndex=1;
            %Top breeders C 2
            %For example, if TopBreeders = 3, pairs: 1-2,1-3,2-3 number of
            %pairs = 3C2=3
            for outer=currentIndex:Evolver.topBreeders
                for inner = outer+1:Evolver.topBreeders
                    breeders(:,currentIndex) = [characters(outer); characters(inner)];
                    currentIndex=currentIndex+1;
                end
            end
            
            %Now fill the remaining slots with randoms
            %This for loop syntax makes me vomit
            for currentIndex=currentIndex:Evolver.generationSize
                index1 =Evolver.randomInt(1,Evolver.generationSize);
                %This prevents duplicates of the top breeders
                if(index1>Evolver.generationSize-Evolver.topBreeders)
                    index2=Evolver.randomInt(1,Evolver.generationSize-Evolver.topBreeders);
                else
                    index2=Evolver.randomInt(1,Evolver.generationSize);
                end
                breeders(:,currentIndex)=[characters(index1);characters(index2)];
            end
            
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
                        actions(ii).speed = (breedingPair(1).actions(ii).speed+breedingPair(2).actions(ii).speed)/2;
                        actions(ii).time = (breedingPair(1).actions(ii).time+breedingPair(2).actions(ii).time)/2;
                    end
                    actions(1) = Move(0,2);
                    actions =ActionHandler.sortActions(actions);
                    offspring(i).actions=actions;
                end
                
            end
        end
    end
    
end

