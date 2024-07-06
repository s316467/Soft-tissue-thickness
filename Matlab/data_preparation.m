

function [all_ages_bmi, all_genders_bmi, all_bmi, all_data_bmi_clean, all_data_clean, all_ages, all_genders, landmark_names]=data_preparation()

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
                      'Rhinion','Midphiltrum'};

% Initialize tables for mean, standard deviation, and correlation coefficient
age_categories = {'Under 25'; '25-60'; 'Over 60'};
gender_categories={'M';'F'};
num_age_categories = length(age_categories);
num_landmarks = length(landmark_names);

% Create cell arrays to store values for each age category
men_table = cell(num_age_categories, 1);
women_table = cell(num_age_categories, 1);



for i = 1:num_age_categories
    men_table{i} = table(landmark_names', zeros(num_landmarks,1), repmat(age_categories(i), num_landmarks, 1), 'VariableNames', {'Landmark', 'Num Patients', 'Age'});
    women_table{i} = table(landmark_names', zeros(num_landmarks,1), repmat(age_categories(i), num_landmarks, 1),  'VariableNames', {'Landmark', 'Num Patients', 'Age'});
  
end

men_table = vertcat(men_table{:});
women_table = vertcat(women_table{:});

men_data_hn_u30 = zeros(length(landmark_names), length(files_patients));
women_data_hn_u30 = zeros(length(landmark_names), length(files_patients));
men_data_hn_30_50 = zeros(length(landmark_names), length(files_patients));
women_data_hn_30_50 = zeros(length(landmark_names), length(files_patients));
men_data_hn_o50 = zeros(length(landmark_names), length(files_patients));
women_data_hn_o50 = zeros(length(landmark_names), length(files_patients));


for hospital_id=1:length(folder_path)

    files_patients = dir(fullfile(folder_path{hospital_id}, '*.csv'));
    [men_table,women_table, men_data_hn_30_50,men_data_hn_u30, men_data_hn_o50, women_data_hn_30_50, women_data_hn_u30,...
    women_data_hn_o50]=hospital_mean(patients,files_patients, folder_path{hospital_id},...
    men_table,women_table, men_data_hn_30_50,men_data_hn_u30, men_data_hn_o50, women_data_hn_30_50, women_data_hn_u30,...
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
    women_data_o50,women_table, men_table, men_bmi_table, women_bmi_table] = olivetti_mean (files_olivetti, olivetti_patients,men_data_30_50,...
    men_data_u30,men_data_o50,women_data_30_50, women_data_u30, ...
    women_data_o50,women_table, men_table);





% Combine data for men and women
men_combinated_u30 = [men_data_hn_u30, men_data_u30];
women_combinated_u30 = [women_data_hn_u30, women_data_u30];
men_combinated_o50 = [men_data_hn_o50, men_data_o50];
women_combinated_o50 = [women_data_hn_o50, women_data_o50];
men_combinated_30_50 = [men_data_hn_30_50, men_data_30_50];
women_combinated_30_50 = [women_data_hn_30_50, women_data_30_50];
men_u30 = zeros(length(landmark_names), men_table.("Num Patients")(1));
women_u30 = zeros(length(landmark_names), women_table.("Num Patients")(1));
men_30_50 = zeros(length(landmark_names), men_table.("Num Patients")(11));
women_30_50 = zeros(length(landmark_names), women_table.("Num Patients")(11));
men_o50 = zeros(length(landmark_names), men_table.("Num Patients")(21));
women_o50 = zeros(length(landmark_names), women_table.("Num Patients")(21));


genders_bmi_women = table2array(women_bmi_table(:, 'Sex'));
ages_bmi_women = table2array(women_bmi_table(:, 'AgeCategory'));
bmi_women = table2array(women_bmi_table(:, 'BMI'));
bmi_landmarks_women = (table2array(women_bmi_table(:,"Soft Tissue Thickness")))';

genders_bmi_men = table2array(men_bmi_table(:, 'Sex'));
ages_bmi_men = table2array(men_bmi_table(:, 'AgeCategory'));
bmi_men = table2array(men_bmi_table(:, 'BMI'));
bmi_landmarks_men = (table2array(men_bmi_table(:,"Soft Tissue Thickness")))';


% Assign non-zero values to matrices men and women
for i = 1:length(landmark_names)
    men_u30(i, :)= men_combinated_u30(i, men_combinated_u30(i,:) ~= 0);
    women_u30(i, :) = women_combinated_u30(i, women_combinated_u30(i,:) ~= 0);
    men_30_50(i, :) = men_combinated_30_50(i, men_combinated_30_50(i,:) ~= 0);
    women_30_50(i, :) = women_combinated_30_50(i, women_combinated_30_50(i,:) ~= 0);
    men_o50(i, :)  = men_combinated_o50(i, men_combinated_o50(i,:) ~= 0);
    women_o50(i, :)  = women_combinated_o50(i, women_combinated_o50(i,:) ~= 0);   




end





gender_u30 = ones(1, size(men_u30, 2)+size(women_u30, 2));  % Indicators for males under 25 years old
gender_u30(:, size(men_u30, 2) + 1 : end) = 2;

gender_30_50 = ones(1, size(men_30_50, 2)+size(women_30_50, 2));
gender_30_50(:, size(men_30_50, 2) + 1 : end) = 2;

gender_o50 = ones(1, size(men_o50, 2)+size(women_o50, 2));
gender_o50(:, size(men_o50, 2) + 1 : end) = 2;


%%%%%%%%%%%%% for bmi analysis

all_data_bmi = [bmi_landmarks_men, bmi_landmarks_women];
all_genders_bmi = [genders_bmi_men', genders_bmi_women' ];
all_ages_bmi = [ages_bmi_men', ages_bmi_women'];
all_bmi = [bmi_men', bmi_women'];


gender_mapping = containers.Map({'M', 'F'}, {1, 2});
all_genders_bmi = cellfun(@(x) gender_mapping(x), all_genders_bmi);
all_genders_bmi = categorical(all_genders_bmi, [1 2], {'1', '2'});

age_mapping = containers.Map({'Under 23', '24-28', 'Over 29'}, {1, 2, 3});
all_ages_bmi = cellfun(@(x) age_mapping(x), all_ages_bmi);
all_ages_bmi = categorical(all_ages_bmi, [1 2 3], {'1', '2', '3'});


% Convert 'all_bmi' into a categorical vector
all_bmi = categorical(all_bmi);

% Create a mapping dictionary
bmi_mapping = containers.Map({'Underweight', 'Normal weight', 'Overweight', 'Obese'}, {1, 2, 3, 4});

% Apply the mapping to your categorical vector
all_bmi = cellfun(@(x) bmi_mapping(x), cellstr(all_bmi));


% Generate a vector of random indices
num_patients = size(all_data_bmi, 2);
rand_indices = randperm(num_patients);

% Apply permutation to all data

all_data_bmi = all_data_bmi(:, rand_indices);
all_ages_bmi = all_ages_bmi(rand_indices);
all_genders_bmi = all_genders_bmi(rand_indices);
all_bmi=all_bmi(rand_indices);

%%%% removing outlier

all_data_bmi_clean = [];


for i = 1:size(all_data_bmi, 1)

    row = all_data_bmi(i, :);
    outliers = isoutlier(row, 'quartiles');
    row(outliers) = NaN;
    all_data_bmi_clean = [all_data_bmi_clean; row];
end

% 
% men_u24_bmi_clean = zeros(length(landmark_names), 0);
% women_u24_bmi_clean = zeros(length(landmark_names),0);
% men_o24_bmi_clean = zeros(length(landmark_names), 0);
% women_o24_bmi_clean = zeros(length(landmark_names),0);
% 
% 
% for i = 1:size(all_data_bmi_clean, 2)
%     % Estrai la colonna corrente
%     column = all_data_bmi_clean(:, i);
% 
%     % Controlla il genere e l'età per la colonna corrente
%     gender = all_genders_bmi(i);
%     age = all_ages_bmi(i);
% 
% 
%     if gender == '1' % men
%         if age == '1' % under 24
%             men_u24_bmi_clean = [men_u24_bmi_clean, column];
%         else % over 24
%             men_o24_bmi_clean = [men_o24_bmi_clean, column];
%         end
%     else % women
%         if age == '1' % under 25
%             women_u24_bmi_clean = [women_u24_bmi_clean, column];
%         else age == '2' % 25-60
%             women_o24_bmi_clean = [women_o24_bmi_clean, column];
%         end
%     end
% end
% 
% 
% 
% %% distances for men and women based on each age category after cleaning
% [mean_men_u24_bmi,mean_men_o24_bmi,mean_women_u24_bmi,mean_women_o24_bmi]=plot_distances_bmi(men_u24_bmi_clean,men_o24_bmi_clean, women_u24_bmi_clean, women_o24_bmi_clean, landmark_names);
% 
% mean_maps_bmi = [mean_men_u24_bmi, mean_men_o24_bmi, mean_women_u24_bmi, mean_men_o24_bmi];
% 
% categories = {'Men < 24', 'Men >= 24',  'Women < 24','Women >= 24'};
% 
% figure;
% hold on;
% colors = ['r', 'g', 'b', 'c']; % Scegli i colori per le barre
% for i = 1:length(categories)
%     bar(i, mean_maps_bmi(:, i), 'FaceColor', colors(i));
% end
% hold off;
% title('Mean maps for each category');
% xticks(1:45)
% xlabel('Category');
% ylabel('Mean soft tissue thickness');
% set(gca, 'XTickLabel', categories);
% 


%%%%%%%%%% for age and gender analysis


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
    % Trova gli outlier utilizzando rmoutliers
    outliers = isoutlier(row, 'quartiles');
    
    % Sostituisci gli outlier con NaN
    row(outliers) = NaN;
    
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
        if age == '1' % under 25
            men_u30_clean = [men_u30_clean, column];
        elseif age == '2' % 25-60
            men_30_50_clean = [men_30_50_clean, column];
        else % over 60
            men_o50_clean = [men_o50_clean, column];
        end
    else % women
        if age == '1' % under 25
            women_u30_clean = [women_u30_clean, column];
        elseif age == '2' % 25-60
            women_30_50_clean = [women_30_50_clean, column];
        else % over 60
            women_o50_clean = [women_o50_clean, column];
        end
    end
end

plot_distances(men_u30_clean,men_30_50_clean, men_o50_clean, women_u30_clean, women_30_50_clean,women_o50_clean, landmark_names);



end