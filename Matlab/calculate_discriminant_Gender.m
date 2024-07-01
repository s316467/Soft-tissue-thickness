clear all;

% Load data from CSV files
patients = readtable('information/INFOclinical_HN_Version2_30may2018_Metadata.csv', 'VariableNamingRule', 'preserve');
olivetti_patients = readtable('information/elenco_soggetti_operazioni_olivetti.xlsx', 'VariableNamingRule','preserve');
folder_path = 'hmr/distances/';

files_patients = dir(fullfile(folder_path, '*.csv'));
files_olivetti = dir(fullfile('olivetti/','*.csv'));



% Mapping
hmr_patient_id_mapping = containers.Map(...
    {'hmr_001_landmark', 'hmr_002_landmark', 'hmr_003_landmark', 'hmr_004_landmark', ...
     'hmr_005_landmark', 'hmr_006_landmark', 'hmr_007_landmark', 'hmr_008_landmark', ...
     'hmr_019_landmark', 'hmr_027_landmark'}, ...
    {'HN-HMR-001', 'HN-HMR-002', 'HN-HMR-003', 'HN-HMR-004', ...
     'HN-HMR-005', 'HN-HMR-006', 'HN-HMR-007', 'HN-HMR-008', ...
     'HN-HMR-019', 'HN-HMR-027'});

olivetti_patient_id_mapping = containers.Map (...
    { 'soggetto_007_landmark', 'soggetto_008_landmark', 'soggetto_009_landmark'}, ...
    { 'S7','S8','S9' });

landmark_names = {'Glabella', 'Nasion', ...
                      'Orbital Right', 'Orbital Left', ...
                      'Superius Right', 'Superius Left', ...
                      'Zygion Right', 'Zygion Left', ...
                      'Rhinion','Mid-Philtrum (A-Point)'};

% Initialize tables for mean, standard deviation, and correlation coefficient
men_mean =  table(landmark_names', zeros(10,1), zeros(10,1), zeros(10,1), zeros(10,1), zeros(10,1), 'VariableNames', {'Landmark',  'Num Patients', 'Age', 'Mean (mm)', 'Std Dev (mm)', 'Correlation Coefficient'});
women_mean = table(landmark_names', zeros(10,1), zeros(10,1),zeros(10,1), zeros(10,1), zeros(10,1),'VariableNames', {'Landmark', 'Num Patients', 'Age', 'Mean (mm)', 'Std Dev (mm)', 'Correlation Coefficient'});

men_data_hn = zeros(length(landmark_names), length(files_patients));
women_data_hn = zeros(length(landmark_names), length(files_patients));

% Process patient data files
for i = 1:length(files_patients)
    file_path = fullfile(folder_path, files_patients(i).name);
    % Read CSV file
    patient_landmark = readtable(file_path);
    name_id = strsplit(files_patients(i).name, '.');
    name_id = name_id{1};
    patient_id = hmr_patient_id_mapping(name_id);
    patient = patients(strcmp(patients{:, 'Patient #'}, patient_id) == 1, :);
    if (patient.Age<30)
        age = 'Under 30';
    end
    if (patient.Age >=30 & patient.Age <50)
        age = '30-50'
    end
    if (patient.Age >=50)
        age= 'Over 50'
    end
    if (strcmp(patient.Sex, 'M'))
        men_data_hn(:, i) = patient_landmark.Distance_mm;
        men_mean.("Num Patients") = men_mean.("Num Patients") + 1;
    end
    if (strcmp(patient.Sex, 'F'))
        women_data_hn(:, i) = patient_landmark.Distance_mm;
        women_mean.("Num Patients") = women_mean.("Num Patients") + 1;
    end
end

men_data = zeros(length(landmark_names), length(files_olivetti));
women_data = zeros(length(landmark_names), length(files_olivetti));

% Process Olivetti patient data files
for i = 1:length(files_olivetti)
    file_path = fullfile('olivetti/', files_olivetti(i).name);
    % Read CSV file
    patient_landmark = readtable(file_path);
    name_id = strsplit(files_olivetti(i).name, '.');
    name_id = name_id{1};
    patient_id = olivetti_patient_id_mapping(name_id);
    patient = olivetti_patients(strcmp(olivetti_patients{:, 'Pazienti'}, patient_id) == 1, :);
    if (patient.("età")<30)
        age = 'Under 30';
    end
    if (patient.("età") >=30 & patient.("età") <50)
        age = '30-50'
    end
    if (patient.("età") >=50)
        age= 'Over 50'
    end
    if (strcmp(patient.sesso, 'M'))
        men_data(:, i) = patient_landmark.Distance_mm;
        
        men_mean.("Num Patients") = men_mean.("Num Patients") + 1;
    end
    if (strcmp(patient.sesso, 'F'))
        women_data(:, i) = patient_landmark.Distance_mm;
        women_mean.("Num Patients") = women_mean.("Num Patients") + 1;
    end
end

% Combine data for men and women
men_combinated = [men_data_hn, men_data];
women_combinated = [women_data_hn, women_data];

men = zeros(length(landmark_names), men_mean.("Num Patients")(1));
women = zeros(length(landmark_names), women_mean.("Num Patients")(1));

% Assign non-zero values to matrices men and women
for i = 1:length(landmark_names)
    filtered_matrix_men = men_combinated(i, men_combinated(i,:) ~= 0);
    filtered_matrix_women = women_combinated(i, women_combinated(i,:) ~= 0);

    men(i, :) = filtered_matrix_men;
    women(i, :) = filtered_matrix_women;
end

% Calculate standard deviation and mean for men and women
for i = 1:length(men_mean.Landmark)
    men_mean.("Std Dev (mm)")(i) = std(men(i, :));
    men_mean.("Mean (mm)")(i) = mean(men(i, :));
    [~, p_value] = ttest2(men(i, men(i, :) ~= 0), women(i, women(i, :) ~= 0));
    men_mean.("Correlation Coefficient")(i) = p_value;
end

for i = 1:length(women_mean.Landmark)
    women_mean.("Std Dev (mm)")(i) = std(women(i, :));
    women_mean.("Mean (mm)")(i) = mean(women(i, :));
    [~, p_value] = ttest2(men(i, men(i, :) ~= 0), women(i, women(i, :) ~= 0));
    women_mean.("Correlation Coefficient")(i) = p_value;
end

% Plot bar chart of mean distances between men and women for each landmark
figure;
bar(1:length(landmark_names), [men_mean.("Mean (mm)"), women_mean.("Mean (mm)")], 'grouped');
xticks(1:length(landmark_names));
xticklabels(landmark_names);
xlabel('Landmark');
ylabel('Average Distance (mm)');
title('Average Distances between Men and Women for Each Landmark');
legend('Men', 'Women');
xtickangle(45);
grid on;

% Example: ROC curves calculation for all landmarks and visualization of AUC
AUC_values = zeros(length(landmark_names), 1);
landmark_labels = cell(length(landmark_names), 1);

for landmark_index = 1:length(landmark_names)
    distances_men = men(landmark_index, men(landmark_index, :) ~= 0);
    distances_women = women(landmark_index, women(landmark_index, :) ~= 0);
   
    [X,Y,~,AUC] = perfcurve([ones(size(distances_men,2),1); 2*ones(size(distances_women,2),1)], [distances_men distances_women], 1);
    
    AUC_values(landmark_index) = AUC;
    landmark_labels{landmark_index} = landmark_names{landmark_index};
    
    fprintf('Landmark "%s": AUC = %.2f\n', landmark_names{landmark_index}, AUC);
end

% Plot AUC values for each landmark
figure;
plot(AUC_values, 'o-', 'LineWidth', 1.5);
grid on;
xlabel('Landmark');
ylabel('AUC');
title('AUC per Landmark - Discrimination between Men and Women');
xticks(1:length(landmark_names));
xticklabels(landmark_labels);
xtickangle(45);

% Label points with AUC values
for i = 1:length(landmark_names)
    text(i, AUC_values(i), sprintf('%.2f', AUC_values(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
