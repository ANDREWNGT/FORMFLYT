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

function [acc_oblateness] = force_oblate( pos )

% Input: Position vector (1x3) of the spacecraft in ECI
% Output: Acceleration vector (1x3) of the spacecraft due to gravity.

GM = 3.9860e+14; % Units in m^3 kg^-1 s^-2 
J2 = 1.0826267e-3; % Earth oblateness factor
r5 = norm( pos )^5;
r2 = norm( pos )^2;
tmp = (p(3)^2)/r2;

% Acceleration vector due to gradient of J2 term.
oblate_x = 1.5 * J2 * GM * ((R^2)/r5) * p(1) * (5 * tmp-1);
oblate_y = 1.5 * J2 * GM * ((R^2)/r5) * p(2) * (5 * tmp-1);
oblate_z = 1.5 * J2 * GM * ((R^2)/r5) * p(3) * (5 * tmp-3);

% Return the acceleration vector due to the J2 oblateness.
acc_oblateness = [oblate_x, oblate_y, oblate_z];

end
