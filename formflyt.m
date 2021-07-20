%% #######################################################################
% ########################################################################
% ###                                                                  ###
% ###     LUMELITE ORBIT DYNAMICS AND CONTROL FOR FORMATION FLYING     ###
% ###     ========================================================     ###
% ###          By Matthew Lo, Samuel Low, and Dr Poh Eng Kee           ###
% ###                   Last Updated: 8th July 2021                    ###
% ###                                                                  ###
% ########################################################################
% ########################################################################

clc; clear; close all;

%% USER INPUTS

% Specify the number of satellites.
numSats = 3;

% Specify the duration and the time step of the dynamics simulation (s).
tt = 1 * 86400;
dt = 10.0;

% Specify the interval where the control mode of the spacecraft becomes
% toggle-able. For STAREFIX, expect control mode to be toggle-able at
% most once every 5 orbits minimally.

% Input the initial osculating orbit elements for satellite 1.
a1  = 7000000;     % Semi-major axis (m)
e1  = 0.001;       % Eccentricity (unitless)
i1  = 10.00;       % Inclination (degrees)
w1  = 90.00;       % Arg of Periapsis (degrees)
R1  = 45.00;       % Right Ascension (degrees)
M1  = -90.00;       % Mean Anomaly (degrees)
Cd1 = 2.2;         % Drag coefficient
Ar1 = 0.374;       % Drag area (m^2)
Ms1 = 17.90;       % Spacecraft mass (kg)

% Input the initial osculating orbit elements for satellite 2.
a2  = 7000000;     % Semi-major axis (m)
e2  = 0.001;       % Eccentricity (unitless)
i2  = 10.00;       % Inclination (degrees)
w2  = 90.00;       % Arg of Periapsis (degrees)
R2  = 45.00;       % Right Ascension (degrees)
M2  = 45.00;       % Mean Anomaly (degrees)
Cd2 = 2.2;         % Drag coefficient
Ar2 = 0.374;       % Drag area (m^2)
Ms2 = 17.90;       % Spacecraft mass (kg)

% Input the initial osculating orbit elements for satellite 3.
a3  = 7000000;     % Semi-major axis (m)
e3  = 0.001;       % Eccentricity (unitless)
i3  = 10.00;       % Inclination (degrees)
w3  = 90.00;       % Arg of Periapsis (degrees)
R3  = 45.00;       % Right Ascension (degrees)
M3  = 45.00;       % Mean Anomaly (degrees)
Cd3 = 2.2;         % Drag coefficient
Ar3 = 0.374;       % Drag area (m^2)
Ms3 = 17.90;       % Spacecraft mass (kg)

% Toggle the following perturbation forces (0 = False, 1 = True).
flag_J2 = 0;
flag_drag = 0;

% ########################################################################
% ########################################################################

%% HOUSEKEEPING OF MATLAB FILE PATHS

[directory, ~, ~]  = fileparts( mfilename('fullpath') );
paths = {[ directory '\library\formflyt_planet' ]; ...
         [ directory '\library\formflyt_orbits' ]; ...
         [ directory '\library\formflyt_accel' ]; ...
         [ directory '\library\formflyt_rotate' ]};

for n = 1 : length( paths )
    addpath( string( paths(n) ) );
end

% ########################################################################
% ########################################################################

%% INITIALISATION OF ALL ORBIT STATES

% Initialise the gravitational constant and planet radius.
GM = 3.9860e+14;
RE = 6378140.00;

% Position, velocity, acceleration and true anomaly.
[pos1, vel1, acc1, nu1] = kepler_states(a1, e1, i1, R1, w1, M1, GM);
[pos2, vel2, acc2, nu2] = kepler_states(a2, e2, i2, R2, w2, M2, GM);
[pos3, vel3, acc3, nu3] = kepler_states(a3, e3, i3, R3, w3, M3, GM);

% Initialise the total number of samples.
nSamples = floor( tt / dt ) + 1;

% Initialise the position arrays 
pos1a      = zeros( nSamples, 3 );
pos1a(1,:) = pos1; % Initial position of LEO1
pos2a      = zeros( nSamples, 3 );
pos2a(1,:) = pos2; % Initial position of LEO2
pos3a      = zeros( nSamples, 3 );
pos3a(1,:) = pos3; % Initial position of LEO3

% Initialise the velocity arrays 
vel1a      = zeros( nSamples, 3 );
vel1a(1,:) = vel1; % Initial velocity of LEO1
vel2a      = zeros( nSamples, 3 );
vel2a(1,:) = vel2; % Initial velocity of LEO2
vel3a      = zeros( nSamples, 3 );
vel3a(1,:) = vel3; % Initial velocity of LEO3

% ########################################################################
% ########################################################################

%% Main dynamics loop using an RK4 numerical integrator below 

% Sun pointing in n2 hat direction inertial frame?

% Within the dynamics loop, there are key events that need to happen.

% First, the orbit is numerically propagated using the initial conditions
% above using the RK4 propagator written.

% Second, the formation geometry RIC vectors need to be computed, and used
% as feedback in the control law.

% Third, the dynamics loop is assumed to run in the same time step as the
% control loop, and has to keep track of two states at any point in time -
% the control-ready state (i.e. when thrusters are ready for fire), and the
% sunlit state (i.e. the spacecraft is in the illumination cone of the
% sun). Note that the control-ready state will only be toggle-able if the
% spacecraft is in sunlit state!

% Fourth, the frame used in the dynamics loop would be the pseudo-inertial
% ECI frame. This frame does not rotate with Earth's polar motion, but 

% Note, the number of satellites to be propagated is hard-coded in this
% for-loop to be three (Lumelites 1, 2, 3).

for N = 1 : nSamples
    
    % Runge-Kutta 4th Order (RK4) Propagator (3/8 Rule Variant) for LEO 1
    
    k1p1 = vel1a(N,:);
    k1v1 = accel_total( pos1a(N,:), ...
                        vel1a(N,:), ...
                        Cd1, Ar1, Ms1, flag_J2, flag_drag );
    
    k2p1 = vel1a(N,:) + dt * ( (1/3) * k1v1 );
    k2v1 = accel_total( pos1a(N,:) + dt * ( (1/3) * k1p1 ), ...
                        vel1a(N,:) + dt * ( (1/3) * k1v1 ), ...
                        Cd1, Ar1, Ms1, flag_J2, flag_drag );
    
    k3p1 = vel1a(N,:) + dt * ( k2v1 - (1/3) * k1v1 );
    k3v1 = accel_total( pos1a(N,:) + dt * ( k2p1 - (1/3) * k1p1 ), ...
                        vel1a(N,:) + dt * ( k2v1 - (1/3) * k1v1 ), ...
                        Cd1, Ar1, Ms1, flag_J2, flag_drag );
    
    k4p1 = vel1a(N,:) + dt * ( k1v1 - k2v1 + k3v1 );
    k4v1 = accel_total( pos1a(N,:) + dt * ( k1p1 - k2p1 + k3p1 ), ...
                        vel1a(N,:) + dt * ( k1v1 - k2v1 + k3v1 ), ...
                        Cd1, Ar1, Ms1, flag_J2, flag_drag );
    
    pos1a(N+1,:) = pos1a(N,:) + (dt/8)*(k1p1 + 3*k2p1 + 3*k3p1 + k4p1);
    vel1a(N+1,:) = vel1a(N,:) + (dt/8)*(k1v1 + 3*k2v1 + 3*k3v1 + k4v1); 
    
end

%writematrix(pos1a,'P.csv');
%writematrix(vel1a,'V.csv');

% Plot the central body.
%plot_body(1);