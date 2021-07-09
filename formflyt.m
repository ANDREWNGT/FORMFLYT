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

%% USER INPUTS BELOW:
% User to select the choice of primary body, specify the number of space
% craft, and for each spacecraft, to add a block of orbit elements
% comprising the initial osculating elements of the orbit.

% Select the choice of primary body
% 1, 2, 3, 4, 5 = Earth, Moon, Mars, Venus, Mercury
body = 4;

% Specify the number of satellites
numSats = 3;

% Specify the initial and final time and the time step.


% Input the initial osculating orbit elements for satellite 1.
a1 = 7000000;     % Semi-major axis (m)
e1 = 0.001;       % Eccentricity (unitless)
i1 = 10.00;       % Inclination (degrees)
w1 = 90.00;       % Arg of Periapsis (degrees)
R1 = 45.00;       % Right Ascension (degrees)
M1 = 45.00;       % Mean Anomaly (degrees)

% Input the initial osculating orbit elements for satellite 2.
a2 = 7000000;     % Semi-major axis (m)
e2 = 0.001;       % Eccentricity (unitless)
i2 = 10.00;       % Inclination (degrees)
w2 = 90.00;       % Arg of Periapsis (degrees)
R2 = 45.00;       % Right Ascension (degrees)
M2 = 45.00;       % Mean Anomaly (degrees)

% Input the initial osculating orbit elements for satellite 3.
a3 = 7000000;     % Semi-major axis (m)
e3 = 0.001;       % Eccentricity (unitless)
i3 = 10.00;       % Inclination (degrees)
w3 = 90.00;       % Arg of Periapsis (degrees)
R3 = 45.00;       % Right Ascension (degrees)
M3 = 45.00;       % Mean Anomaly (degrees)

% Toggle the following perturbation forces (0 = False, 1 = True)
force_J2 = 1;
force_drag = 0;
force_solar = 0;

%% Basic MATLAB house-keeping, and addition of the library file paths.

[directory, ~, ~]  = fileparts( mfilename('fullpath') );
paths = {[ directory '\library\formflyt_planet' ]; ...
         [ directory '\library\formflyt_orbits' ]; ...
         [ directory '\library\formflyt_forces' ]; ...
         [ directory '\library\formflyt_rotate' ]};

for n = 1 : length( paths )
    addpath( string( paths(n) ) );
end

%% Initialize the gravitational constant based on the primary body.

gravBodies = [ 3.9860e+14 ... % 1 = Earth
               4.9041e+12 ... % 2 = Moon
               4.2828e+13 ... % 3 = Mars
               3.2487e+14 ... % 4 = Venus
               2.1925e+13 ];  % 5 = Mercury

radBodies = [ 6371140 ...     % 1 = Earth
              1737100 ...     % 2 = Moon
              3389500 ...     % 3 = Mars
              6051800 ...     % 4 = Venus
              2439700 ];      % 5 = Mercury

mu = gravBodies( body ); % Primary body gravitational constant
rad = radBodies( body ); % Primary body planetary radius

%% Initialise the Keplerian (non-perturbed) orbit states at t=0
% position, velocity, acceleration and true anomaly.
[pos1, vel1, acc1, nu1] = kepler_states(a1, e1, i1, R1, w1, M1, mu);
[pos2, vel2, acc2, nu2] = kepler_states(a2, e2, i2, R2, w2, M2, mu);
[pos3, vel3, acc3, nu3] = kepler_states(a2, e2, i2, R2, w2, M2, mu);

%% Main dynamics loop below with several events happening throughout time.
% First, the orbit is numerically propagated using the initial conditions
% above using the RK4 propagator written. Second, the formation geometry
% RIC vectors need to be computed, and used as feedback in the control law.

%RK4orbitJ2solver(6900.00, 0.01, 0, 10, 0);

% Plot the central body.
plot_body( body );