% Load data
data = csvread('roaddata.csv'); % Assuming columns: Address, Latitude, Longitude, OrderTime
addresses = data(:, 1);
latitudes = data(:, 2);
longitudes = data(:, 3);
order_times = data(:, 4);

% Handle missing values
data = data(~any(isnan(data), 2), :);

% Function to calculate the Haversine distance between two coordinates
function d = haversine(lat1, lon1, lat2, lon2)
    R = 6371; % Earth radius in km
    dlat = deg2rad(lat2 - lat1);
    dlon = deg2rad(lon2 - lon1);
    a = sin(dlat/2)^2 + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dlon/2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    d = R * c;
end

% Calculate the distance matrix
num_locations = length(latitudes);
distance_matrix = zeros(num_locations);

for i = 1:num_locations
    for j = 1:num_locations
        if i ~= j
            distance_matrix(i, j) = haversine(latitudes(i), longitudes(i), latitudes(j), longitudes(j));
        end
    end
end

% Save the distance matrix
csvwrite('distance_matrix.csv', distance_matrix);

% Load historical traffic data (if available)
traffic_data = csvread('traffic_data.csv');

% Adjust distance matrix based on traffic data
for i = 1:num_locations
    for j = 1:num_locations
        if i ~= j
            delay = mean(traffic_data(traffic_data(:, 2) == latitudes(i) & traffic_data(:, 3) == longitudes(i) & ...
                                     traffic_data(:, 4) == latitudes(j) & traffic_data(:, 5) == longitudes(j), 6));
            distance_matrix(i, j) = distance_matrix(i, j) + delay;
        end
    end
end

% Save the adjusted distance matrix
csvwrite('distance_matrix_with_traffic.csv', distance_matrix);

% Nearest Neighbor Algorithm
function route = nearest_neighbor(distance_matrix, start_point)
    num_locations = size(distance_matrix, 1);
    unvisited = 1:num_locations;
    unvisited(start_point) = [];
    route = start_point;
    current = start_point;

    while ~isempty(unvisited)
        [~, nearest] = min(distance_matrix(current, unvisited));
        current = unvisited(nearest);
        route = [route, current];
        unvisited(nearest) = [];
    end
end

% Example usage of Nearest Neighbor
start_point = 1; % Starting from the first location
route = nearest_neighbor(distance_matrix, start_point);

% Visualization
function plot_route(latitudes, longitudes, route)
    figure;
    geoplot(latitudes(route), longitudes(route), '-o');
    title('Optimized Delivery Route');
    xlabel('Latitude');
    ylabel('Longitude');
    grid on;
end

% Plot the optimized route
plot_route(latitudes, longitudes, route);

