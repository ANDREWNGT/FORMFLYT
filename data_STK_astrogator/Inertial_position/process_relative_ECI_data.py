# -*- coding: utf-8 -*-
"""
Created on Mon Jun 13 10:40:00 2022

@author: USER
"""
import pandas as pd

files = ["Lumelite1_J2_Inertial_Position_Velocity.csv", 
         "Lumelite2_finite_Inertial_Position_Velocity.csv", 
         "Lumelite3_finite_Inertial_Position_Velocity.csv"]

lum1_ECI = pd.read_csv(files[0])
lum2_ECI = pd.read_csv(files[1])
lum3_ECI = pd.read_csv(files[2])

def output_relative_ECI(A, B):
    output_df = pd.DataFrame()
    output_df["Time (UTCG)"] = A["Time (UTCG)"]
    headers = ["x (km)", "y (km)", "z (km)", "vx (km/sec)", "vy (km/sec)", "vz (km/sec)"]
    for header in headers: 
        output_df[header] = A[header] - B[header]
    return output_df
lum12_ECI = output_relative_ECI(lum1_ECI, lum2_ECI)
lum13_ECI = output_relative_ECI(lum1_ECI, lum3_ECI)

lum12_ECI.to_csv("Lumelite12_ECI_Position_Velocity.csv", index = False)
lum13_ECI.to_csv("Lumelite13_ECI_Position_Velocity.csv", index = False)


idx_lum2_min_semimajoraxis= lum2_ECI["Semi-major Axis (km)"].idxmin()
idx_lum3_min_semimajoraxis= lum3_ECI["Semi-major Axis (km)"].idxmin()
lum2_time, lum2_min_semimajor_axis = lum2_ECI["Time (UTCG)"][idx_lum2_min_semimajoraxis], lum2_ECI["Semi-major Axis (km)"][idx_lum2_min_semimajoraxis]
lum3_time, lum3_min_semimajor_axis = lum3_ECI["Time (UTCG)"][idx_lum3_min_semimajoraxis], lum3_ECI["Semi-major Axis (km)"][idx_lum3_min_semimajoraxis]

lum_semi_major_axis = pd.DataFrame(index = pd.Index(["lum2", "lum3"]))
lum_semi_major_axis["Time (UTCG)"] = [lum2_time, lum3_time]
lum_semi_major_axis["Min semimajor axis (km)"] = [lum2_min_semimajor_axis, lum3_min_semimajor_axis]

lum_semi_major_axis.to_csv("min_semimajor_axis_data.csv")