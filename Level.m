
classdef Level 
    %Level Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %impacts the vertical stretch
        bufferValue=1;
        %the number of x values
        maxXValues=100;
        %the spacing horizontally of the stairs
        stairSpacing=2;
        %minimum difference between stair heights
        minStairDiff=0.5;
        %maximum difference between stair heights
        maxStairDiff=1;
        x;
        y;
    end
    
    methods    
            
        %constructor
        function level=Level()
            %generate x values
            level.x=0:level.stairSpacing:level.maxXValues;
            level.y(1)=0;
            
            minValue =0;
            maxValue=0;
            %generate y values
            for i=2:numel(level.x)
                %compute the difference in stair height
                level.y(i)=(rand()-0.5)*2*level.maxStairDiff;
                %check whether the distance is large enough
                if(abs(level.y(i))>level.minStairDiff)
                    level.y(i) = level.y(i-1)+level.y(i);                
                else
                    level.y(i) = level.y(i-1);
                end
                %update the maximum and minimum values
               if(level.y(i))<minValue
                   minValue = level.y(i);
               elseif(level.y(i)>maxValue)
                   maxValue=level.y(i);
               end
            end
            %display the level
            stairs(level.x,level.y);
            %setup the axes
            minValue = minValue - (maxValue-minValue)*level.bufferValue;
            maxValue = maxValue + (maxValue-minValue)*level.bufferValue;
            axis([level.x(1) level.x(end) minValue maxValue]);
        end
        %Returns the y value at a specific x
        function y=getY(level,xpos)
            %convert to int
            xpos=floor(xpos);
            %because x starts at 0
            xpos=xpos+level.stairSpacing;
            %if remainder
            if(mod(xpos,level.stairSpacing)~=0)
                xpos=xpos-mod(xpos,level.stairSpacing);
            end
            y=level.y(xpos/level.stairSpacing);
        end
         
    end
    
end

