%%#######################################################################
% #######################################################################
% ###                                                                 ###
% ###    _____ _____ ____  __  __ _____ _   __  __ _____              ###
% ###   |  ___|  _  | __ \|  \/  |  ___| |  \ \/ /|_   _|             ###
% ###   |  __|| |_| | `/ /| \  / |  __|| |__ \  /   | |               ###
% ###   |_|   |_____|_|\_\|_|\/|_|_|   |____|/_/    |_|               ###
% ###                                                                 ###
% ### Project FORMFLYT: Plotting Planetary Bodies Toolbox             ###
% ### Plotting of the Earth as the central body in the main figure    ###
% ###                                                                 ###
% ### Originally by Ryan Gray (08-09-2004, revised 16-10-2013)        ###
% ### Adapted by Samuel Low (22-12-2020), DSO National Laboratories   ###
% ###                                                                 ###
% #######################################################################
% #######################################################################

function bodyplot_earth()

% Set the plot background colour to black.
space_color = 'k';

% Number of globe panels around the equator deg/panel = 360/npanels
npanels = 180;

% Globe transparency level, 1 = opaque, through 0 = invisible
alpha   = 1;

% Earth texture image handled by imread()
image_file = 'bodyplot_earth.jpg';

% Mean spherical earth parameters
erad = 6371008.7714; % Equatorial radius (m)
prad = 6371008.7714; % Polar radius (m)

% Create the figure
figure('Color', space_color);

% Set the background wallpaper.
bg = imread('wallpaper_galaxy.png');
ax1 = axes();
imshow(bg, 'Parent', ax1);
ax2 = axes('Color', 'none');
ax2.XAxis.LineWidth = 2;
ax2.YAxis.LineWidth = 2;
ax2.ZAxis.LineWidth = 2;
set(gca,'DataAspectRatioMode','auto')
set(gca,'Position',[0 0 1 1])

% Turn off the normal axes
hold on;
set(gca, 'NextPlot','add', 'Visible','off');
axis equal;
axis auto;
e2rad = 2 * erad;
axis([-e2rad e2rad -e2rad e2rad -e2rad e2rad]);

% Set initial view
view(0,30);
axis vis3d;

% Disable clipping
ax = gca;
ax.Clipping = 'off';

%% Create wireframe globe
% Create a 3D meshgrid of the sphere points using the ellipsoid function
[x, y, z] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);
globe = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);

% Texture-map the globe
cdata = imread(image_file);

% Set image as color data (cdata) property, and set face color to
% indicate a texturemap, which Matlab expects to be in cdata.
% Turn off the mesh edges.
set(globe,        ...
    'FaceColor',  ...
    'texturemap', ...
    'CData',      ...
    cdata,        ...
    'FaceAlpha',  ...
    alpha,        ...
    'EdgeColor',  ...
    'none');

end

