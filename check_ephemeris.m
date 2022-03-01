clc
clear
close all

original_folder = "data_STK_astrogator\\Processed_data\\";
new_folder = "data_STK_astrogator\\Inertial_at_ignition\\";
file = "Lumelite3_ground_truth.csv";

oldfile = original_folder + file;
newfile = new_folder + file;

old_data = readtable(oldfile);
new_data = readtable(newfile);
timesteps_old = [1:size(old_data.Time_UTCG_)];
timesteps_new = [1:size(new_data.Time_UTCG_)];
fh=figure(1);
fh.WindowState = 'maximized';
grid minor 
hold on
plot(timesteps_old, old_data.Radial_km_, 'r')
plot(timesteps_new, new_data.Radial_km_, 'b')
legend("Update during burn", "Inertial at ignition")
title('radial comparison')

fh=figure(2);
fh.WindowState = 'maximized';
grid minor 
hold on
plot(timesteps_old, old_data.In_Track_km_, 'r')
plot(timesteps_new, new_data.In_Track_km_, 'b')
title('In track comparison')
legend("Update during burn", "Inertial at ignition")


fh=figure(3);
fh.WindowState = 'maximized';
grid minor 
hold on
plot(timesteps_old, old_data.Cross_Track_km_, 'r')
plot(timesteps_new, new_data.Cross_Track_km_, 'b')
title('Cross track comparison')
legend("Update during burn", "Inertial at ignition")