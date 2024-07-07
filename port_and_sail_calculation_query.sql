WITH voyage_data AS (
    SELECT
        id,
        event,
        DATE_ADD('1970-01-01', INTERVAL dateStamp DAY) + INTERVAL ROUND(timeStamp * 86400) SECOND AS event_datetime,
        voyage_From,
        lat,
        lon,
        imo_num,
        voyage_Id,
        allocatedVoyageId
    FROM
        voyages
    WHERE
        imo_num = '9434761' AND
        voyage_Id = '6' AND
        allocatedVoyageId IS NULL
),
voyage_segments AS (
    SELECT
        id,
        event,
        event_datetime,
        voyage_From,
        lat,
        lon,
        LAG(event_datetime) OVER (ORDER BY event_datetime) AS prev_event_datetime,
        LAG(event) OVER (ORDER BY event_datetime) AS prev_event,
        LAG(voyage_From) OVER (ORDER BY event_datetime) AS prev_voyage_From,
        LAG(lat) OVER (ORDER BY event_datetime) AS prev_lat,
        LAG(lon) OVER (ORDER BY event_datetime) AS prev_lon
    FROM
        voyage_data
),
voyage_durations AS (
    SELECT
        id,
        event,
        event_datetime,
        voyage_From,
        lat,
        lon,
        prev_event_datetime,
        prev_event,
        prev_voyage_From,
        prev_lat,
        prev_lon,
        TIMESTAMPDIFF(SECOND, prev_event_datetime, event_datetime) / 3600 AS time_difference_hours,
        2 * 6371 * ASIN(SQRT(
            POWER(SIN(RADIANS(lat - prev_lat) / 2), 2) +
            COS(RADIANS(lat)) * COS(RADIANS(prev_lat)) *
            POWER(SIN(RADIANS(lon - prev_lon) / 2), 2)
        )) * 0.539957 AS distance_travelled_nm -- Convert km to nautical miles
    FROM
        voyage_segments
    WHERE
        prev_event_datetime IS NOT NULL
),
voyage_analysis AS (
    SELECT
        id,
        event,
        event_datetime,
        voyage_From,
        lat,
        lon,
        prev_event_datetime,
        prev_event,
        prev_voyage_From,
        time_difference_hours,
        distance_travelled_nm,
        CASE
            WHEN event = 'SOSP' THEN time_difference_hours
            ELSE NULL
        END AS sailing_time,
        CASE
            WHEN event = 'EOSP' THEN time_difference_hours
            ELSE NULL
        END AS port_stay_duration,
        SUM(CASE WHEN event = 'SOSP' THEN time_difference_hours ELSE 0 END) OVER (ORDER BY event_datetime) AS cumulative_sailing_time,
        SUM(CASE WHEN event = 'EOSP' THEN time_difference_hours ELSE 0 END) OVER (ORDER BY event_datetime) AS cumulative_port_time
    FROM
        voyage_durations
)
SELECT
    id,
    event,
    event_datetime,
    voyage_From,
    lat,
    lon,
    prev_event_datetime,
    prev_event,
    prev_voyage_From,
    time_difference_hours,
    distance_travelled_nm AS distance_travelled,
    sailing_time,
    port_stay_duration,
    cumulative_sailing_time,
    cumulative_port_time
FROM
    voyage_analysis
ORDER BY
    event_datetime;
