%%#######################################################################
% #######################################################################
% ###                                                                 ###
% ###    _____ _____ ____  __  __ _____ _   __  __ _____              ###
% ###   |  ___|  _  | __ \|  \/  |  ___| |  \ \/ /|_   _|             ###
% ###   |  __|| |_| | `/ /| \  / |  __|| |__ \  /   | |               ###
% ###   |_|   |_____|_|\_\|_|\/|_|_|   |____|/_/    |_|               ###
% ###                                                                 ###
% ### Project FORMFLYT: Directional Cosine Matrices Toolbox           ###
% ### Rotation by direction cosine matrix along the second (Y) axis.  ###
% ###                                                                 ###
% ### By Samuel Low (08-JUL-2021), DSO National Laboratories          ###
% ###                                                                 ###
% #######################################################################
% #######################################################################

function [dcm] = dcm_rotate_y(theta)

% Input theta is the scalar angle (degrees) to be rotated about the axis.
% Output is a 3x3 direction cosine matrix.
dcm = [ cosd(theta)   0.0   -1*sind(theta) ;
        0.0           1.0   0.0            ;
        sind(theta)   0.0   cosd(theta)    ];
end