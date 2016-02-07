classdef Evolver
    %EVOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        topBreeders=14;
        generationSize=100;
        %If this is true, then the best character will breed with itself
        kingOfTheHill=true;
    end
    
    methods (Static)
        %Start a new generation by evolving
        function characters = evolve(characters)
            
        end
        function breeders = selectBreedingPairs (characters)
            %Preallocate breeders
            breeders = [characters; characters];
            %The progress in assigning breedingPairs
            currentIndex=1;
            %Top breeders C 2
            %For example, if TopBreeders = 3, pairs: 1-2,1-3,2-3 number of
            %pairs = 3C2=3
            for outer=1:Evolver.topBreeders
                for inner = outer+1:Evolver.topBreeders
                    breeders(:,currentIndex) = [characters(inner); characters(outer)];
                    currentIndex=currentIndex+1;
                end
            end
            if(Evolver.kingOfTheHill)
                breeders(:,currentIndex)=[characters(1);characters(1)];
                currentIndex=currentIndex+1;
            end
            %Now fill the remaining slots with randoms
            %This for loop syntax makes me vomit
            for currentIndex=currentIndex:Evolver.generationSize
                index1 =round(rand(1)*Evolver.generationSize);
                %This prevents duplicates of the top breeders
                if(index1>Evolver.generationSize-Evolver.topBreeders)
                    index2=round(rand(1)*(Evolver.generationSize-Evolver.topBreeders));
                else
                    index2=round(rand(1)*(Evolver.generationSize));
                end
                breeders(:,currentIndex)=[characters(index1);characters(index2)];
            end
            
        end
    end
    
end

