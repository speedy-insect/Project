function vehicleData = recordSensorData(scenario, vehicleData, currentTime)
    % Get the list of vehicles in the scenario
    vehicles = scenario.Actors;
    
    for i = 1:length(vehicles)
        % Get vehicle data
        vehicle = vehicles(i);
        dataEntry = struct(...
            'VehicleID', vehicle.Name, ...
            'Timestamp', currentTime, ...
            'Position', vehicle.Position, ...
            'Velocity', vehicle.Velocity);
        
        % Append to vehicleData array
        if isempty(vehicleData)
            vehicleData = dataEntry;
        else
            vehicleData(end+1) = dataEntry;
        end
    end
end
