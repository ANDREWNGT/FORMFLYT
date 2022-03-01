# -*- coding: utf-8 -*-
"""
Created on Fri Jan  7 10:55:24 2022

@author: Andrew
"""

import pandas as pd
import os
satellites = ["Lumelite2", "Lumelite3"]

def extract_time_schedule(satellite):
    '''
    Function to retrieve manuever time in terms of time from mission start.
    '''
    filename=f'{satellite}_finite MCS Ephemeris Segments.csv'
    df = pd.read_table(filename, delimiter=',')
    df["Stop Time (UTCG)"]= pd.to_datetime(df["Stop Time (UTCG)"], format ='%d %b %Y %H:%M:%S.%f')
    df["Start Time (UTCG)"]= pd.to_datetime(df["Start Time (UTCG)"], format ='%d %b %Y %H:%M:%S.%f')
    segment_duration = (df["Stop Time (UTCG)"] - df["Start Time (UTCG)"]).dt.total_seconds()
    start_time= df["Start Time (UTCG)"].iloc[0]
    df["Time from mission start (s)"] = (df["Start Time (UTCG)"]- start_time).dt.total_seconds()
    df=df.drop(["Segment Type"], 1) ##ERROR???
    df["segment_duration"] =segment_duration
    return df, segment_duration

def process_maneuver_data(satellite):
    '''
    Function to retrieve manuever time in terms of time from mission start.
    '''
    filename=f'{satellite}_finite Maneuver Summary.csv'
    df = pd.read_table(filename, delimiter=',')
    df["Stop Time (UTCG)"]= pd.to_datetime(df["Stop Time (UTCG)"], format ='%d %b %Y %H:%M:%S.%f')
    df["Start Time (UTCG)"]= pd.to_datetime(df["Start Time (UTCG)"], format ='%d %b %Y %H:%M:%S.%f')
    start_time= df["Start Time (UTCG)"].iloc[0]
    df["Time from mission start (s)"] = (df["Start Time (UTCG)"]- start_time).dt.total_seconds()
    return df

def extract_true_ephem(folder, satellite):
    '''
    Function to retrieve true ephemeris generated from STK astrogator, with a time stamp referencing mission start
    '''
    filename=f'{folder}\\{satellite}_astrogator RIC.csv'
    df = pd.read_table(filename, delimiter=',')
    df["Time (UTCG)"]= pd.to_datetime(df["Time (UTCG)"], format ='%d %b %Y %H:%M:%S.%f')
    start_time= df["Time (UTCG)"].iloc[0]
    df["Time from mission start (s)"] = (df["Time (UTCG)"]- start_time).dt.total_seconds()
    return df

flag = 0 # Set 1 for normal operation, set 0 for case when plotting ground truth inertial at ignition. 
for satellite in satellites:
    if flag == 1:
        output_folder = "Processed_data"
        file, segment_duration = extract_time_schedule(satellite)
        file.to_csv(f"{output_folder}/{satellite}_time_schedule.csv")
        ground_truth = extract_true_ephem(os.getcwd(), satellite)
        ground_truth.to_csv(f"{output_folder}/{satellite}_ground_truth.csv")
    
    elif flag == 0:
        input_folder = "Inertial_at_ignition"
        output_folder = "Inertial_at_ignition"
        ground_truth = extract_true_ephem(input_folder, satellite)
        ground_truth.to_csv(f"{output_folder}/{satellite}_ground_truth.csv")
    #maneuver_data = process_maneuver_data(satellite)
    #maneuver_data.to_csv(f"Processed_data/{satellite}_overall_man_summary.csv")
    