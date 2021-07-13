%%#######################################################################
% #######################################################################
% ###                                                                 ###
% ###    _____ _____ ____  __  __ _____ _   __  __ _____              ###
% ###   |  ___|  _  | __ \|  \/  |  ___| |  \ \/ /|_   _|             ###
% ###   |  __|| |_| | `/ /| \  / |  __|| |__ \  /   | |               ###
% ###   |_|   |_____|_|\_\|_|\/|_|_|   |____|/_/    |_|               ###
% ###                                                                 ###
% ### Project FORMFLYT: Forces Toolbox                                ###
% ### Computation of drag force using the US Standard Atmosphere 1976 ###
% ### in the anti-velocity direction. The atmospheric density model   ###
% ### is given in units (kg/m^3) with an altitude input (km). Valid   ###
% ### only for altitudes between 86km to 1000km, and for Earth body.  ###
% ###                                                                 ###
% ### By Matthew Lo and Samuel Low (12-JUL-2021), DSO NL              ###
% ###                                                                 ###
% #######################################################################
% #######################################################################

function [acc_dragforce] = force_drag( pos, vel, Cd, Ar, Ms )

% Inputs: The following spacecraft parameters and the primary body radius.
%         - pos     -> Position vector (1x3) of the spacecraft
%         - vel     -> Velocity vector (1x3) of the spacecraft
%         - Cd      -> Drag coefficient of the spacecraft
%         - Ar      -> Drag area of the spacecraft (m^3)
%         - Ms      -> Mass of the spacecraft (kg)
% Output: Acceleration vector (1x3) of the spacecraft due to drag.

R = (norm(pos) - 6378140) / 1000; % Average altitude (km)
areaMassRatio = Ar / Ms; % Area-to-mass ratio

% Check if the altitude is negative?
if R < 0
    fprintf('Altitude below Earth surface. Check your units? \n');
    acc_dragforce = [ 0 0 0 ];
    return
end
% The following atmospheric density model comes from the US Standard
% Atmosphere 1976 (kg/m^3) and takes in altitude R (km) as input.

% Coefficients of the polynomial, used as the exponent in the model.
AtmosExp = 0.0;
if R <= 86
    co = [ 0.0000000000  0.0000000000  0.0000000000 -0.1523325   0.202941];
elseif R <= 91
    co = [ 0.0000000000 -3.322622e-06  9.111460e-04 -0.2609971   5.944694];
elseif R <= 100
    co = [ 0.0000000000  2.873405e-05 -0.008492037   0.6541179  -23.62010];
elseif R <= 110
    co = [-1.240774e-05  0.005162063  -0.8048342     55.55996   -1443.338];
elseif R <= 120
    co = [ 0.0000000000 -8.854164e-05  0.03373254   -4.390837    176.5294];
elseif R <= 150
    co = [ 3.661771e-07 -2.154344e-04  0.04809214   -4.884744    172.3597];
elseif R <= 200
    co = [ 1.906032e-08 -1.527799e-05  0.004724294  -0.6992340   20.50921];
elseif R <= 300
    co = [ 1.199282e-09 -1.451051e-06  6.910474e-04 -0.1736220  -5.321644];
elseif R <= 500
    co = [ 1.140564e-10 -2.130756e-07  1.570762e-04 -0.07029296 -12.89844];
elseif R <= 750
    co = [ 8.105631e-12 -2.358417e-09 -2.635110E-06 -0.01562608 -20.02246];
elseif R <= 1000
    co = [-3.701195e-12 -8.608611e-09  5.118829e-05 -0.06600998 -6.137674];
else
    co = [0 0 0 0 0];
end

% Compute the polynomial that is used as the exponent term.
AtmosExp = AtmosExp + co(1)*(R^4);
AtmosExp = AtmosExp + co(2)*(R^3);
AtmosExp = AtmosExp + co(3)*(R^2);
AtmosExp = AtmosExp + co(4)*(R^1);
AtmosExp = AtmosExp + co(5);

% Compute the atmospheric density (kg/m^3)
dragDensity = exp(AtmosExp);

% Compute the atmospheric drag acceleration (m/s^2)
dragAccel = 0.5 * Cd * dragDensity * areaMassRatio * ( norm(vel) ^ 2 );

% Compute the drag vector in the anti-velocity direction.
acc_dragforce = -1 * dragAccel * ( vel / norm(vel) );

end

