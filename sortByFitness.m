%Sorts the characters by fitness values from lowest to highest fitness,
%using the quicksort algorithm
function sortedCharacters = sortByFitness(characters)
    if numel(characters) <= 1 %If the characters has 1 element     
        sortedCharacters = characters;
        return
    end
 
    %Determine Pivot
    pivot = characters(end);
    characters(end) = [];
 

    lessOrEqual = getlessOrEqual(characters,pivot);
    greater = getGreater(characters,pivot);
 
    %Do recursiveness
    sortedCharacters = [sortByFitness(lessOrEqual) pivot sortByFitness(greater)];
 
end
%Returns the elements that are greater than the pivot
function greater = getGreater(characters, pivot)
greater = Character.empty();
    for i=1:size(characters,2)
        if(characters(i)>pivot)
            greater(end+1)=characters(i);
        end
    end
    
end
%Returns the elements that are less than/equal to the pivot
function lessOrEqual = getlessOrEqual(characters, pivot)
lessOrEqual = Character.empty();
    for i=1:size(characters,2)
        if(characters(i)<=pivot)
            lessOrEqual(end+1)=characters(i);
        end
    end
end