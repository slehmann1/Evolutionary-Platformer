function [] = setupPlot()
%SETUPPLOT This sets up the plots
%   Detailed explanation goes here
    subplot(2,1,1);
    title('Y vs X');
    xlabel('X (meters)')
    ylabel('Y (meters)')

    subplot(2,2,3);
    title('Y vs time');
    xlabel('Time (seconds)')
    ylabel('Y (meters)')

    subplot(2,2,4);
    title('X vs time');
    xlabel('Time (seconds)')
    ylabel('X (meters)')
            

end

