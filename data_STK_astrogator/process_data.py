# -*- coding: utf-8 -*-
"""
Created on Fri Jan  7 10:55:24 2022

@author: Andrew
"""

import pandas as pd

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


for satellite in satellites:
    file, segment_duration = extract_time_schedule(satellite)
    file.to_csv(f"Processed_data/{satellite}_time_schedule.csv")
    #maneuver_data = process_maneuver_data(satellite)
    #maneuver_data.to_csv(f"Processed_data/{satellite}_overall_man_summary.csv")
    