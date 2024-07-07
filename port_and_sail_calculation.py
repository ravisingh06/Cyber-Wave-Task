import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from geopy.distance import geodesic
import matplotlib.pyplot as plt

# Load the data
df = pd.read_csv('sample_voyages_data.csv')

# Convert dateStamp and timeStamp to datetime
df['event_datetime'] = pd.to_datetime('1970-01-01') + pd.to_timedelta(df['dateStamp'], unit='D') + pd.to_timedelta(df['timeStamp'] * 86400, unit='s')

# Exclude records with non-null `allocatedVoyageId`
df_filtered = df[df['allocatedVoyageId'].isnull()]

# Sort data by event_datetime
df_filtered = df_filtered.sort_values(by='event_datetime').reset_index(drop=True)
# Calculate time durations between key events
df_filtered['prev_event_datetime'] = df_filtered['event_datetime'].shift(1)
df_filtered['time_difference_hours'] = (df_filtered['event_datetime'] - df_filtered['prev_event_datetime']).dt.total_seconds() / 3600

# Calculate distance between consecutive ports
df_filtered['prev_lat'] = df_filtered['lat'].shift(1)
df_filtered['prev_lon'] = df_filtered['lon'].shift(1)

def calculate_distance(row):
    if pd.isnull(row['prev_lat']) or pd.isnull(row['prev_lon']):
        return np.nan
    return geodesic((row['lat'], row['lon']), (row['prev_lat'], row['prev_lon'])).nautical

df_filtered['distance_travelled'] = df_filtered.apply(calculate_distance, axis=1)
# Segment different voyage stages and calculate sailing time and port stay duration
df_filtered['sailing_time'] = df_filtered.apply(lambda row: row['time_difference_hours'] if row['event'] == 'SOSP' else np.nan, axis=1)
df_filtered['port_stay_duration'] = df_filtered.apply(lambda row: row['time_difference_hours'] if row['event'] == 'EOSP' else np.nan, axis=1)

# Calculate cumulative sailing time and time spent at ports
df_filtered['cumulative_sailing_time'] = df_filtered['sailing_time'].cumsum()
df_filtered['cumulative_port_time'] = df_filtered['port_stay_duration'].cumsum()

# Fill NaN values with 0 for cumulative sums
df_filtered['cumulative_sailing_time'] = df_filtered['cumulative_sailing_time'].fillna(0)
df_filtered['cumulative_port_time'] = df_filtered['cumulative_port_time'].fillna(0)

# Select and order relevant columns
df_result = df_filtered[['id', 'event', 'event_datetime', 'voyage_From', 'lat', 'lon', 'prev_event_datetime', 'time_difference_hours', 'distance_travelled', 'sailing_time', 'port_stay_duration', 'cumulative_sailing_time', 'cumulative_port_time']]
# Plot the timeline of events
plt.figure(figsize=(15, 10))

# Plot sailing times
sailing_df = df_result[df_result['event'] == 'SOSP']
plt.plot(sailing_df['event_datetime'], sailing_df['cumulative_sailing_time'], label='Cumulative Sailing Time (hours)', marker='o')

# Plot port stay durations
port_df = df_result[df_result['event'] == 'EOSP']
plt.plot(port_df['event_datetime'], port_df['cumulative_port_time'], label='Cumulative Port Time (hours)', marker='x')

# Add labels and legend
plt.xlabel('Event DateTime')
plt.ylabel('Time (hours)')
plt.title('Voyage Timeline')
plt.legend()
plt.grid(True)

plt.show()
