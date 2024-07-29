% Main simulation script
% Set simulation parameters
simulationTime = 300; % 5 minutes in seconds
timeStep = 0.1; % Time step in seconds
currentTime = 0;

% Create scenario and get spawn points
[scenario, spawnPoints] = createDrivingScenario();

% Initialize data storage
vehicleData = [];
vehicleID = 0;

% Create a figure for the visualization
hFig = figure('Name', 'Traffic Simulation', 'NumberTitle', 'off');
hAx = axes('Parent', hFig);
plot(scenario, 'Parent', hAx);

% Main simulation loop
while currentTime < simulationTime && ishandle(hFig)
    % Spawn vehicles probabilistically
    if rand < 0.1 % Example probability
        vehicleID = vehicleID + 1;
        spawnVehicle(scenario, vehicleID, spawnPoints);
    end
    
    % Update vehicle movements
    updateVehicleMovements(scenario, currentTime);
    
    % Update traffic lights
    updateTrafficLights(scenario, currentTime);
    
    % Record sensor data
    vehicleData = recordSensorData(scenario, vehicleData, currentTime);
    
    % Advance scenario simulation
    advance(scenario);
    
    % Update the plot
    plot(scenario, 'Parent', hAx);
    drawnow;
    
    % Increment time
    currentTime = currentTime + timeStep;
end

% Export data to CSV
exportDataToCSV(vehicleData);
