classdef ActionHandler
    %ACTIONHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    properties(Constant)
        maximumStartActions=5;
    end
    methods (Static)
        function  actions = randomizedActions()
            numberActions = ActionHandler.randomInt(1,ActionHandler.maximumStartActions);
            actions(1,numberActions) = Action();
            for i=1:numberActions
                actions(i)=ActionHandler.randomAction();
            end
            actions=ActionHandler.sortActions(actions);
        end
        %Sorts the characters by fitness values from lowest to highest fitness,
        %using the quicksort algorithm
        function sortedActions = sortActions(actions)
            if numel(actions) <= 1 %If the characters has 1 element
                sortedActions = actions;
                return
            end
            
            %Determine Pivot
            pivot = actions(end);
            actions(end) = [];
            
            
            lessOrEqual = ActionHandler.getlessOrEqual(actions,pivot);
            greater = ActionHandler.getGreater(actions,pivot);
            
            %Do recursiveness
            sortedActions = [ActionHandler.sortActions(lessOrEqual) pivot ActionHandler.sortActions(greater)];
            
        end
        %Returns the elements that are greater than the pivot
        function greater = getGreater(actions, pivot)
            greater = Action.empty();
            for i=1:size(actions,2)
                if(actions(i).time>pivot.time)
                    greater(end+1)=actions(i);
                end
            end
            
        end
        %Returns the elements that are less than/equal to the pivot
        function lessOrEqual = getlessOrEqual(actions, pivot)
            lessOrEqual = Action.empty();
            for i=1:size(actions,2)
                if(actions(i).time<=pivot.time)
                    lessOrEqual(end+1)=actions(i);
                end
            end
        end
        function action = randomAction()
            %Unfortunately, Matlab doesn't seem to support generics, there
            %must be a better way to do this. Check Later
            actionType = ActionHandler.randomInt(1,2);
            time = rand(1)*Action.maxTime;
            switch actionType
                case 1
                    action=Jump(time,rand(1)*Jump.maxSpeed);
                case 2
                    action=Move(time,rand(1)*Move.maxSpeed);
                otherwise
                    disp('UNSUPPORTED ACTION');
            end
        end
        function int = randomInt(startInt,endInt)
            int = startInt+round(rand(1)*(endInt-startInt));
        end
        
    end
    
end

