classdef Jump <Action
    %JUMP Jump at a certain speed/time, extends Action
    %   Detailed explanation goes here
    properties(Constant)
        %the maximum speed allowed
        maxSpeed = 5;
        minSpeed = 3;
    end

    
    methods
        function jump=Jump(time,speed)
            jump.time=time;
            jump.speed=speed;
        end
        function character = act(action,character)
            if(character.isGroundedNoPos())
                character.ySpeed =action.speed;
            end
        end
    end
    
end

