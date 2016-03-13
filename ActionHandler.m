classdef ActionHandler
    %ACTIONHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    properties(Constant)
        maximumStartActions=2;
        
        %Matlab doesn't seem to support overriding of properties, which is
        %absolutely infuriating
        moveProbability=0;
    end
    methods (Static)
        function  actions = randomizedActions()
            global CHARCONFIG;
            numberActions = ActionHandler.randomInt(1,ActionHandler.maximumStartActions);
            actions(1,numberActions) = Action();
            actions(1) = Move(0,CHARCONFIG.startSpeed);
            for i=2:numberActions
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
        %A random action, time limited by the length of the characters
        %lifespan
        function action = randomActionWithTime(character)
            %Unfortunately, Matlab doesn't seem to support generics, there
            %must be a better way to do this. Check Later
            actionType = rand();
            time = rand(1)*Character.maximumAllowedTime;
            if(actionType<ActionHandler.moveProbability)
                action=Move(time,rand(1)*Move.maxSpeed);
            else
                action=Jump(time,rand(1)*(Jump.maxSpeed-Jump.minSpeed)+Jump.minSpeed);
            end  
        end
        %A random action, with no time limitations
        function action = randomAction()
            global CHARCONFIG;
            %Unfortunately, Matlab doesn't seem to support generics, there
            %must be a better way to do this. Check Later
            actionType = rand();
            time = rand(1)*Character.maximumAllowedTime;
            if(actionType<ActionHandler.moveProbability)
                action=Move(time,rand(1)*Move.maxSpeed);
            else
                action=Jump(time,rand(1)*(CHARCONFIG.maxJumpHeight-Jump.minSpeed)+Jump.minSpeed);
            end  
        end
        %Mutates an individual aciton
        function action = mutateAction(initialAction)
            global CHARCONFIG;
            time = initialAction.time;
            speed= initialAction.speed;
            %Mutate time
            if rand()>0.5
                time = rand(1)*Character.maximumAllowedTime;
            %Position
            else
                speed = rand(1)*(CHARCONFIG.maxJumpHeight-Jump.minSpeed)+Jump.minSpeed;
            end
            action = initialAction;
            action.time=time;
            action.speed=speed;
            
        end
        function int = randomInt(startInt,endInt)
            int = startInt+round(rand(1)*(endInt-startInt));
        end
        
    end
    
end

