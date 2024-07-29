function updateVehicleMovements(scenario, currentTime)
    % Update the positions of all vehicles in the scenario
    for i = 1:numel(scenario.Actors)
        vehicle = scenario.Actors(i);
        % Simple forward movement
        vehicle.Position(1) = vehicle.Position(1) + 0.1;
    end
end
