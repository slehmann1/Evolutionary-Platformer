classdef Jump <Action
    %JUMP Jump at a certain speed/time, extends Action
    %   Detailed explanation goes here
    properties(Constant)
        %the maximum speed allowed
        minSpeed = 1;
    end
    
    
    methods
        function jump=Jump(time,speed)
            jump.time=time;
            jump.speed=speed;
        end
        function character = act(action,character)
            
            character.ySpeed =action.speed;
            character.totalForce = character.totalForce+action.speed;
            
        end
    end
    
end

