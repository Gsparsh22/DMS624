CREATE TABLE Languages (
    code CHAR(2) PRIMARY KEY,
    language_name VARCHAR(255) NOT NULL
);

CREATE TABLE Corporations (
    corporation_id INT PRIMARY KEY AUTO_INCREMENT,
    corporation_name VARCHAR(255) NOT NULL,
    corporation_url VARCHAR(255) NOT NULL CHECK (corporation_url LIKE 'http://%' OR corporation_url LIKE 'https://%');
    language_code CHAR(2),
    corporation_phone VARCHAR(15),
    FOREIGN KEY (language_code) REFERENCES Languages(code)
);


CREATE TABLE Stops (
    stop_id INT PRIMARY KEY AUTO_INCREMENT,
    stop_code VARCHAR(50) UNIQUE,
    stop_name VARCHAR(255) NOT NULL,
    stop_description TEXT,
    latitude DECIMAL(10, 8) CHECK (latitude BETWEEN -90 AND 90),
    longitude DECIMAL(11, 8) CHECK (longitude BETWEEN -180 AND 180),
    fare_zone_id INT,
    stop_url VARCHAR(255) NOT NULL CHECK (stop_url LIKE 'http://%' OR stop_url LIKE 'https://%')
    stop_type TINYINT CHECK (stop_type IN (0, 1))
);


CREATE TABLE Routes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    corporation_id INT,
    short_route_name VARCHAR(50) DEFAULT '',
    complete_route_name VARCHAR(255) NOT NULL,
    route_description TEXT,
    route_type TINYINT CHECK (route_type BETWEEN 0 AND 4),
    route_url VARCHAR(255) CHECK (route_url LIKE 'http%'),
    route_color CHAR(6) CHECK (route_color REGEXP '^[0-9A-Fa-f]{6}$'),
    FOREIGN KEY (corporation_id) REFERENCES Corporations(corporation_id)
);


CREATE TABLE Trips (
    trip_id INT PRIMARY KEY AUTO_INCREMENT,
    service_id INT NOT NULL,
    route_id INT NOT NULL,
    trip_headsign VARCHAR(255) NOT NULL,
    trip_short_name VARCHAR(50),
    direction_id TINYINT CHECK (direction_id IN (0, 1)),
    block_id INT,
    FOREIGN KEY (service_id) REFERENCES Services(service_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);


CREATE TABLE Stop_Times (
    stop_time_id INT PRIMARY KEY AUTO_INCREMENT,
    trip_id INT NOT NULL,
    stop_id INT NOT NULL,
    arrival_time TIME NULL,
    departure_time TIME NULL,
    stop_sequence INT NOT NULL CHECK (stop_sequence >= 0),
    pickup_type TINYINT CHECK (pickup_type IN (0, 1)),
    drop_off_type TINYINT CHECK (drop_off_type IN (0, 1)),
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id),
    FOREIGN KEY (stop_id) REFERENCES Stops(stop_id)
);


CREATE TABLE Calendar (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    monday TINYINT NOT NULL CHECK (monday IN (0, 1)),
    tuesday TINYINT NOT NULL CHECK (tuesday IN (0, 1)),
    wednesday TINYINT NOT NULL CHECK (wednesday IN (0, 1)),
    thursday TINYINT NOT NULL CHECK (thursday IN (0, 1)),
    friday TINYINT NOT NULL CHECK (friday IN (0, 1)),
    saturday TINYINT NOT NULL CHECK (saturday IN (0, 1)),
    sunday TINYINT NOT NULL CHECK (sunday IN (0, 1)),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);


CREATE TABLE ServiceDates (
    service_date_id INT PRIMARY KEY AUTO_INCREMENT,
    service_id INT NOT NULL,
    date DATE NOT NULL,
    exception_type TINYINT NOT NULL CHECK (exception_type IN (1, 2)),
    UNIQUE (service_id, date),
    FOREIGN KEY (service_id) REFERENCES Calendar(service_id) ON DELETE CASCADE
);


CREATE TABLE Fares (
    fare_id INT PRIMARY KEY AUTO_INCREMENT,
    price DECIMAL(10, 2) NOT NULL,
    currency_type CHAR(3) NOT NULL CHECK (LENGTH(currency_type) = 3),
    payment_method TINYINT NOT NULL CHECK (payment_method IN (0, 1)),
    transfers TINYINT NOT NULL CHECK (transfers IN (0, 1, 2))
);


CREATE TABLE FareRules (
    fare_id INT,
    route_id INT,
    origin_id INT,
    destination_id INT,
    PRIMARY KEY (fare_id, route_id, origin_id, destination_id),
    FOREIGN KEY (fare_id) REFERENCES Fares(fare_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    FOREIGN KEY (origin_id) REFERENCES Stops(stop_id),
    FOREIGN KEY (destination_id) REFERENCES Stops(stop_id)
);
