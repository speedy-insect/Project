function spawnVehicle(scenario, vehicleID, spawnPoints)
    % Select a random spawn point
    spawnIdx = randi(size(spawnPoints, 1));
    initialPosition = spawnPoints(spawnIdx, :);
    
    % Define vehicle properties
    newVehicle = vehicle(scenario, 'ClassID', 1, 'Position', initialPosition, 'Name', ['Vehicle' num2str(vehicleID)]);
end
