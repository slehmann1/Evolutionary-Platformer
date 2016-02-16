classdef Move <Action
    %MOVE Move at a certain speed/time, extends Action
    %   Detailed explanation goes here
    properties(Constant)
        %the maximum speed allowed
        maxSpeed = 2;
    end

    
    methods
        function move=Move(time,speed)
            move.time=time;
            move.speed=speed;
        end
        function character = act(action,character)
            character.xSpeed =action.speed;
        end
    end
    
end

