clear;
tic;
clc;
clf;
setupPlot();
subplot(2,1,1);
level=Level();
for i=1:10
    m=[Move(0.1,1), Jump(1,10),  Jump(10,10), Move(30,2), Jump(35,10)];
    c = Character(m,level);
    c.run();
end
toc
disp(toc);