
close all;
clear all;

% Load data from CSV file
patients = readtable('information/INFOclinical_HN_Version2_30may2018_Metadata.csv', 'VariableNamingRule', 'preserve');
olivetti_patients = readtable('information/elenco_soggetti_operazioni_olivetti.xlsx', 'VariableNamingRule','preserve');
folder_path = {'chum/', 'hmr/distances/', 'hgj/'};

all_files_patients = struct('folder', {}, 'name', {}, 'date', {}, 'bytes', {}, 'isdir', {}, 'datenum', {});

% Loop through each folder path
for i = 1:length(folder_path)
    % Trova i file .csv nella cartella corrente
    files_patients = dir(fullfile(folder_path{i}, '*.csv'));
    
    % Concatenate i file trovati con quelli già presenti
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
men_mean_cell = cell(num_age_categories, 1);
women_mean_cell = cell(num_age_categories, 1);



for i = 1:num_age_categories
    men_mean_cell{i} = table(landmark_names', zeros(num_landmarks,1), repmat(age_categories(i), num_landmarks, 1), zeros(num_landmarks,1), zeros(num_landmarks,1), zeros(num_landmarks,1), 'VariableNames', {'Landmark', 'Num Patients', 'Age', 'Mean (mm)', 'Std Dev (mm)', 'Correlation Coefficient'});
    women_mean_cell{i} = table(landmark_names', zeros(num_landmarks,1), repmat(age_categories(i), num_landmarks, 1), zeros(num_landmarks,1), zeros(num_landmarks,1), zeros(num_landmarks,1), 'VariableNames', {'Landmark', 'Num Patients', 'Age', 'Mean (mm)', 'Std Dev (mm)', 'Correlation Coefficient'});
  
end

% Combine tables into a single structure for easier access
men_mean = vertcat(men_mean_cell{:});
women_mean = vertcat(women_mean_cell{:});

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
    filtered_matrix_men = men_combinated_u30(i, men_combinated_u30(i,:) ~= 0);
    filtered_matrix_women = women_combinated_u30(i, women_combinated_u30(i,:) ~= 0);

    men_u30(i, :) = filtered_matrix_men;
    women_u30(i, :) = filtered_matrix_women;
end

% Assign non-zero values to matrices men and women
for i = 1:length(landmark_names)
    filtered_matrix_men = men_combinated_30_50(i, men_combinated_30_50(i,:) ~= 0);
    filtered_matrix_women = women_combinated_30_50(i, women_combinated_30_50(i,:) ~= 0);
    men_30_50(i, :) = filtered_matrix_men;
    women_30_50(i, :) = filtered_matrix_women;
end

% Assign non-zero values to matrices men and women
for i = 1:length(landmark_names)
    filtered_matrix_men = men_combinated_o50(i, men_combinated_o50(i,:) ~= 0);
    filtered_matrix_women = women_combinated_o50(i, women_combinated_o50(i,:) ~= 0);

    men_o50(i, :) = filtered_matrix_men;
    women_o50(i, :) = filtered_matrix_women;
end


man_values_u30 = zeros(size(men_u30,1),1);
man_values_30_50 = zeros(size(men_30_50,1),1);
man_values_o50 = zeros(size(men_o50,1),1);

% Calculate standard deviation and mean for men and women
for i = 1:10
    men_mean.("Std Dev (mm)")(i) = std(men_u30(i, :));
    men_mean.("Mean (mm)")(i) = mean(men_u30(i, :));
    men_mean.("Std Dev (mm)")(i+10) = std(men_30_50(i, :));
    men_mean.("Mean (mm)")(i+10) = mean(men_30_50(i, :));
    men_mean.("Std Dev (mm)")(i+20) = std(men_o50(i, :));
    men_mean.("Mean (mm)")(i+20) = mean(men_o50(i, :));
    [~, p_value_u30] = ttest2(men_u30(i, men_u30(i, :) ~= 0), women_u30(i, women_u30(i, :) ~= 0));
    [~, p_value_30_50] = ttest2(men_30_50(i, men_30_50(i, :) ~= 0), women_30_50(i, women_30_50(i, :) ~= 0));
    [~, p_value_o50] = ttest2(men_o50(i, men_o50(i, :) ~= 0), women_o50(i, women_o50(i, :) ~= 0));
    men_mean.("Correlation Coefficient")(i) = p_value_u30;
    man_values_u30(i) = p_value_u30;
    men_mean.("Correlation Coefficient")(i+10) = p_value_30_50;
    man_values_30_50(i) = p_value_30_50;
    men_mean.("Correlation Coefficient")(i+20) = p_value_o50;
    man_values_o50(i) = p_value_o50;
    
end


for i = 1:10
    women_mean.("Std Dev (mm)")(i) = std(women_u30(i, :));
    women_mean.("Mean (mm)")(i) = mean(women_u30(i, :));
    women_mean.("Std Dev (mm)")(i+10) = std(women_30_50(i, :));
    women_mean.("Mean (mm)")(i+10) = mean(women_30_50(i, :));
    women_mean.("Std Dev (mm)")(i+20) = std(women_o50(i, :));
    women_mean.("Mean (mm)")(i+20) = mean(women_o50(i, :));
    [~, p_value_u30] = ttest2(men_u30(i, men_u30(i, :) ~= 0), women_u30(i, women_u30(i, :) ~= 0));
    [~, p_value_30_50] = ttest2(men_30_50(i, men_30_50(i, :) ~= 0), women_30_50(i, women_30_50(i, :) ~= 0));
    [~, p_value_o50] = ttest2(men_o50(i, men_o50(i, :) ~= 0), women_o50(i, women_o50(i, :) ~= 0));
    women_mean.("Correlation Coefficient")(i) = p_value_u30;
    women_mean.("Correlation Coefficient")(i+10) = p_value_30_50;
    women_mean.("Correlation Coefficient")(i+20) = p_value_o50;
end

% Concatenation of data to form columns of men and women for each age group
data_u30 = [men_u30, women_u30];
data_30_50 = [men_30_50, women_30_50];
data_o50 = [men_o50, women_o50];

p_values = [man_values_u30, man_values_30_50, man_values_o50];

gender_u30 = ones(size(men_u30, 1), size(men_u30, 2)+size(women_u30, 2));  % Indicators for males under 30 years old
gender_u30(:, size(men_u30, 2) + 1 : end) = 2;

gender_30_50 = ones(size(men_30_50, 1), size(men_30_50, 2)+size(women_30_50, 2));
gender_30_50(:, size(men_30_50, 2) + 1 : end) = 2;

gender_o50 = ones(size(men_o50, 1), size(men_o50, 2)+size(women_o50, 2));
gender_o50(:, size(men_o50, 2) + 1 : end) = 2;


% Merge data to create an overall table
all_data = [men_u30 women_u30, men_30_50 women_30_50, men_o50 women_o50];

% Assign correct values to all_ages
num_patients_u30 = size(men_u30, 2) + size(women_u30, 2);
num_patients_30_50 = size(men_30_50, 2) + size(women_30_50, 2);
num_patients_o50 = size(men_o50, 2) + size(women_o50, 2);

all_ages = [ones(1, num_patients_u30), 2 * ones(1, num_patients_30_50), 3 * ones(1, num_patients_o50)];
all_genders = [gender_u30(1,:), gender_30_50(1,:), gender_o50(1,:)];

% Example of categorical variable transformation
all_genders = categorical(all_genders, [1 2], {'1', '2'});
all_ages = categorical(all_ages, [1 2,3], {'1', '2','3'});

% Generate a vector of random indices
num_patients = size(all_data, 2);
rand_indices = randperm(num_patients);

% Apply permutation to all data


all_data = all_data(:, rand_indices);
all_ages = all_ages(rand_indices);
all_genders = all_genders(rand_indices);

% Remove spaces and special characters from landmark names
modified_landmark_names = regexprep(landmark_names, '[\s\(\)\-]', '');

% Create data table
data_table = array2table(all_data', 'VariableNames', modified_landmark_names);

% Add columns for gender and age
data_table.Gender = all_genders';
data_table.Age = all_ages';

significant_landmark = p_values < 0.05;


% Compute AUC for each Landmark

accuracy_values_gender = zeros(length(landmark_names), 1);
accuracy_values_age = zeros(length(landmark_names), 1);
max_auc_values_age = zeros(length(landmark_names), 1);
age_categories_for_max_auc = cell(length(landmark_names), 1);
gender_categories_for_max_auc=cell(length(landmark_names), 1);
max_auc_values_gender = zeros(length(landmark_names), 1);
precision_values_age = zeros(length(landmark_names), 3);  
recall_values_age = zeros(length(landmark_names), 3);     
precision_values_gender = zeros(length(landmark_names), 2);  
recall_values_gender = zeros(length(landmark_names), 2);     

auc_values_gender = zeros(num_landmarks, 1);
importance_gender = zeros(num_landmarks, 1);

auc_values_age = zeros(num_landmarks, 1);
importance_age = zeros(num_landmarks, 1);

% AUC for gender analysis
for i = 1:length(landmark_names)

    landmark_data = all_data(i, :);
    
    treeModel = fitctree(landmark_data', all_genders);
    predictedLabelsGender = predict(treeModel, landmark_data');
    [~, scoresGender] = predict(treeModel, landmark_data');

    [auc_values_gender,gender_categories_for_max_auc,accuracy_values_gender]= compute_AUC (auc_values_gender,predictedLabelsGender,accuracy_values_gender,scoresGender,all_genders, '2',i, gender_categories_for_max_auc,gender_categories);
    importance_gender(i) = predictorImportance(treeModel);
    
end

% AUC for age analysis

for i = 1:length(landmark_names)
   
    landmark_data = all_data(i, :);
    
    
    treeModel = fitctree(landmark_data', all_ages);
    
   
    [~, scoresAge] = predict(treeModel, landmark_data');
    predictedLabelsAge = predict(treeModel, landmark_data');
    
    importance_age(i) = predictorImportance(treeModel);
    [auc_values_age,age_categories_for_max_auc,accuracy_values_age]= compute_AUC (auc_values_age,predictedLabelsAge,accuracy_values_age,scoresAge,all_ages,'3', i, age_categories_for_max_auc,age_categories);
    
end

% Plot AUC values for each landmark
figure;
plot(auc_values_age, 'o-', 'LineWidth', 1.5,'DisplayName', 'Age');
grid on;
xlabel('Landmark');
ylabel('AUC');
title('AUC for Landmark - Discrimination based on Age or Gender ');
xticks(1:length(landmark_names));
xticklabels(landmark_names);
xtickangle(45);
hold on
% Plot AUC values for each landmark without considering importance
plot(auc_values_gender, 'o-', 'LineWidth', 1.5, 'DisplayName', 'Gender');
grid on;
legend('show');

% Results
figure;
subplot(1, 2, 1);
bar(auc_values_gender);
xticks(1:length(landmark_names));
xticklabels(modified_landmark_names);
xlabel('Landmark');
ylabel('AUC');
title('AUC for Gender');

subplot(1, 2, 2);
bar(auc_values_age);
xticks(1:length(landmark_names));
xticklabels(modified_landmark_names);
xlabel('Landmark');
ylabel('AUC');
title('AUC for Age');

% landmark with AUC max for gender
[max_auc_gender, idx_max_auc_gender] = max(auc_values_gender);
fprintf('In AUC analysis, the landmark that contributes most to gender prediction is: %s with AUC %.4f\n', landmark_names{idx_max_auc_gender}, max_auc_gender);

[max_auc_age, idx_max_auc_age] = max(auc_values_age);
fprintf('In AUC analysis, the landmark that contributes most to age prediction is: %s with AUC %.4f\n', landmark_names{idx_max_auc_age}, max_auc_age);


% % Calcolo dell'importanza dei landmark per il genere
% treeModel_gender = fitctree(all_data', all_genders);
% importance_gender = predictorImportance(treeModel_gender);
% 
% % Calcolo dell'importanza dei landmark per l'età
% treeModel_age = fitctree(all_data', all_ages);
% importance_age = predictorImportance(treeModel_age);

% Visualizzazione dell'importanza
% figure;
% subplot(1, 2, 1);
% bar(importance_gender);
% xticks(1:length(landmark_names));
% xticklabels(modified_landmark_names);
% xlabel('Landmark');
% ylabel('Importance');
% title('Importanza dei Landmark per il Genere');
% 
% subplot(1, 2, 2);
% bar(importance_age);
% xticks(1:length(landmark_names));
% xticklabels(modified_landmark_names);
% xlabel('Landmark');
% ylabel('Importance');
% title('Importanza dei Landmark per età');
% 


% Soglie per la selezione dei landmark
auc_threshold = 0.7;  % esempio: AUC deve essere almeno 0.7
importance_threshold = quantile(importance_gender, 0.75);  % top 25% per importanza

% Selezione dei landmark che superano le soglie
selected_landmarks_auc = auc_values_gender >= auc_threshold;
selected_landmarks_importance = importance_gender >= importance_threshold;

% Landmark finali selezionati
final_selected_landmarks = selected_landmarks_auc & selected_landmarks_importance;


% Visualizzazione dei landmark selezionati
selected_landmark_names = modified_landmark_names(final_selected_landmarks);
disp('Selected landmark for gender:');
disp(selected_landmark_names);



% Visualizzazione dei risultati
figure;
subplot(1, 2, 1);
bar(auc_values_gender);
xticks(1:num_landmarks);
xticklabels(modified_landmark_names);
xlabel('Landmark');
ylabel('AUC');
title('AUC for gender');
hold on;
bar(find(final_selected_landmarks), auc_values_gender(final_selected_landmarks), 'r');
hold off;

subplot(1, 2, 2);
bar(importance_gender);
xticks(1:num_landmarks);
xticklabels(modified_landmark_names);
xlabel('Landmark');
ylabel('Importance');
title('Selected landmark for gender');
hold on;
bar(find(final_selected_landmarks), importance_gender(final_selected_landmarks), 'r');
hold off;


% Soglie per la selezione dei landmark
auc_threshold = 0.7;  % esempio: AUC deve essere almeno 0.7
importance_threshold = quantile(importance_age, 0.75);  % top 25% per importanza

% Selezione dei landmark che superano le soglie
selected_landmarks_auc = auc_values_age >= auc_threshold;
selected_landmarks_importance = importance_age >= importance_threshold;

% Landmark finali selezionati
final_selected_landmarks = selected_landmarks_auc & selected_landmarks_importance;

% Visualizzazione dei landmark selezionati
selected_landmark_names = modified_landmark_names(final_selected_landmarks);
disp('Selected landmark for age:');
disp(selected_landmark_names);


% Visualizzazione dei risultati
figure;
subplot(1, 2, 1);
bar(auc_values_age);
xticks(1:num_landmarks);
xticklabels(modified_landmark_names);
xlabel('Landmark');
ylabel('AUC');
title('AUC for Età');
hold on;
bar(find(final_selected_landmarks), auc_values_age(final_selected_landmarks), 'r');
hold off;

subplot(1, 2, 2);
bar(importance_age);
xticks(1:num_landmarks);
xticklabels(modified_landmark_names);
xlabel('Landmark');
ylabel('Importance');
title('Importance for Age');
hold on;
bar(find(final_selected_landmarks), importance_age(final_selected_landmarks), 'r');
hold off;
