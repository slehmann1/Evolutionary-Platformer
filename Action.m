classdef Action <matlab.mixin.Heterogeneous
    %ACTION The superclass for all actions that may occur (jump, move...)
    %   Detailed explanation goes here
    properties
        %The time at which the action occurs
        time;
        speed;
    end
    methods
        %perform the action
        act(character);
        function action = Action()
        end
        %compares two actions by actions (~= operator)
        function compare = ne(a,b)
            compare=1;
            if a.time~=b.time
                return
            end
            if a.speed~=b.speed
                return
            end
            compare=0;
        end
    end
end

