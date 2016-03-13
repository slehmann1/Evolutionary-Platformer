classdef Character
    %CHARACTER The actual Character
    %   Detailed explanation goes here
    properties(Constant)
        % The height of the character, the character has been on a diet and
        % thus it is asssumed that it has no width
        height =0;
        %The maximum amount of time a character is allowed in seconds
        maximumAllowedTime=55;
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
        undifferentiatedFitness;
        %The action point where the character died
        deathActionIndex=-1;
        
        %The sum of all of the forces applied, relates to energy
        %expenditure. Could also do it properly measuring the total
        %altitude gains and using mgh to get energy expenditure, but i'm
        %lazy
        totalForce=0;
    end
    
    methods
        
        function character = Character(actions,level)
            global CHARCONFIG;
            if nargin >0
                character.actions = actions;
                character.level=level;
                
                %Initialize the positions
                character.positions = [0:CHARCONFIG.timeInterval:character.maximumAllowedTime; ...
                    0:CHARCONFIG.timeInterval:character.maximumAllowedTime;...
                    0:CHARCONFIG.timeInterval:character.maximumAllowedTime;];
                character.positions(2,:)=0;
                character.positions(3,:)=character.height/2;
            end
        end
        function character=run(character)
            global LEVELCONFIG CHARCONFIG;
            %Starts Grounded
            isGrounded=true;
            character.totalForce=0;
            character.xSpeed=0;
            character.ySpeed=0;
            character.currentIndex=0;
            character.positions = [0:CHARCONFIG.timeInterval:character.maximumAllowedTime; ...
                0:CHARCONFIG.timeInterval:character.maximumAllowedTime;...
                0:CHARCONFIG.timeInterval:character.maximumAllowedTime;];
            character.positions(2,:)=0;
            character.positions(3,:)=character.height/2;
            actionsIndex=1;
            
            %Loop through each position
            dimensions = size(character.positions);
            %start at 2 so that the first is the starting point
            index=2;
            character.currentIndex=index;
            %Cache this to prevent computing repeatedly
            actionsLength = size(character.actions,2);
            while index<=dimensions(2)
                
                character.currentIndex=index;
                
                if (actionsIndex<=actionsLength && (character.positions(1,index) > character.actions(actionsIndex).time))
                    %the action should be performed
                    character=character.actions(actionsIndex).act(character);
                    actionsIndex=actionsIndex+1;
                end
                
                
                %Update Y location
                character.positions(3,index) = character.positions(3,index-1)+(character.ySpeed*CHARCONFIG.timeInterval);
                if isGrounded
                    %Update X location
                    character.positions(2,index) = character.positions(2,index-1)+(character.xSpeed*CHARCONFIG.timeInterval);
                else
                    character.positions(2,index) = character.positions(2,index-1)+(character.xSpeed*(1-CHARCONFIG.airResistance)*CHARCONFIG.timeInterval);
                end
                if(character.positions(2,index)>=LEVELCONFIG.maxXValues)
                    %The character has reached the end of the level
                    Evolver.unsolved=false;
                    %set distance and time
                    distance = character.positions(2,index);
                    time=character.positions(1,index);
                    character.maxDistance =distance;
                    character.maxTime=time;
                    %set all unevaluated positions to the final position
                    character.positions(2,index:end)=character.positions(2,index);
                    character.positions(3,index:end)=character.positions(3,index);
                    return;
                end
                %check whether or not the character will die
                if(willCrash(character,LEVELCONFIG.maxStairWidth,character.positions(2,index),character.positions(3,index-1),character.positions(3,index)))
                    %HAS DIED
                    %set distance and time
                    distance = character.positions(2,index);
                    time=character.positions(1,index);
                    character.maxDistance =distance;
                    character.maxTime=time;
                    %set all unevaluated positions to the final position
                    character.positions(2,index:end)=character.positions(2,index);
                    character.positions(3,index:end)=character.positions(3,index);
                    character.deathActionIndex=actionsIndex;
                    return;
                end
                isGrounded = isGroundedNoPos(character,LEVELCONFIG.maxStairWidth);
                if(~isGrounded)
                    character.ySpeed=character.ySpeed-(CHARCONFIG.gravity*CHARCONFIG.timeInterval);
                elseif character.ySpeed<0
                    character.ySpeed=0;
                    %set to ground height
                    character.positions(3,index) = character.level.getY(LEVELCONFIG.maxStairWidth,character.positions(2,index))+character.height/2;
                end
                
                index=index+1;
            end
            
            %set distance and time
            distance = character.positions(2,index-1);
            time=character.positions(1,index-1);
            character.maxDistance =distance;
            character.maxTime=time;
        end
        
        function grounded=isGrounded(character,maxStairWidth,xPos,yPos)
            if(character.level.getY(maxStairWidth,xPos)==(yPos-character.height))
                grounded=1;
                return;
            end
            grounded=0;
        end
        %For some raisin, Matlab doesn't support overloading... It better
        %be a really good raisin.
        function grounded=isGroundedNoPos(character,maxStairWidth)
            if(character.level.getY(maxStairWidth,character.positions(2,character.currentIndex))-(character.positions(3,character.currentIndex)-character.height/2))>=-character.fudgeFactor
                grounded=1;
                return;
            end
            grounded=0;
        end
        function willDie = willCrash(character,maxStairWidth, xPos,oldY,newY)
            lvlHeight = character.level.getY(maxStairWidth,xPos);
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
        function [fitness,undifferentiatedFitness] = calculateFitness(character)
            global FITNESSCONFIG;
            undifferentiatedFitness = character.maxDistance*FITNESSCONFIG.distanceWeight+ ((character.maximumAllowedTime-character.maxTime)*FITNESSCONFIG.timeWeight)...
                -character.totalForce/20*FITNESSCONFIG.energyWeight;
            fitness=undifferentiatedFitness^FITNESSCONFIG.diffFactor;
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




