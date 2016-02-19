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
    end
end

