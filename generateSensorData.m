function [allData, scenario, sensor] = generateSensorData()
%generateSensorData - Returns sensor detections
%    allData = generateSensorData returns sensor detections in a structure
%    with time for an internally defined scenario and sensor suite.
%
%    [allData, scenario, sensors] = generateSensorData optionally returns
%    the drivingScenario and detection generator objects.

% Create the drivingScenario object and ego car
[scenario, egoVehicle] = createDrivingScenario();

% Create all the sensors
sensor = createSensor(scenario);

allData = struct('Time', {}, 'ActorPoses', {}, 'ObjectDetections', {}, 'LaneDetections', {}, 'PointClouds', {}, 'INSMeasurements', {});
% Generate the target poses of all actors relative to the ego vehicle
poses = targetPoses(egoVehicle);
time  = scenario.SimulationTime;

% Generate detections for the sensor
laneDetections = [];
ptClouds = [];
insMeas = [];
[objectDetections, numObjects, isValidTime] = sensor(poses, time);
objectDetections = objectDetections(1:numObjects);

% Aggregate all detections into a structure for later use
if isValidTime
    allData(end + 1) = struct( ...
        'Time',       scenario.SimulationTime, ...
        'ActorPoses', actorPoses(scenario), ...
        'ObjectDetections', {objectDetections}, ...
        'LaneDetections', {laneDetections}, ...
        'PointClouds',   {ptClouds}, ...
        'INSMeasurements',   {insMeas});
end

% Release the sensor object so it can be used again.
release(sensor);

end

%%%%%%%%%%%%%%%%%%%%
% Helper functions %
%%%%%%%%%%%%%%%%%%%%

function sensor = createSensor(scenario)
% createSensors Returns all sensor objects to generate detections

% Assign into each sensor the physical and radar profiles for all actors
profiles = actorProfiles(scenario);
sensor = drivingRadarDataGenerator('SensorIndex', 1, ...
    'MountingLocation', [3.7 0 0.2], ...
    'RangeLimits', [0 100], ...
    'TargetReportFormat', 'Detections', ...
    'Profiles', profiles);
end

function [scenario, egoVehicle] = createDrivingScenario()
% createDrivingScenario Returns the drivingScenario defined in the Designer

% Construct a drivingScenario object.
scenario = drivingScenario;

% Add all road segments
roadCenters = [57.2 0 0;
    -7.7 0 0];
laneSpecification = lanespec(2);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road');

roadCenters = [29 -32.2 0;
    28.9 33.2 0];
laneSpecification = lanespec(2);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road1');

% Add the ego vehicle
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [57 -1.7 0], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car');

% Add the non-ego actors
vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [-7.5 2.4 0], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car1');

vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [30.7 33.6 0], ...
    'Yaw', 90, ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car2');

vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [26.6333333333333 -32.5 0], ...
    'Yaw', -90, ...
    'Mesh', driving.scenario.carMesh, ...
    'PlotColor', [128 128 128] / 255, ...
    'Name', 'Car3');
end
