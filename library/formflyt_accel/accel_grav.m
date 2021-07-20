%%#######################################################################
% #######################################################################
% ###                                                                 ###
% ###    _____ _____ ____  __  __ _____ _   __  __ _____              ###
% ###   |  ___|  _  | __ \|  \/  |  ___| |  \ \/ /|_   _|             ###
% ###   |  __|| |_| | `/ /| \  / |  __|| |__ \  /   | |               ###
% ###   |_|   |_____|_|\_\|_|\/|_|_|   |____|/_/    |_|               ###
% ###                                                                 ###
% ### Project FORMFLYT: Forces Toolbox                                ###
% ### Computation of inverse square gravity force (two-body).         ###
% ###                                                                 ###
% ### By Matthew Lo and Samuel Low (12-JUL-2021), DSO NL              ###
% ###                                                                 ###
% #######################################################################
% #######################################################################

function [acc_invsq_gravity] = accel_grav( pos )

% Input: Position vector (1x3) of the spacecraft
% Output: Acceleration vector (1x3) of the spacecraft due to gravity.

GM = 3.9860e+14; % Units in m^3 kg^-1 s^-2 
acc_invsq_gravity = ( -1 * GM * pos ) / ( norm( pos ) ^ 3 );

end