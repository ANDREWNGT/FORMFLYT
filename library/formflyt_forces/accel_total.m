%%#######################################################################
% #######################################################################
% ###                                                                 ###
% ###    _____ _____ ____  __  __ _____ _   __  __ _____              ###
% ###   |  ___|  _  | __ \|  \/  |  ___| |  \ \/ /|_   _|             ###
% ###   |  __|| |_| | `/ /| \  / |  __|| |__ \  /   | |               ###
% ###   |_|   |_____|_|\_\|_|\/|_|_|   |____|/_/    |_|               ###
% ###                                                                 ###
% ### Project FORMFLYT: Forces Toolbox                                ###
% ### Computation of central two-body force, drag force using the     ###
% ### US Standard Atmosphere 1976, and the J2 perturbation force.     ###
% ###                                                                 ###
% ### By Matthew Lo, Andrew Ng and Samuel Low (12-JUL-2021), DSO NL   ###
% ###                                                                 ###
% #######################################################################
% #######################################################################

function [accel_total] = accel_total( pos, vel, Cd, Ar, Ms, fJ, fD )

% Inputs: The following spacecraft parameters and the primary body radius.
%         - pos -> Position vector (1x3) of the spacecraft
%         - vel -> Velocity vector (1x3) of the spacecraft
%         - Cd  -> Drag coefficient of the spacecraft
%         - Ar  -> Drag area of the spacecraft (m^3)
%         - Ms  -> Mass of the spacecraft (kg)
%         - fJ  -> Flag (0 or 1) to toggle J2 perturbation
%         - fD  -> Flag (0 or 1) to toggle atmospheric drag
% Output: Acceleration vector (1x3) of the spacecraft due to J2 and drag.

% Compute the final acceleration vector
accel_total = accel_grav( pos );

% Add the J2 perturbation force if necessary
if fJ == 1
    accel_total = accel_total + accel_oblate( pos );
end

% Add the drag force if necessary
if fD == 1
    accel_total = accel_total + accel_drag( pos, vel, Cd, Ar, Ms );
end

end

