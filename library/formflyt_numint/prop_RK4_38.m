%%#######################################################################
% #######################################################################
% ###                                                                 ###
% ###    _____ _____ ____  __  __ _____ _   __  __ _____              ###
% ###   |  ___|  _  | __ \|  \/  |  ___| |  \ \/ /|_   _|             ###
% ###   |  __|| |_| | `/ /| \  / |  __|| |__ \  /   | |               ###
% ###   |_|   |_____|_|\_\|_|\/|_|_|   |____|/_/    |_|               ###
% ###                                                                 ###
% ### Project FORMFLYT: Numerical Integration Toolbox                 ###
% ### Runge-Kutte 4th Order Numerical Integration (3/8 Rule)          ###
% ###                                                                 ###
% ### By Matthew Lo, Andrew Ng and Samuel Low (21-JUL-2021), DSO NL   ###
% ###                                                                 ###
% #######################################################################
% #######################################################################

function [pf, vf] = prop_RK4_38( dt, pi, vi, Cd, Ar, Ms, fJ, fD )

% Inputs:
% - dt -> Time step size (s)
% - pi -> Initial position vector (1x3) of the spacecraft (m)
% - vi -> Initial velocity vector (1x3) of the spacecraft (m)
% - Cd -> Drag coefficient of the spacecraft (unit-less)
% - Ar -> Drag area of the spacecraft (m^3)
% - Ms -> Mass of the spacecraft (kg)
% - fJ -> Flag (0 or 1) to toggle J2 perturbation
% - fD -> Flag (0 or 1) to toggle atmospheric drag

% Output: The updated position and velocity vector of the spacecraft
% - pf -> Final position vector (1x3) of the spacecraft (m)
% - vf -> Final velocity vector (1x3) of the spacecraft (m)

k1p = vi;
k1v = accel_total( pi, vi, Cd, Ar, Ms, fJ, fD );

k2p = vi + dt * ( (1/3) * k1v );
k2v = accel_total( pi + dt * ( (1/3) * k1p ), ...
                   vi + dt * ( (1/3) * k1v ), ...
                   Cd, Ar, Ms, fJ, fD );

k3p = vi + dt * ( k2v - (1/3) * k1v );
k3v = accel_total( pi + dt * ( k2p - (1/3) * k1p ), ...
                   vi + dt * ( k2v - (1/3) * k1v ), ...
                   Cd, Ar, Ms, fJ, fD );

k4p = vi + dt * ( k1v - k2v + k3v );
k4v = accel_total( pi + dt * ( k1p - k2p + k3p ), ...
                   vi + dt * ( k1v - k2v + k3v ), ...
                   Cd, Ar, Ms, fJ, fD );

pf = pi + (dt/8)*(k1p + 3*k2p + 3*k3p + k4p);
vf = vi + (dt/8)*(k1v + 3*k2v + 3*k3v + k4v); 

end