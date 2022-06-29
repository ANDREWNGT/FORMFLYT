# -*- coding: utf-8 -*-
"""
Created on Thu Jun 23 10:32:31 2022

@author: ngengton
"""

import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime
import os 
altitudes = ["547km", "585km"]
vehicles = ["lum_2", "lum_3"]
def plot_cum_sum_over_time(files, vehicles, altitude): 
    fig, ax = plt.subplots(2, 1, figsize = (19.2, 10.8))
    plt. subplots_adjust(hspace = 0.5) 
    for file in enumerate(files): 
        df = pd.read_csv(file[1])
        
        mission_start = then = datetime(2020, 1, 11, 1) # Start epoch 11 Jan 2020 00:00:00
        time_diff = pd.to_datetime(df[['Year', 'Month', 'Day', 'Hour']]) - mission_start
        df["Time elapsed (Days)"] = time_diff.dt.total_seconds()/86400
        
        df["Cum_del_v (m/s)"] = df["Delta-v (m/s)"].cumsum()
       
 
        ax[file[0]].plot(df["Time elapsed (Days)"], df["Cum_del_v (m/s)"])
        ax[file[0]].grid("both")
        ax[file[0]].set_xlabel("Days since maintenance start", fontsize = 15)
        ax[file[0]].set_ylabel("Cumulative Delta V (m/s)", fontsize = 15)
        ax[file[0]].tick_params(axis='both', labelsize=10)
        ax[file[0]].set_title(f"{vehicles[file[0]]}, {altitude}", fontsize = 15)
        
        ax[file[0]].set_ylim([0, 5])
        ax[file[0]].set_xlim([0, 200])
    plt.savefig(f"maintenance_{altitude}.png")
     
for altitude in altitudes:      
    files = [os.path.join(altitude, f"{vehicles[0]}.csv"), os.path.join(altitude, f"{vehicles[1]}.csv")]
    
    plot_cum_sum_over_time(files, vehicles, altitude)
 
