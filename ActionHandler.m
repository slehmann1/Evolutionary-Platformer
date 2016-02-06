classdef ActionHandler
    %ACTIONHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    properties(Constant)
        maximumStartActions=15;
    end
    methods (Static)
        function  actions = randomizedActions()
            numberActions = ActionHandler.randomInt(1,ActionHandler.maximumStartActions);
            actions(1,numberActions) = Action();
            for i=1:numberActions
                actions(i)=ActionHandler.randomAction();
            end
        end
        function action = randomAction()
            %Unfortunately, Matlab doesn't seem to support generics, there
            %must be a better way to do this. Check Later
            actionType = ActionHandler.randomInt(1,2);
            time = ActionHandler.randomInt(0,Action.maxTime);
            switch actionType
                case 1
                    action=Jump(time,ActionHandler.randomInt(0,Jump.maxSpeed));
                case 2
                    action=Move(time,ActionHandler.randomInt(0,Move.maxSpeed));
                otherwise
                    disp('UNSUPPORTED ACTION');
            end
        end
        function int = randomInt(startInt,endInt)
            int = startInt+round(rand(1)*(endInt-startInt));
        end
        
    end
    
end

