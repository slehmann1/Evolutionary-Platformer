classdef Level
    %Level Summary of this class goes here
    %   Detailed explanation goes here
    
    
    properties (Constant)
        
        %impacts the vertical stretch
        bufferValue=1;
    end
    properties
        %The maximum/minimum chart axis values
        maxAxisValue;
        minAxisValue;
        
        x;
        y;
    end
    
    methods
        
        %constructor
        function level=Level()
            global LEVELCONFIG;
            %generate x values
            level.x=0:LEVELCONFIG.maxStairWidth:LEVELCONFIG.maxXValues;
            level.y(1)=0;
            
            minAxisValue =0;
            maxAxisValue=0;
            %generate y values
            for i=2:numel(level.x)
                %compute the difference in stair height
                level.y(i)=(rand()-0.5)*2*LEVELCONFIG.maxStairHeight;
                %check whether the distance is large enough
                if(abs(level.y(i))>LEVELCONFIG.minStairHeight)
                    level.y(i) = level.y(i-1)+level.y(i);
                else
                    level.y(i) = level.y(i-1);
                end
                %update the maximum and minimum values
                if(level.y(i))<minAxisValue
                    minAxisValue = level.y(i);
                elseif(level.y(i)>maxAxisValue)
                    maxAxisValue=level.y(i);
                end
            end
            
            %setup the axes
            level.minAxisValue = minAxisValue - (maxAxisValue-minAxisValue)*level.bufferValue;
            level.maxAxisValue = maxAxisValue + (maxAxisValue-minAxisValue)*level.bufferValue;
        end
        %Displays the Level
        function drawLevel(level)
            %display the level
            [xb,yb]=stairs(level.x,level.y);
            line(xb,yb);
        end
        %Returns the y value at a specific x
        function y=getY(level,maxStairWidth,xpos)
            %convert to int
            xpos=floor(xpos);
            %because x starts at 0
            xpos=xpos+maxStairWidth;
            %if remainder
            if(mod(xpos,maxStairWidth)~=0)
                xpos=xpos-mod(xpos,maxStairWidth);
            end
            y=level.y(xpos/maxStairWidth);
        end
        
    end
    
end

