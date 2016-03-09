classdef platformEvolution
    properties
        level;
        averageFitness;
        topXAverageFitness;
        topFitness;
        generationCount;
    end
    properties (Constant)
        lvlConfigDefault = {'100','0.2','0.5','5'};
        charConfigDefault = {'0.2','0.2','9.81','0.1','5'};
        evlvConfigDefault = {'15','1','0.2','0.6','0.1'};
        fitnessConfigDefault = {'1','1','1','2'};
    end
    
    
    methods (Static)
        function obj= platfodrmEvolution()
            clear;
            clc;
            close all;
            global SEED;
            SEED= 123456;
            tic;
            platformEvolution.beginExecution(0);
            startMenu();
            
        end
        function obj= platformEvolution()
            advancedSettings=0;
            global SEED;
            disp(['SEED:' num2str(SEED)]);
            %Set the seed generator's seed
            rng(SEED);
            if advancedSettings
                platformEvolution.setDetailedSettings();
            else
                platformEvolution.setDefaultSettings();
            end
            global evolverConfig;
            
            obj.level=Level();
            obj.generationCount=0;
            setupPlot(Character.maximumAllowedTime,obj.level,obj.generationCount,0);
            subplot(2,1,1);
            hold on;
            obj.level.drawLevel();
            
            characters(1,evolverConfig.generationSize) = Character();
            obj.averageFitness=double.empty(2,0);
            obj.topXAverageFitness=double.empty(2,0);
            obj.topFitness=double.empty(2,0);
            for i=1:evolverConfig.generationSize
                m=ActionHandler.randomizedActions();
                characters(i) = Character(m,obj.level);
                characters(i)=characters(i).run();
                characters(i).fitness=characters(i).calculateFitness();
            end
            obj.generationCount=1;
            iterationTime = 0;
            %Iterate more
            for i=1:100000
                tic
                [obj,characters]= platformEvolution.iterate(obj,characters,iterationTime);
                characters=Evolver.evolve(characters);
                iterationTime=toc;
            end
            
            
            toc
            disp(toc);
            
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
                global evolverConfig;
                %It is considerably slower to do this every iteration, but
                %it is important to do every so often to prevent buildup,
                %gotta love matlab's blistering speed
                if mod(platform_Evolution.generationCount,50)==0
                    clf;
                    setupPlot(Character.maximumAllowedTime,platform_Evolution.level,platform_Evolution.generationCount,iterationTime);
                end
                updatePlot(platform_Evolution.level,platform_Evolution.generationCount,iterationTime);
                %setupPlot(Character.maximumAllowedTime,platform_Evolution.level,platform_Evolution.generationCount,iterationTime);
                
                for i=1:evolverConfig.generationSize
                    characters(i)=characters(i).run();
                    characters(i).fitness=characters(i).calculateFitness();
                end
                characters=sortByFitness(characters);
                gen = generation(characters,10);
                platform_Evolution.averageFitness( 1,size(platform_Evolution.averageFitness,2)+1) = gen.averageFitness;
                platform_Evolution.averageFitness( 2,size(platform_Evolution.averageFitness,2)) = size(platform_Evolution.averageFitness,2);
                platform_Evolution.topXAverageFitness( 1,size(platform_Evolution.topXAverageFitness,2)+1) = gen.topXAverageFitness;
                platform_Evolution.topXAverageFitness( 2,size(platform_Evolution.topXAverageFitness,2)) = size(platform_Evolution.topXAverageFitness,2);
                platform_Evolution.topFitness( 1,size(platform_Evolution.topFitness,2)+1) = characters(end).fitness;
                platform_Evolution.topFitness( 2,size(platform_Evolution.topFitness,2)) = size(platform_Evolution.topFitness,2);
     
                subplot(2,2,1);
                platformEvolution.clearLinesFromAxes();
                hold on;
                platform_Evolution.level.drawLevel();
                platformEvolution.drawGraph(characters,2,3,[0,0,0,0.5]);
                
                subplot(2,2,2);
                platformEvolution.clearLinesFromAxes();
                line(platform_Evolution.averageFitness(2,:),platform_Evolution.averageFitness(1,:));
                line(platform_Evolution.topXAverageFitness(2,:),platform_Evolution.topXAverageFitness(1,:));
                line(platform_Evolution.topFitness(2,:),platform_Evolution.topFitness(1,:));
                
                subplot(2,2,3);
                platformEvolution.clearLinesFromAxes();
                platformEvolution.drawGraph(characters,1,3,[0,0,0,0.5]);
                
                subplot(2,2,4);
                platformEvolution.clearLinesFromAxes();
                platformEvolution.drawGraph(characters,1,2,[0,0,0,0.5]);
                drawnow();
                platform_Evolution.generationCount=platform_Evolution.generationCount+1;
            end
            
            %THE SETUP OF CONFIGURATIONS
            function setDefaultSettings()
                platformEvolution.setLevelConfig(platformEvolution.lvlConfigDefault);
                platformEvolution.setCharacterConfig(platformEvolution.charConfigDefault);
                platformEvolution.setEvolverConfig(platformEvolution.evlvConfigDefault);
                platformEvolution.setFitnessConfig(platformEvolution.fitnessConfigDefault);
            end
            function setDetailedSettings()
                prompt={'Level length','Minimum stair height','Maximum stair height', 'Minimum stair spacing width'};
                name = 'Level configuration';
                platformEvolution.setLevelConfig(inputdlg(prompt,name,1,platformEvolution.lvlConfigDefault));
                
                prompt={'Start speed','Air resistance','Gravity', 'Time interval', 'Maximum jump height'};
                name = 'Character configuration';
                platformEvolution.setCharacterConfig(inputdlg(prompt,name,1,platformEvolution.charConfigDefault));
                
                prompt={'Generation Size','Number of clones','Mutation rate', 'Add action rate', 'Remove action rate'};
                name = 'Evolver configuration';
                platformEvolution.setEvolverConfig(inputdlg(prompt,name,1,platformEvolution.evlvConfigDefault));
                
                prompt={'Distance weight','Time weight','Energy weight', 'Differentiation factor'};
                name = 'Fitness configuration';
                platformEvolution.setFitnessConfig(inputdlg(prompt,name,1,platformEvolution.fitnessConfigDefault));
            end
            
            function setLevelConfig(levelCfg)
                global levelConfig;
                levelConfig=struct('maxXValues',str2double(levelCfg(1)));
                levelConfig.minStairHeight = str2double(levelCfg(2));
                levelConfig.maxStairHeight = str2double(levelCfg(3));
                levelConfig.maxStairWidth = str2double(levelCfg(4));
                
            end
            function levelCfg=getLevelConfig()
                global levelConfig;
                levelCfg=levelConfig;
            end
            function setCharacterConfig(charCfg)
                global charConfig;
                charConfig=struct('startSpeed',str2double(charCfg(1)));
                charConfig.airResistance = str2double(charCfg(2));
                charConfig.gravity = str2double(charCfg(3));
                charConfig.timeInterval = str2double(charCfg(4));
                charConfig.maxJumpHeight= str2double(charCfg(5));
                
            end
            function charCfg=getCharacterConfig()
                global charConfig;
                charCfg=charConfig;
            end
            function setEvolverConfig(evlvCfg)
                global evolverConfig;
                evolverConfig=struct('generationSize',str2double(evlvCfg(1)));
                evolverConfig.numberOfClones = str2double(evlvCfg(2));
                evolverConfig.mutationRate = str2double(evlvCfg(3));
                evolverConfig.addActionRate = str2double(evlvCfg(4));
                evolverConfig.removeActionRate=str2double(evlvCfg(5));
            end
            function evlvCfg=getEvolverConfig()
                global evolverConfig;
                evlvCfg=evolverConfig;
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
