%% #######################################################################
% ########################################################################
% ###                                                                  ###
% ###     LUMELITE ORBIT DYNAMICS AND CONTROL FOR FORMATION FLYING     ###
% ###     ========================================================     ###
% ###     By Matthew Lo, Andrew Ng, Samuel Low, and Dr Poh Eng Kee     ###
% ###                 Last Updated: 6th September 2021                 ###
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

% Specify thruster burn mode intervals (hot = firing, cool = cool-down).
duration_hot  = 300.0;   % About 300s of burn time
duration_cool = 28500.0; % About 5 orbits of cool down

% Specify the thruster's average force (N)
thrust = 0.760;

% Initialise the pointing error DCM. Note that in the dynamics loop, this
% pointing error DCM should be re-initialised in each loop as a random
% variable to simulate the pointing error of the spacecraft thruster.
pointing_error_DCM = eye(3);

% Input the initial osculating orbit elements for Satellite 1.
a1  = 6925140;     % Semi-major axis (m)
e1  = 0.001;       % Eccentricity (unitless)
i1  = 10.00;       % Inclination (degrees)
w1  = 0.00;        % Arg of Periapsis (degrees)
R1  = 70.00;       % Right Ascension (degrees)
M1  = 46.654;      % Mean Anomaly (degrees)
Cd1 = 2.2;         % Drag coefficient
Ar1 = 0.374;       % Drag area (m^2)
Ms1 = 17.90;       % Spacecraft mass (kg)
Th1 = 0.00;        % Spacecraft thrust force (N)

% Input the initial osculating orbit elements for Satellite 2.
a2  = 6925140;     % Semi-major axis (m)
e2  = 0.001;       % Eccentricity (unitless)
i2  = 10.00;       % Inclination (degrees)
w2  = 0.00;        % Arg of Periapsis (degrees)
R2  = 72.00;       % Right Ascension (degrees)
M2  = 43.925 ;     % Mean Anomaly (degrees)
Cd2 = 2.2;         % Drag coefficient
Ar2 = 0.374;       % Drag area (m^2)
Ms2 = 17.90;       % Spacecraft mass (kg)
Th2 = 0.00;        % Spacecraft thrust force (N)

% Input the initial osculating orbit elements for Satellite 3.
a3  = 6925140;     % Semi-major axis (m)
e3  = 0.001;       % Eccentricity (unitless)
i3  = 10.00;       % Inclination (degrees)
w3  = 0.00;        % Arg of Periapsis (degrees)
R3  = 70.00;       % Right Ascension (degrees)
M3  = 44.996;      % Mean Anomaly (degrees)
Cd3 = 2.2;         % Drag coefficient
Ar3 = 0.374;       % Drag area (m^2)
Ms3 = 17.90;       % Spacecraft mass (kg)
Th3 = 0.00;        % Spacecraft thrust force (N)

% Specify Satellite 2's RIC geometry requirements and tolerances (m)
desired_R2 = 0.0;       % Desired radial separation of Sat 2
desired_I2 = -100000.0; % Desired in-track separation of Sat 2
desired_C2 = 42000.0;   % Desired cross-track separation of Sat 2

% Specify Satellite 3's RIC geometry requirements and tolerances (m)
desired_R3 = 0.0;       % Desired radial separation of Sat 3
desired_I3 = -200000.0; % Desired in-track separation of Sat 3
desired_C3 = 0.0;       % Desired cross-track separation of Sat 3

% Specify the formation geometry tolerance (m)
tolerance_R = 1000.0;
tolerance_I = 1000.0;
tolerance_C = 1000.0;

% Toggle the following perturbation flags (0 = False, 1 = True).
f_J2 = 1; % Enable / disable J2
f_Dg = 1; % Enable / disable drag

% ########################################################################
% ########################################################################

%% HOUSEKEEPING OF MATLAB FILE PATHS

[directory, ~, ~]  = fileparts( mfilename('fullpath') );
paths = {[ directory '\library\formflyt_forces' ]; ...
         [ directory '\library\formflyt_numint' ]; ...
         [ directory '\library\formflyt_orbits' ]; ...
         [ directory '\library\formflyt_planet' ]; ...
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

% Initialise the relative position arrays of LEO2 and LEO3
posRIC2a = zeros( nSamples, 3 );
posRIC3a = zeros( nSamples, 3 );

% Initialise the estimated Keplerian orbit period of LEO1 (for reference)
orbT = sqrt(( 4 * (pi^2) * (a1^3) ) / GM);

% ########################################################################
% ########################################################################

%% Main dynamics loop using an RK4 numerical integrator below 
% It is assumed that Satellite 1 is the chief reference.

% Initialise an integer variable for thruster-mode count down.
thruster_clock_2 = 0;
thruster_clock_3 = 0;

% BEGIN THE DYNAMICS LOOP

for N = 1 : nSamples
    
    % Fetch the current positions and velocities of the satellites.
    p1 = pos1a(N,:);
    v1 = vel1a(N,:);
    p2 = pos2a(N,:);
    v2 = vel2a(N,:);
    p3 = pos3a(N,:);
    v3 = vel3a(N,:);
    
    % Compute the Hill Frame of Satellite 1 as a Direction Cosine Matrix
    h1 = cross(p1, v1);                   % Angular momentum vector
    r_hat = p1 / norm(p1);                % Local X-axis
    h_hat = h1 / norm(h1);                % Local Z-axis
    y_hat = cross(h_hat, r_hat);          % Local Y-axis
    hill_dcm = [ r_hat ; h_hat ; y_hat ]; % Hill DCM
    
    % Compute the RIC for Satellite 2 as feedback into the control loop.
    pRIC2 = hill_dcm * (p2-p1).';
    posRIC2a(N,:) = pRIC2;
    error_R2 = pRIC2(1) - desired_R2; % This should not exceed tolerance
    error_I2 = pRIC2(3) - desired_I2; % This should not exceed tolerance
    error_C2 = pRIC2(2) - desired_C2; % This should not exceed tolerance
    
    % Compute the RIC for Satellite 3 as feedback into the control loop.
    pRIC3 = hill_dcm * (p3-p1).';
    posRIC3a(N,:) = pRIC3;
    error_R3 = pRIC3(1) - desired_R3; % This should not exceed tolerance
    error_I3 = pRIC3(3) - desired_I3; % This should not exceed tolerance
    error_C3 = pRIC3(2) - desired_C3; % This should not exceed tolerance
    
    % ####################################################################
    % ####################################################################
    
    % PERFORM RADIAL CORRECTIONS HERE FOR SATELLITE 2 AND 3
    % CONTROL SOLUTION SHOULD BE A 1X3 THRUST VECTOR `Th2` AND `Th3`
    % Be sure to keep track that the thruster for Lumelite can't exceed
    % 300 seconds for each burn, before needing to rest for ~5 orbits.
    
    % ####################################################################
    % ####################################################################
    
    % PERFORM IN-TRACK CORRECTIONS HERE FOR SATELLITE 2 AND 3
    % CONTROL SOLUTION SHOULD BE A 1X3 THRUST VECTOR `Th2` AND `Th3`
    % Be sure to keep track that the thruster for Lumelite can't exceed
    % 300 seconds for each burn, before needing to rest for ~5 orbits.
    
    % ####################################################################
    % ####################################################################
    
    % PERFORM CROSS-TRACK CORRECTIONS HERE FOR SATELLITE 2 AND 3
    % CONTROL SOLUTION SHOULD BE A 1X3 THRUST VECTOR `Th2` AND `Th3`
    % Be sure to keep track that the thruster for Lumelite can't exceed
    % 300 seconds for each burn, before needing to rest for ~5 orbits.
    
    % ####################################################################
    % ####################################################################
    
    % MAIN INTEGRATOR BELOW.
    
    % You should not need to change anything below in the propagator, your
    % control solution above should only affect the values of the thrust
    % vectors `Th1`, `Th2`, `Th3`.
    
    % Runge-Kutta 4th Order (RK4) Propagator (3/8 Rule Variant).
    % This code below is meant to only propagate LEO 1.
    [p1f, v1f] = prop_RK4_38( dt, p1, v1, Cd1, Ar1, Ms1, f_J2, f_Dg, Th1 );
    pos1a(N+1,:) = p1f;
    vel1a(N+1,:) = v1f;
    
    % Runge-Kutta 4th Order (RK4) Propagator (3/8 Rule Variant).
    % This code below is meant to only propagate LEO 2.
    [p2f, v2f] = prop_RK4_38( dt, p2, v2, Cd2, Ar2, Ms2, f_J2, f_Dg, Th2 );
    pos2a(N+1,:) = p2f;
    vel2a(N+1,:) = v2f;
    
    % Runge-Kutta 4th Order (RK4) Propagator (3/8 Rule Variant).
    % This code below is meant to only propagate LEO 3.
    [p3f, v3f] = prop_RK4_38( dt, p3, v3, Cd3, Ar3, Ms3, f_J2, f_Dg, Th3 );
    pos3a(N+1,:) = p3f;
    vel3a(N+1,:) = v3f;
    
end

%% PLOT THE RADIAL, INTRACK, CROSS-TRACK OF SATELLITE 2 WRT 1
figure(1);
hold;
plot(posRIC2a(:,1));
plot(posRIC2a(:,2));
plot(posRIC2a(:,3));
legend;

%% PLOT THE RADIAL, INTRACK, CROSS-TRACK OF SATELLITE 2 WRT 1
figure(2);
hold;
plot(posRIC3a(:,1));
plot(posRIC3a(:,2));
plot(posRIC3a(:,3));
legend;

%% FOR DEBUGGING...
% CAN PLOT THE ORBIT ABOUT CENTRAL BODY USING THE PLOTTER BELOW TOO

% writematrix(pos1a,'P1.csv');
% writematrix(vel1a,'V1.csv');
% writematrix(pos2a,'P2.csv');
% writematrix(vel2a,'V2.csv');
% writematrix(pos3a,'P3.csv');
% writematrix(vel3a,'V3.csv');
% writematrix(posRIC2a,'posRIC2a.csv');
% writematrix(posRIC3a,'posRIC3a.csv');

% Plot the central body.
% plot_body(1);
% Plot the trajectory about the central body.