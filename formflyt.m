%% #######################################################################
% ########################################################################
% ###                                                                  ###
% ###      ORBIT DYNAMICS SIMULATOR FOR FORMATION FLYING CONTROL       ###
% ###      =====================================================       ###
% ###          By Matthew Lo, Samuel Low, and Dr Poh Eng Kee           ###
% ###                   Last Updated: 8th July 2021                    ###
% ###                                                                  ###
% ########################################################################
% ########################################################################

clc; clear; close all;

%% USER INPUTS

% Specify the number of satellites
numSats = 3;

% Specify the duration and the time step of the dynamics simulation (s).
time_duration = 1 * 86400;
time_step = 60.0;

% Specify the interval where the control mode of the spacecraft becomes
% toggle-able. For STAREFIX, expect control mode to be toggle-able at most
% once every 5 orbits minimally.

% Input the initial osculating orbit elements for satellite 1.
a1  = 7000000;     % Semi-major axis (m)
e1  = 0.001;       % Eccentricity (unitless)
i1  = 10.00;       % Inclination (degrees)
w1  = 90.00;       % Arg of Periapsis (degrees)
R1  = 45.00;       % Right Ascension (degrees)
M1  = 45.00;       % Mean Anomaly (degrees)
Cd1 = 2.2;         % Drag coefficient
Ar1 = 0.374;       % Drag area (m^2)
Ms1 = 20.00;       % Spacecraft mass (kg)

% Input the initial osculating orbit elements for satellite 2.
a2  = 7000000;     % Semi-major axis (m)
e2  = 0.001;       % Eccentricity (unitless)
i2  = 10.00;       % Inclination (degrees)
w2  = 90.00;       % Arg of Periapsis (degrees)
R2  = 45.00;       % Right Ascension (degrees)
M2  = 45.00;       % Mean Anomaly (degrees)
Cd2 = 2.2;         % Drag coefficient
Ar2 = 0.374;       % Drag area (m^2)
Ms2 = 20.00;       % Spacecraft mass (kg)

% Input the initial osculating orbit elements for satellite 3.
a3  = 7000000;     % Semi-major axis (m)
e3  = 0.001;       % Eccentricity (unitless)
i3  = 10.00;       % Inclination (degrees)
w3  = 90.00;       % Arg of Periapsis (degrees)
R3  = 45.00;       % Right Ascension (degrees)
M3  = 45.00;       % Mean Anomaly (degrees)
Cd3 = 2.2;         % Drag coefficient
Ar3 = 0.374;       % Drag area (m^2)
Ms3 = 20.00;       % Spacecraft mass (kg)

% Toggle the following perturbation forces (0 = False, 1 = True)
flag_force_J2 = 1;
flag_force_drag = 0;
flag_force_solar = 0;

%% HOUSEKEEPING OF MATLAB FILE PATHS

[directory, ~, ~]  = fileparts( mfilename('fullpath') );
paths = {[ directory '\library\formflyt_planet' ]; ...
         [ directory '\library\formflyt_orbits' ]; ...
         [ directory '\library\formflyt_forces' ]; ...
         [ directory '\library\formflyt_rotate' ]};

for n = 1 : length( paths )
    addpath( string( paths(n) ) );
end

%% INITIALISATION OF ALL ORBIT STATES

% Gravitational constant and planet radius
GM = 3.9860e+14;
RR = 6378140;

% position, velocity, acceleration and true anomaly.
[pos1, vel1, acc1, nu1] = kepler_states(a1, e1, i1, R1, w1, M1, GM);
[pos2, vel2, acc2, nu2] = kepler_states(a2, e2, i2, R2, w2, M2, GM);
[pos3, vel3, acc3, nu3] = kepler_states(a3, e3, i3, R3, w3, M3, GM);



%% Main dynamics loop below 

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

RK4orbitJ2solver(6900.00, 0.01, 0, 10, 0);

% Plot the central body.
plot_body(1);