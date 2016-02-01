classdef (Abstract) Action <matlab.mixin.Heterogeneous
    %ACTION The superclass for all actions that may occur (jump, move...)
    %   Detailed explanation goes here
    
    properties
        %The time at which the action occurs
        time;
    end   
    methods (Abstract)
        %perform the action
        act(character);
    end
end

