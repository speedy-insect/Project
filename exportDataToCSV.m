function exportDataToCSV(vehicleData)
    % Convert structure array to table
    dataTable = struct2table(vehicleData);
    
    % Write table to CSV file
    writetable(dataTable, 'vehicleData.csv');
end
