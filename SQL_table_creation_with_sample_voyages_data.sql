CREATE TABLE voyages (
    id INT,
    event VARCHAR(50),
    dateStamp INT,
    timeStamp FLOAT,
    voyage_From VARCHAR(50),
    lat DECIMAL(9,6),
    lon DECIMAL(9,6),
    imo_num VARCHAR(20),
    voyage_Id VARCHAR(20),
    allocatedVoyageId VARCHAR(20)
);

INSERT INTO voyages VALUES
(1, 'SOSP', 43831, 0.708333, 'Port A', 34.0522, -118.2437, '9434761', '6', NULL),
(2, 'EOSP', 43832, 0.333333, 'Port B', 36.7783, -119.4179, '9434761', '6', NULL),
(3, 'SOSP', 43832, 0.583333, 'Port B', 36.7783, -119.4179, '9434761', '6', NULL),
(4, 'EOSP', 43833, 0.250000, 'Port C', 37.7749, -122.4194, '9434761', '6', NULL),
(5, 'SOSP', 43833, 0.666667, 'Port C', 37.7749, -122.4194, '9434761', '6', NULL),
(6, 'EOSP', 43834, 0.500000, 'Port D', 34.0522, -118.2437, '9434761', '6', NULL),
(7, 'SOSP', 43834, 0.750000, 'Port D', 34.0522, -118.2437, '9434761', '6', NULL),
(8, 'EOSP', 43835, 0.250000, 'Port E', 32.7157, -117.1611, '9434761', '6', NULL),
(9, 'SOSP', 43835, 0.583333, 'Port E', 32.7157, -117.1611, '9434761', '6', NULL),
(10, 'EOSP', 43836, 0.300000, 'Port F', 29.7604, -95.3698, '9434761', '6', NULL),
(11, 'SOSP', 43836, 0.700000, 'Port F', 29.7604, -95.3698, '9434761', '6', NULL),
(12, 'EOSP', 43837, 0.500000, 'Port G', 25.7617, -80.1918, '9434761', '6', NULL),
(13, 'SOSP', 43837, 0.750000, 'Port G', 25.7617, -80.1918, '9434761', '6', NULL),
(14, 'EOSP', 43838, 0.583333, 'Port H', 40.7128, -74.0060, '9434761', '6', NULL),
(15, 'SOSP', 43839, 0.300000, 'Port H', 40.7128, -74.0060, '9434761', '6', NULL),
(16, 'EOSP', 43839, 0.700000, 'Port I', 48.8566, 2.3522, '9434761', '6', NULL),
(17, 'SOSP', 43840, 0.500000, 'Port I', 48.8566, 2.3522, '9434761', '6', NULL),
(18, 'EOSP', 43840, 0.750000, 'Port J', 51.5074, -0.1278, '9434761', '6', NULL),
(19, 'SOSP', 43841, 0.250000, 'Port J', 51.5074, -0.1278, '9434761', '6', NULL),
(20, 'EOSP', 43841, 0.583333, 'Port K', 35.6895, 139.6917, '9434761', '6', NULL);
