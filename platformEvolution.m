classdef platformEvolution
    properties
        level;
        averageFitness;
        topFitness;
        generationCount;
        totalTime;
    end
    properties (Constant)
        lvlConfigDefault = {'100','0.2','0.5','5'};
        charConfigDefault = {'0.2','0.2','9.81','0.1','5'};
        evlvConfigDefault = {'10','2','0.4','0.7','0.1'};
        fitnessConfigDefault = {'1','1','5','20'};
        fitnessLineWidth=1.5;
        defaultSeed=321;
    end
    
    
    methods (Static)
        function obj= platformEvolution()
            clear;
            clc;
            close all;
            global SEED;
            SEED=platformEvolution.defaultSeed;
            tic;
            startMenu();
            
        end
        function obj= beginExecution(advancedSettings)
            obj.totalTime=0;
            global SEED;
            disp(['SEED:' num2str(SEED)]);
            %Set the seed generator's seed
            
            try 
                rng(SEED);
            catch issue
                %Non-numeric seed
                if (strcmp(issue.identifier,'MATLAB:rng:badSeed'))
                    errordlg('Please enter a numeric value');
                    error('Error. \nMATLAB:rng:badSeed');
                end
            end
                
                
            if advancedSettings
                platformEvolution.setDetailedSettings();
            else
                platformEvolution.setDefaultSettings();
            end
            global EVOLVERCONFIG;
            
            obj.level=Level();
            obj.generationCount=0;
            setupPlot(Character.maximumAllowedTime,obj.level,obj.generationCount,0);
            global AXES;
            axes(AXES(1));
            obj.level.drawLevel();
            
            characters(1,EVOLVERCONFIG.generationSize) = Character();
            obj.averageFitness=double.empty(2,0);
            obj.topFitness=double.empty(2,0);
            for i=1:EVOLVERCONFIG.generationSize
                m=ActionHandler.randomizedActions();
                characters(i) = Character(m,obj.level);
                characters(i)=characters(i).run();
                [characters(i).fitness, characters(i).undifferentiatedFitness]=characters(i).calculateFitness();
            end
            obj.generationCount=1;
            iterationTime = 0;
            global FIGUREWINDOW
            %Iterate more
            while ishandle(FIGUREWINDOW)
                tic
                [obj,characters]= platformEvolution.iterate(obj,characters,iterationTime);
                characters=Evolver.evolve(characters);
                iterationTime=toc;
                obj.totalTime=obj.totalTime+toc;
            end
            
            disp(['Generation Number: ' num2str(obj.generationCount)]);
            disp(['Total time: ' num2str(obj.totalTime) ' seconds']);
            
            
        end
        function drawGraph(characters,a,b,Color)
            for i=1:size(characters,2)
                path=line(characters(i).positions(a,:),characters(i).positions(b,:));
                path.Color=Color;
            end
        end
        function clearLinesFromAxes()
            axesHandlesToChildObjects = findobj(gca, 'Type', 'line');
            if ~isempty(axesHandlesToChildObjects)
                delete(axesHandlesToChildObjects);
            end
        end
        
        %Runs a generation
        function [platform_Evolution,characters] = iterate(platform_Evolution,characters,iterationTime)
            
            global EVOLVERCONFIG;
            global AXES;
            
            updatePlot(platform_Evolution.generationCount,iterationTime);
            
            num=0;
            %Do some basic caching
            for i=1:EVOLVERCONFIG.generationSize-1
                if characters(i)~=characters(end)
                    characters(i)=characters(i).run();
                    num=num+1;
                else
                    characters(i)=characters(end);
                end
                [characters(i).fitness, characters(i).undifferentiatedFitness]=characters(i).calculateFitness();
            end
            characters=sortByFitness(characters);
            
            
            
            axes(AXES(1));
            platformEvolution.clearLinesFromAxes();
            platform_Evolution.level.drawLevel();
            platformEvolution.drawGraph(characters,2,3,[0,0,0,0.5]);
            
            
            if platform_Evolution.generationCount~=1
                gen = generation(characters);
                fitnessSize = size(platform_Evolution.averageFitness,2);
                platform_Evolution.averageFitness( 1,fitnessSize+1) = gen.averageFitness;
                platform_Evolution.averageFitness( 2,fitnessSize+1) = fitnessSize+1;
                
                platform_Evolution.topFitness( 1,fitnessSize+1) = characters(end).undifferentiatedFitness;
                platform_Evolution.topFitness( 2,fitnessSize+1) = fitnessSize+1;
                
                axes(AXES(2));
                platformEvolution.clearLinesFromAxes();
                
                line(platform_Evolution.averageFitness(2,:),platform_Evolution.averageFitness(1,:),'Color',[1,0,0,0.5],'LineWidth',platformEvolution.fitnessLineWidth);
                line(platform_Evolution.topFitness(2,:),platform_Evolution.topFitness(1,:),'Color',[0,0,1,0.2],'LineWidth',platformEvolution.fitnessLineWidth);
                
                
            end
            
            axes(AXES(3));
            platformEvolution.clearLinesFromAxes();
            platformEvolution.drawGraph(characters,1,3,[0,0,0,0.5]);
            
            axes(AXES(4));
            platformEvolution.clearLinesFromAxes();
            platformEvolution.drawGraph(characters,1,2,[0,0,0,0.5]);
            drawnow();
            platform_Evolution.generationCount=platform_Evolution.generationCount+1;
        end
        
        %THE SETUP OF CONFIGURATIONS
        function setDefaultSettings()
            platformEvolution.setLEVELCONFIG(platformEvolution.lvlConfigDefault);
            platformEvolution.setCharacterConfig(platformEvolution.charConfigDefault);
            platformEvolution.setEVOLVERCONFIG(platformEvolution.evlvConfigDefault);
            platformEvolution.setFitnessConfig(platformEvolution.fitnessConfigDefault);
        end
        function setDetailedSettings()
            prompt={'Level length','Minimum stair height','Maximum stair height', 'Minimum stair spacing width'};
            name = 'Level configuration';
            platformEvolution.setLEVELCONFIG(inputdlg(prompt,name,1,platformEvolution.lvlConfigDefault));
            
            prompt={'Start speed','Air resistance','Gravity', 'Time interval', 'Maximum jump height'};
            name = 'Character configuration';
            platformEvolution.setCharacterConfig(inputdlg(prompt,name,1,platformEvolution.charConfigDefault));
            
            prompt={'Generation Size','Number of clones','Mutation rate', 'Add action rate', 'Remove action rate'};
            name = 'Evolver configuration';
            platformEvolution.setEVOLVERCONFIG(inputdlg(prompt,name,1,platformEvolution.evlvConfigDefault));
            
            prompt={'Distance weight','Time weight','Energy weight', 'Differentiation factor'};
            name = 'Fitness configuration';
            platformEvolution.setFitnessConfig(inputdlg(prompt,name,1,platformEvolution.fitnessConfigDefault));
        end
        
        function setLEVELCONFIG(levelCfg)
            global LEVELCONFIG;
            LEVELCONFIG=struct('maxXValues',str2double(levelCfg(1)));
            LEVELCONFIG.minStairHeight = str2double(levelCfg(2));
            LEVELCONFIG.maxStairHeight = str2double(levelCfg(3));
            LEVELCONFIG.maxStairWidth = str2double(levelCfg(4));
            
        end
        function levelCfg=getLEVELCONFIG()
            global LEVELCONFIG;
            levelCfg=LEVELCONFIG;
        end
        function setCharacterConfig(charCfg)
            global CHARCONFIG;
            CHARCONFIG=struct('startSpeed',str2double(charCfg(1)));
            CHARCONFIG.airResistance = str2double(charCfg(2));
            CHARCONFIG.gravity = str2double(charCfg(3));
            CHARCONFIG.timeInterval = str2double(charCfg(4));
            CHARCONFIG.maxJumpHeight= str2double(charCfg(5));
            
        end
        function charCfg=getCharacterConfig()
            global CHARCONFIG;
            charCfg=CHARCONFIG;
        end
        function setEVOLVERCONFIG(evlvCfg)
            global EVOLVERCONFIG;
            EVOLVERCONFIG=struct('generationSize',str2double(evlvCfg(1)));
            EVOLVERCONFIG.numberOfClones = str2double(evlvCfg(2));
            EVOLVERCONFIG.mutationRate = str2double(evlvCfg(3));
            EVOLVERCONFIG.addActionRate = str2double(evlvCfg(4));
            EVOLVERCONFIG.removeActionRate=str2double(evlvCfg(5));
        end
        function evlvCfg=getEVOLVERCONFIG()
            global EVOLVERCONFIG;
            evlvCfg=EVOLVERCONFIG;
        end
        function setFitnessConfig(fitCfg)
            global FITNESSCONFIG;
            FITNESSCONFIG=struct('distanceWeight',str2double(fitCfg(1)));
            FITNESSCONFIG.timeWeight = str2double(fitCfg(2));
            FITNESSCONFIG.energyWeight = str2double(fitCfg(3));
            FITNESSCONFIG.diffFactor = str2double(fitCfg(4));
        end
        function fitnCfg=getFitnessConfig()
            global FITNESSCONFIG;
            fitnCfg=FITNESSCONFIG;
        end
    end
end
