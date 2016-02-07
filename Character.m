classdef Character
    %CHARACTER The actual Character
    %   Detailed explanation goes here
    properties(Constant)
        % The height of the character, the character has been on a diet and
        % thus it is asssumed that it has no width
        height =0;
        %The maximum amount of time a character is allowed in seconds
        maximumAllowedTime=60;
        %The difference in times for each calculated position (seconds)
        timeInterval =0.1;
        %the acceleration in gravity in m/s^2
        gravity=9.81;
        %Helps account for imprecision
        fudgeFactor=0.2;
    end
    properties
        
        %all of the actions that the character performs
        actions;
        %The Level, useful for deadedness
        level;
        %Row 1 = time, row 2 = x, row 3 = y
        positions;
        xSpeed=0;
        ySpeed=0;
        %the location where the position is being evaluated
        currentIndex;
        maxDistance;
        maxTime;
        fitness;
    end
    
    methods
        
        function character = Character(actions,level)
            if nargin >0
                character.actions = actions;
                character.level=level;
                
                %Initialize the positions
                character.positions = [0:character.timeInterval:character.maximumAllowedTime; ...
                    0:character.timeInterval:character.maximumAllowedTime;...
                    0:character.timeInterval:character.maximumAllowedTime;];
                character.positions(2,:)=0;
                character.positions(3,:)=character.height/2;
            end
        end
        function character=run(character)
            
            actionsIndex=1;
            
            
            
            %Loop through each position
            dimensions = size(character.positions);
            %start at 2 so that the first is the starting point
            index=2;
            
            while index<=dimensions(2)
                character.currentIndex=index;
                if (actionsIndex<=size(character.actions,2)) & (character.positions(1,index) > character.actions(actionsIndex).time)
                    %the action should be performed
                    character=character.actions(actionsIndex).act(character);
                    actionsIndex=actionsIndex+1;
                end
                
                
                
                
                %Update x and y locations
                character.positions(2,index) = (character.positions(2,index-1)+(character.xSpeed*character.timeInterval));
                character.positions(3,index) = character.positions(3,index-1)+(character.ySpeed*character.timeInterval);
                %check whether or not the character will die
                if(willCrash(character,character.positions(2,index),character.positions(3,index-1),character.positions(3,index)))
                    %set distance and time, draw the graph and return
                    distance = character.positions(2,index);
                    time=character.positions(1,index);
                    character.maxDistance =distance;
                    character.maxTime=time;
                    %set all unevaluated positions to the final position
                    character.positions(2,index:end)=character.positions(2,index);
                    character.positions(3,index:end)=character.positions(3,index);
                    
                    character.draw();
                    return;
                end
                
                if(~isGroundedNoPos(character))
                    character.ySpeed=character.ySpeed-(character.gravity*character.timeInterval);
                elseif character.ySpeed<0
                    character.ySpeed=0;
                    %set to ground height
                    character.positions(3,index) = character.level.getY(character.positions(2,index))+character.height/2;
                end
                
                index=index+1;
            end
            %set distance and time, draw the graph and return
            distance = character.positions(2,index-1);
            time=character.positions(1,index-1);
            character.maxDistance =distance;
            character.maxTime=time;
            character.draw();
        end
        
        %draws the character's path
        function [] = draw(character)
            
            subplot(2,1,1);
            path=line(character.positions(2,:),character.positions(3,:));
            path.Color=[0,0,0,0.5];
            
            
            subplot(2,2,3);
            path=line(character.positions(1,:),character.positions(3,:));
            path.Color=[0,0,0,0.5];
            
            subplot(2,2,4);
            path=line(character.positions(1,:),character.positions(2,:));
            path.Color=[0,0,0,0.5];
        end
        
        function grounded=isGrounded(character,xPos,yPos)
            if(character.level.getY(xPos)==(yPos-character.height))
                grounded=1;
                return;
            end
            grounded=0;
        end
        %For some raisin, Matlab doesn't support overloading... It better
        %be a really good raisin.
        function grounded=isGroundedNoPos(character)
            if(character.level.getY(character.positions(2,character.currentIndex))-(character.positions(3,character.currentIndex)-character.height/2))>=-character.fudgeFactor
                grounded=1;
                return;
            end
            grounded=0;
        end
        function willDie = willCrash(character, xPos,oldY,newY)
            lvlHeight = character.level.getY(xPos);
            if(lvlHeight<=(newY-character.height/2+character.fudgeFactor))
                willDie=0;
                return;
            end
            if(lvlHeight<=(oldY-character.height/2+character.fudgeFactor))
                willDie=0;
                return;
            end
            willDie=1;
        end
        %Returns the evolutionary fitness, takes in the relative weighting
        %of factors
        function fitness = calculateFitness(character,distanceWeight,timeWeight,actionWeight)
            fitness = character.maxDistance*distanceWeight-character.maxTime*timeWeight;
            -size(character.actions,2)*actionWeight;
        end
        %compares two characters by fitness (<= operator)
        function compare = le(a,b)
            if a.fitness<=b.fitness
                compare =1;
                return;
            end
            compare = 0;
        end
        %compares two characters by fitness (>= operator)
        function compare = ge(a,b)
            if a.fitness>=b.fitness
                compare =1;
                return;
            end
            compare = 0;
        end
        %compares two characters by fitness (< operator)
        function compare = lt(a,b)
            if a.fitness<b.fitness
                compare =1;
                return;
            end
            compare = 0;
        end
        %compares two characters by fitness (> operator)
        function compare = gt(a,b)
            if a.fitness>b.fitness
                compare =1;
                return;
            end
            compare = 0;
        end
        
        %compares two characters by fitness (== operator)
        function compare = eq(a,b)
            if a.fitness==b.fitness
                compare =1;
                return;
            end
            compare = 0;
        end
    end
end




