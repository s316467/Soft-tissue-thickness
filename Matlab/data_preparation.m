

function [all_ages_bmi, all_genders_bmi, all_bmi, all_data_bmi_clean, all_data_clean, all_ages, all_genders, landmark_names, all_data_bmi, all_data]=data_preparation()
    
    % Load data from CSV file
    patients = readtable('information/INFOclinical_HN_Version2_30may2018_Metadata.csv', 'VariableNamingRule', 'preserve');
    olivetti_patients = readtable('information/elenco_soggetti_operazioni_olivetti.xlsx', 'VariableNamingRule','preserve');
    folder_path = {'chum/', 'hmr/', 'hgj/', 'chus/'};

    
    all_files_patients = struct('folder', {}, 'name', {}, 'date', {}, 'bytes', {}, 'isdir', {}, 'datenum', {});
    
    % Loop through each folder path
    for i = 1:length(folder_path)
        % Trova i file .csv nella cartella corrente
        files_patients = dir(fullfile(folder_path{i}, '*.csv'));
        all_files_patients = [all_files_patients; files_patients];
    end
    
    
    files_patients = all_files_patients;
    files_olivetti = dir(fullfile('olivetti/','*.csv'));
    
    
    landmark_names = {'Glabella', 'Nasion', ...
                          'Orbital Right', 'Orbital Left', ...
                          'Superius Right', 'Superius Left', ...
                          'Zygion Right', 'Zygion Left', ...
                          'Rhinion','Midphiltrum'};
    
    % Initialize tables for mean, standard deviation, and correlation coefficient
    age_categories = {'Under 25'; '25-60'; 'Over 60'};
    gender_categories={'M';'F'};
    
    
    men_table=table();
    women_table=table();
    
    for hospital_id=1:length(folder_path)
    
        files_patients = dir(fullfile(folder_path{hospital_id}, '*.csv'));
    
        [men_table, women_table]=hospital_mean(patients,files_patients, folder_path{hospital_id},...
        hospital_id, men_table, women_table);
        
       
    end
    
    
    
    [men_bmi_table,women_bmi_table, women_table, men_table] = olivetti_mean (files_olivetti, olivetti_patients, ...
        women_table, men_table);
    
    
    
    %%%%%%%%%%%%%%%%%%%%% for bmi analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    genders_bmi_women = table2array(women_bmi_table(:, 'Sex'));
    ages_bmi_women = table2array(women_bmi_table(:, 'AgeCategory'));
    bmi_women = table2array(women_bmi_table(:, 'BMI'));
    bmi_landmarks_women = (table2array(women_bmi_table(:,"Soft Tissue Thickness")))';
    
    genders_bmi_men = table2array(men_bmi_table(:, 'Sex'));
    ages_bmi_men = table2array(men_bmi_table(:, 'AgeCategory'));
    bmi_men = table2array(men_bmi_table(:, 'BMI'));
    bmi_landmarks_men = (table2array(men_bmi_table(:,"Soft Tissue Thickness")))';
    
    %%%%%%%%%%%%%%%%%%%%% for age and gender analysis %%%%%%%%%%%%%%%%%%%%%%%
    genders_women = table2array(women_table(:,'Sex'));
    genders_men = table2array(men_table(:,'Sex'));
    ages_women = table2array(women_table(:,'AgeCategory'));
    ages_men = table2array(men_table(:,'AgeCategory'));
    landmark_women = table2array(women_table(:,"Soft Tissue Thickness"));
    landmark_men = table2array(men_table(:,"Soft Tissue Thickness"));
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%% for bmi analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    all_data_bmi = [bmi_landmarks_men, bmi_landmarks_women];
    all_genders_bmi = [genders_bmi_men', genders_bmi_women' ];
    all_ages_bmi = [ages_bmi_men', ages_bmi_women'];
    all_bmi = [bmi_men', bmi_women'];
    
    
    %%%%%%%%%%%%%%%%%%%% for gender and age analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    all_data = [landmark_men', landmark_women'];
    all_genders = [genders_men', genders_women'];
    all_ages = [ages_men', ages_women'];
    
    
    %%%%%%%%%%%%%%%%%%%%% mapping for bmi analysis %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    gender_mapping = containers.Map({'M', 'F'}, {1, 2});
    all_genders_bmi = cellfun(@(x) gender_mapping(x), all_genders_bmi);
    all_genders_bmi = categorical(all_genders_bmi, [1 2], {'1', '2'});
    
    age_mapping = containers.Map({'Under 24', '24-29', 'Over 29'}, {1, 2, 3});
    all_ages_bmi = cellfun(@(x) age_mapping(x), all_ages_bmi);
    all_ages_bmi = categorical(all_ages_bmi, [1 2 3], {'1', '2', '3'});
    
    
    % Convert 'all_bmi' into a categorical vector
    all_bmi = categorical(all_bmi);
    
    % Create a mapping dictionary
    bmi_mapping = containers.Map({'Underweight', 'Normal weight', 'Overweight', 'Obese'}, {1, 2, 3, 4});
    
    % Apply the mapping to your categorical vector
    all_bmi = cellfun(@(x) bmi_mapping(x), cellstr(all_bmi));
    
    
    %%%%%%%%%%%%%%% mapping for age and category analysis %%%%%%%%%%%%
    
    %genders mapping is the same
    
    all_genders = cellfun(@(x) gender_mapping(x), all_genders);
    
    age_mapping = containers.Map({'Under 25', '25-60', 'Over 60'}, {1, 2, 3});
    all_ages = cellfun(@(x) age_mapping(x), all_ages);
    all_ages = categorical(all_ages, [1 2 3], {'1', '2', '3'});
    
    
    %%%%%%%%%%%%%%% randomize for bmi analysis %%%%%%%%%%%%%%%%%%%
    
    
    % Generate a vector of random indices
    num_patients = size(all_data_bmi, 2);
    rand_indices = randperm(num_patients);
    
    % Apply permutation to all data
    
    all_data_bmi = all_data_bmi(:, rand_indices);
    all_ages_bmi = all_ages_bmi(rand_indices);
    all_genders_bmi = all_genders_bmi(rand_indices);
    all_bmi=all_bmi(rand_indices);
    
    
    
    %%%%%%%%%%%%%% randomize for age and gender analysis %%%%%%%%%%%%
    
    % Generate a vector of random indices
    num_patients = size(all_data, 2);
    rand_indices = randperm(num_patients);
    
    % Apply permutation to all data
    
    all_data = all_data(:, rand_indices);
    all_ages = all_ages(rand_indices);
    all_genders = all_genders(rand_indices);
    
    
    %%%%%%%%%%%%%%%% removing outlier for bmi analysis %%%%%%%%%%%%%%
    
    all_data_bmi_clean = [];
    
    
    for i = 1:size(all_data_bmi, 1)
    
        row = all_data_bmi(i, :);
        outliers = isoutlier(row, 'quartiles');
        row(outliers) = NaN;
        all_data_bmi_clean = [all_data_bmi_clean; row];
    end
    
    
    %%%%%%%%% removing outlier for age and gender analysis %%%%%%%%%%%%%%
    
    
    
    all_data_clean = [];
    
    
    for i = 1:size(all_data, 1)
    
        row = all_data(i, :);
        % find the outlier using rmoutliers
        outliers = isoutlier(row, 'quartiles');
        % set the outliers to NaN
        row(outliers) = NaN;
        all_data_clean = [all_data_clean; row];
    end
    
    
    
    
    my_plot.plot_distances(all_data, all_genders, all_ages, landmark_names, 'before cleaning');
    my_plot.plot_distances(all_data_clean, all_genders, all_ages, landmark_names, 'after cleaning');
    my_plot.plot_distances_bmi (all_data_bmi, all_genders_bmi, all_ages_bmi, all_bmi, landmark_names,'before cleaning');
    my_plot.plot_distances_bmi (all_data_bmi_clean, all_genders_bmi, all_ages_bmi, all_bmi, landmark_names,'after cleaning');



end