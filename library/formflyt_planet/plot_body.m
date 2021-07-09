%%#######################################################################
% #######################################################################
% ###                                                                 ###
% ###  @@@@@@@@ @@@@@@@ @@@@@@@ @@@@@ @@@@@@@@@ @@@    @@@ @@@@@@@@   ###
% ###  @@@@@@@@ @@@@@@@ @@@@@@@ @@@@@ @@    (@@ @@@    @@@ @@@  @@@   ###
% ###  @@    @@   @@@     @@@    @@@  @@    (@@ @@@    @@@ @@@@@@@@@  ###
% ###  @@@@@@@@   @@@     @@@    @@@  @@@@@@@@@ @@@    @@@ @@@@@@@@@  ###
% ###  @@    @@   @@@     @@@   @@@@@ @@@@@@@@@ @@@@@@@@@@ @@@   @@@  ###
% ###  @@    @@   @@@     @@@   @@@@@     (@@@  @@@@@@@@@@ @@@@@@@@@  ###
% ###                                                                 ###
% ### Project ATTIQUB: Plotting Planetary Bodies Toolbox              ###
% ### Calls the appropriate central body plot, based on user input    ###
% ###                                                                 ###
% ### Adapted by Samuel Low (06-01-2021), DSO National Laboratories   ###
% ###                                                                 ###
% #######################################################################
% #######################################################################

function plot_body( body )

% This is the main function that calls all other body plots in the folder.
% Plot the central gravitational bodies, based on user input variable.
% | 1 - Earth | 2 - Moon | 3 - Mars | 4 - Venus | 5 - Mercury |

if body == 1
    bodyplot_earth();
elseif body == 2
    bodyplot_moon();
elseif body == 3
    bodyplot_mars();
elseif body == 4
    bodyplot_venus();
elseif body == 5
    bodyplot_mercury();
end

end
