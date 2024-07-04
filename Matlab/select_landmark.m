
close all;
clear all;

% Load data from CSV file
patients = readtable('information/INFOclinical_HN_Version2_30may2018_Metadata.csv', 'VariableNamingRule', 'preserve');
olivetti_patients = readtable('information/elenco_soggetti_operazioni_olivetti.xlsx', 'VariableNamingRule','preserve');
folder_path = {'chum/', 'hmr/', 'hgj/'};
% folder_path = {'chum/', 'hmr/', 'hgj/', 'chus/'};

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
                      'Rhinion','Mid-Philtrum (A-Point)'};

% Initialize tables for mean, standard deviation, and correlation coefficient
age_categories = {'Under 30'; '30-50'; 'Over 50'};
gender_categories={'M';'F'};
num_age_categories = length(age_categories);
num_landmarks = length(landmark_names);

% Create cell arrays to store values for each age category
men_mean = cell(num_age_categories, 1);
women_mean = cell(num_age_categories, 1);



for i = 1:num_age_categories
    men_mean{i} = table(landmark_names', zeros(num_landmarks,1), repmat(age_categories(i), num_landmarks, 1), 'VariableNames', {'Landmark', 'Num Patients', 'Age'});
    women_mean{i} = table(landmark_names', zeros(num_landmarks,1), repmat(age_categories(i), num_landmarks, 1),  'VariableNames', {'Landmark', 'Num Patients', 'Age'});
  
end

men_mean = vertcat(men_mean{:});
women_mean = vertcat(women_mean{:});

men_data_hn_u30 = zeros(length(landmark_names), length(files_patients));
women_data_hn_u30 = zeros(length(landmark_names), length(files_patients));
men_data_hn_30_50 = zeros(length(landmark_names), length(files_patients));
women_data_hn_30_50 = zeros(length(landmark_names), length(files_patients));
men_data_hn_o50 = zeros(length(landmark_names), length(files_patients));
women_data_hn_o50 = zeros(length(landmark_names), length(files_patients));


for hospital_id=1:length(folder_path)

    files_patients = dir(fullfile(folder_path{hospital_id}, '*.csv'));
    [men_mean,women_mean, men_data_hn_30_50,men_data_hn_u30, men_data_hn_o50, women_data_hn_30_50, women_data_hn_u30,...
    women_data_hn_o50]=hospital_mean(patients,files_patients, folder_path{hospital_id},...
    men_mean,women_mean, men_data_hn_30_50,men_data_hn_u30, men_data_hn_o50, women_data_hn_30_50, women_data_hn_u30,...
    women_data_hn_o50, hospital_id);
    
   
end

men_data_u30 = zeros(length(landmark_names), length(files_olivetti));
women_data_u30 = zeros(length(landmark_names), length(files_olivetti));
men_data_30_50 = zeros(length(landmark_names), length(files_olivetti));
women_data_30_50 = zeros(length(landmark_names), length(files_olivetti));
men_data_o50 = zeros(length(landmark_names), length(files_olivetti));
women_data_o50 = zeros(length(landmark_names), length(files_olivetti));

[men_data_30_50,...
    men_data_u30,men_data_o50,women_data_30_50, women_data_u30, ...
    women_data_o50,women_mean, men_mean] = olivetti_mean (files_olivetti, olivetti_patients,men_data_30_50,...
    men_data_u30,men_data_o50,women_data_30_50, women_data_u30, ...
    women_data_o50,women_mean, men_mean);


% Combine data for men and women
men_combinated_u30 = [men_data_hn_u30, men_data_u30];
women_combinated_u30 = [women_data_hn_u30, women_data_u30];
men_combinated_o50 = [men_data_hn_o50, men_data_o50];
women_combinated_o50 = [women_data_hn_o50, women_data_o50];
men_combinated_30_50 = [men_data_hn_30_50, men_data_30_50];
women_combinated_30_50 = [women_data_hn_30_50, women_data_30_50];
men_u30 = zeros(length(landmark_names), men_mean.("Num Patients")(1));
women_u30 = zeros(length(landmark_names), women_mean.("Num Patients")(1));
men_30_50 = zeros(length(landmark_names), men_mean.("Num Patients")(11));
women_30_50 = zeros(length(landmark_names), women_mean.("Num Patients")(11));
men_o50 = zeros(length(landmark_names), men_mean.("Num Patients")(21));
women_o50 = zeros(length(landmark_names), women_mean.("Num Patients")(21));


% Assign non-zero values to matrices men and women
for i = 1:length(landmark_names)
    men_u30(i, :)= men_combinated_u30(i, men_combinated_u30(i,:) ~= 0);
    women_u30(i, :) = women_combinated_u30(i, women_combinated_u30(i,:) ~= 0);
end

% Assign non-zero values to matrices men and women
for i = 1:length(landmark_names)
    men_30_50(i, :) = men_combinated_30_50(i, men_combinated_30_50(i,:) ~= 0);
    women_30_50(i, :) = women_combinated_30_50(i, women_combinated_30_50(i,:) ~= 0);
    
end

% Assign non-zero values to matrices men and women
for i = 1:length(landmark_names)
    men_o50(i, :)  = men_combinated_o50(i, men_combinated_o50(i,:) ~= 0);
    women_o50(i, :)  = women_combinated_o50(i, women_combinated_o50(i,:) ~= 0);   
end


gender_u30 = ones(1, size(men_u30, 2)+size(women_u30, 2));  % Indicators for males under 30 years old
gender_u30(:, size(men_u30, 2) + 1 : end) = 2;

gender_30_50 = ones(1, size(men_30_50, 2)+size(women_30_50, 2));
gender_30_50(:, size(men_30_50, 2) + 1 : end) = 2;

gender_o50 = ones(1, size(men_o50, 2)+size(women_o50, 2));
gender_o50(:, size(men_o50, 2) + 1 : end) = 2;


% Merge data to create an overall table
all_data = [men_u30 women_u30, men_30_50 women_30_50, men_o50 women_o50];

% Assign correct values to all_ages
num_patients_u30 = size(men_u30, 2) + size(women_u30, 2);
num_patients_30_50 = size(men_30_50, 2) + size(women_30_50, 2);
num_patients_o50 = size(men_o50, 2) + size(women_o50, 2);

all_ages = [ones(1, num_patients_u30), 2 * ones(1, num_patients_30_50), 3 * ones(1, num_patients_o50)];
all_genders = [gender_u30, gender_30_50, gender_o50];

% Categorical variable transformation
all_genders = categorical(all_genders, [1 2], {'1', '2'});
all_ages = categorical(all_ages, [1 2,3], {'1', '2','3'});


% %%% distances for men and women based on each age category before cleaning
% plot_distances(men_u30,men_30_50, men_o50, women_u30, women_30_50,women_o50, landmark_names);

% Generate a vector of random indices
num_patients = size(all_data, 2);
rand_indices = randperm(num_patients);

% Apply permutation to all data

all_data = all_data(:, rand_indices);
all_ages = all_ages(rand_indices);
all_genders = all_genders(rand_indices);



% Inizializza una matrice vuota per i dati puliti
all_data_clean = [];

% Loop attraverso ogni riga di all_data
for i = 1:size(all_data, 1)
    % Estrai la riga corrente
    row = all_data(i, :);
    
    % Calcola la media e la deviazione standard
    mu = mean(row);
    sigma = std(row);
    
    % Calcola il punteggio Z per ogni valore
    z_scores = (row - mu) / sigma;
    
    % Definisci gli outlier come valori con un punteggio Z superiore a 2 o inferiore a -2
    outlier_idx = (z_scores > 2) | (z_scores < -2);
    
    % Sostituisci gli outlier con NaN
    row(outlier_idx) = NaN;
    
    % Aggiungi la riga pulita alla matrice all_data_clean
    all_data_clean = [all_data_clean; row];
end


% Inizializza le matrici per ogni gruppo
men_u30_clean = zeros(length(landmark_names), 0);
women_u30_clean = zeros(length(landmark_names),0);
men_30_50_clean = zeros(length(landmark_names), 0);
women_30_50_clean = zeros(length(landmark_names),0);
men_o50_clean = zeros(length(landmark_names), 0);
women_o50_clean = zeros(length(landmark_names), 0);


% Loop attraverso ogni colonna di all_data_clean
for i = 1:size(all_data_clean, 2)
    % Estrai la colonna corrente
    column = all_data_clean(:, i);
    
    % Controlla il genere e l'età per la colonna corrente
    gender = all_genders(i);
    age = all_ages(i);
    

    if gender == '1' % men
        if age == '1' % under 30
            men_u30_clean = [men_u30_clean, column];
        elseif age == '2' % 30-50
            men_30_50_clean = [men_30_50_clean, column];
        else % over 50
            men_o50_clean = [men_o50_clean, column];
        end
    else % women
        if age == '1' % under 30
            women_u30_clean = [women_u30_clean, column];
        elseif age == '2' % 30-50
            women_30_50_clean = [women_30_50_clean, column];
        else % over 50
            women_o50_clean = [women_o50_clean, column];
        end
    end
end


%%% distances for men and women based on each age category after cleaning
plot_distances(men_u30_clean,men_30_50_clean, men_o50_clean, women_u30_clean, women_30_50_clean,women_o50_clean, landmark_names);


%%% ANOVA analysis
ANOVA_landmark = analysis_ANOVA(all_data_clean,all_genders,all_ages,landmark_names);

% In an initial ANOVA analysis, 
% it helps me identify the landmarks that significantly differ between gender groups, age groups, or a combination of both.


%%% Random Forest and Decision Tree analysis
[top_3_rf_age,top_3_rf_sex,top_3_rf,top_3_dt_age,top_3_dt_sex,top_3_dt,model_age,model_sex,model_ga] =analysis_RF_DT(landmark_names, all_data_clean, all_genders, all_ages);


if (strcmp(model_age, 'Decision Tree'))
    age_landmark=top_3_dt_age;
else
    age_landmark=top_3_rf_age;
end
if(strcmp(model_sex,'Decision Tree'))
    sex_landmark=top_3_dt_sex;
else
    sex_landmark=top_3_rf_sex;
end
if(strcmp(model_ga,'Decision Tree'))
    ga_landmark=top_3_dt;
else
    ga_landmark=top_3_rf;
end

fprintf('%s is the best model for your age analysis and it shows that \nthe top-3 landmarks are: %s, %s, %s\n', model_age, landmark_names{age_landmark(1)}, landmark_names{age_landmark(2)}, landmark_names{age_landmark(3)});

fprintf('%s is the best model for your gender analysis and it shows that\nthe top-3 landmarks are: %s, %s, %s\n', model_sex, landmark_names{sex_landmark(1)}, landmark_names{sex_landmark(2)}, landmark_names{sex_landmark(3)});

fprintf('%s is the best model for your combined analysis and it shows that\nthe top-3 landmarks are: %s, %s, %s\n', model_ga, landmark_names{ga_landmark(1)}, landmark_names{ga_landmark(2)}, landmark_names{ga_landmark(3)});


