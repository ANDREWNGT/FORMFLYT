%%#######################################################################
% #######################################################################
% ###                                                                 ###
% ###    _____ _____ ____  __  __ _____ _   __  __ _____              ###
% ###   |  ___|  _  | __ \|  \/  |  ___| |  \ \/ /|_   _|             ###
% ###   |  __|| |_| | `/ /| \  / |  __|| |__ \  /   | |               ###
% ###   |_|   |_____|_|\_\|_|\/|_|_|   |____|/_/    |_|               ###
% ###                                                                 ###
% ### Project FORMFLYT: Two Body Keplerian Toolbox                    ###
% ### Converting orbit elements into inertial position and velocity   ###
% ###                                                                 ###
% ### By Samuel Low (08-JUL-2021), DSO National Laboratories          ###
% ###                                                                 ###
% #######################################################################
% #######################################################################

function [pos, vel, acc, trueAnom] = kepler_states(a, e, i, R, w, M, GM)

% Inputs: Six (float) Keplerian elements (angular components in degrees).
%         - a    -> Semi-major axis (km)
%         - e    -> Eccentricity (unit-less)
%         - i    -> Inclination (degrees)
%         - R    -> Right Angle of Asc Node (degrees)
%         - w    -> Argument of Perigee (degrees)
%         - M    -> Mean Anomaly (degrees)
%         - GM   -> Planetary GM Constant (m^3 * kg^-1 * s^-2)
% Output: A 1x3 position and 1x3 velocity vector in the inertial frame.

% The general flow of the program, is to first solve for the radial
% position and velocity (in the inertial frame) via Kepler's equation.
% Thereafter, we will obtain the inertial coordinates in the Hill frame,
% by performing a 3-1-3 Euler Angle rotation using an appropriate DCM.

% First, let us solve for the eccentric anomaly.
eccAnom = kepler_solver(M, e);

% With the eccentric anomaly, we can solve for the position and velocity
% in the local orbital frame, using the polar equation for an ellipse.
pos_X = a * ( cosd(eccAnom) - e);
pos_Y = a * sqrt( 1 - e^2 ) * sind(eccAnom);
pos_norm = norm( [ pos_X pos_Y ] );
vel_const = sqrt( GM * a ) / pos_norm;
vel_X = vel_const * ( -1 * sind(eccAnom) );
vel_Y = vel_const * ( sqrt( 1 - e^2 ) * cosd(eccAnom) );

% To perform the conversion from the local orbit plane to an ECI frame, we
% need perform the 3-1-3 Euler angle rotation in the following sequence:
% Right Angle of Ascending Node -> Inclination -> Argument of Latitude.
% Now, let us get us the DCM that converts to the hill-frame.
DCM_HN = dcm_rotate_z(w) * dcm_rotate_x(i) * dcm_rotate_z(R);

% Notice that the hill frame computation does not include a rotation of
% the true anomaly, and that is because the true anomaly has already been
% accounted for when computing pos_X and pos_Y using information from the
% eccentric anomaly. Including true anomaly in the DCM rotation would
% double-count that anomaly rotation.

% The current coordinates are in the local hill frame, and thus conversion 
% from hill to inertial would be the transpose (or inverse) of HN.
DCM_NH = DCM_HN';

% With the hill frame, we can now convert it to the ECI frame.
pos = DCM_NH * [ pos_X pos_Y 0.0 ]' ;
vel = DCM_NH * [ vel_X vel_Y 0.0 ]' ;

% With the ECI frame, we can also compute the inverse square acceleration.
acc = ( ( -1 * GM ) * pos ) / ( pos_norm ^ 3 );

% Finally, let us not forget to compute the true anomaly.
trueAnom = rad2deg( atan2( pos_Y, pos_X) );

end

