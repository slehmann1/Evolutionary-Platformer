clear;
clc;

generationSize=100;


tic;
clf;
setupPlot();
subplot(2,1,1);
level=Level();
characters(1,generationSize) = Character();
for i=1:generationSize
    m=[Move(0.1,1), Jump(1,10),  Jump(10,10), Move(30,2), Jump(35,10)];
    characters(i) = Character(m,level);
    characters(i)=characters(i).run();
    characters(i).fitness=characters(i).calculateFitness(1,1,1);
end
characters=sortByFitness(characters);

toc
disp(toc);
