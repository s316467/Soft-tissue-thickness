clear all;

addpath('functions.m');
% Load data from CSV file
patients = readtable('information/INFOclinical_HN_Version2_30may2018_Metadata.csv', 'VariableNamingRule', 'preserve');
olivetti_patients = readtable('information/elenco_soggetti_operazioni_olivetti.xlsx', 'VariableNamingRule','preserve');
folder_path = {'chum/', 'hmr/distances/', 'chus/', 'hgj/'};

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
    women_data_o50,women_mean, men_mean)


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
    men_mean.("Correlation Coefficient")(i+10) = p_value_30_50;
    men_mean.("Correlation Coefficient")(i+20) = p_value_o50;
    
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

% Plot bar chart of mean distances between men and women for each landmark
% figure;

% Calculate the positions for each group of bars

% num_landmarks = length(landmark_names);
% bar_width = 0.25;  % Width of each bar
% space_between_bars = 0.06;  % Space between grouped bars
% group_width = bar_width * 3 + space_between_bars * 2;  % Width of each group of bars
% 
% 
% 
% % Plot bars for Men Under 30
% bar_positions_u30 = 1:num_landmarks;
% bar(bar_positions_u30 - group_width, men_mean.("Mean (mm)")(1:10), bar_width, 'FaceColor', 'b','FaceAlpha',0.5, 'DisplayName', 'Men - Under 30');
% hold on;
% 
% % Plot bars for Women Under 30
% bar(bar_positions_u30 - group_width, women_mean.("Mean (mm)")(1:10), bar_width, 'FaceColor', 'r','FaceAlpha',0.5, 'DisplayName', 'Women - Under 30');
% 
% % Adjust the positions for the next group of bars
% bar_positions_30_50 = 1:num_landmarks;
% 
% % Plot bars for Men 30-50
% bar(bar_positions_30_50, men_mean.("Mean (mm)")(11:20), bar_width, 'FaceColor', 'green','FaceAlpha',0.5, 'DisplayName', 'Men - 30-50');
% hold on;
% 
% % Plot bars for Women 30-50
% bar(bar_positions_30_50, women_mean.("Mean (mm)")(11:20), bar_width, 'FaceColor', 'yellow','FaceAlpha',0.5, 'DisplayName', 'Women - 30-50');
% 
% % Adjust the positions for the next group of bars
% bar_positions_o50 = 1:num_landmarks;
% 
% % Plot bars for Men Over 50
% bar(bar_positions_o50 + group_width, men_mean.("Mean (mm)")(21:30), bar_width, 'FaceColor', 'cyan','FaceAlpha',0.5,  'DisplayName', 'Men - Over 50');
% hold on;
% 
% % Plot bars for Women Over 50
% bar(bar_positions_o50 + group_width, women_mean.("Mean (mm)")(21:30), bar_width, 'FaceColor', 'magenta','FaceAlpha',0.5, 'DisplayName', 'Women - Over 50');
% hold off;
% 
% % Adjust plot properties
% xticks(1:num_landmarks);
% xticklabels(landmark_names);
% xlabel('Landmark');
% ylabel('Average Distance (mm)');
% title('Average Distances between Men and Women for Each Landmark');
% xtickangle(45);
% grid on;
% 
% % Add legends for each group
% legend('show', 'Location', 'best');
% 
% 

% Initialize AUC matrices for different age and gender groups
AUC_values_u30_men = zeros(length(landmark_names), 1);
AUC_values_u30_women = zeros(length(landmark_names), 1);
AUC_values_30_50_men = zeros(length(landmark_names), 1);
AUC_values_30_50_women = zeros(length(landmark_names), 1);
AUC_values_o50_men = zeros(length(landmark_names), 1);
AUC_values_o50_women = zeros(length(landmark_names), 1);

landmark_labels = cell(length(landmark_names), 1);

for landmark_index = 1:length(landmark_names)

    distances_men_u30 = men_u30(landmark_index, men_u30(landmark_index, :) ~= 0);
    distances_men_30_50 = men_30_50(landmark_index, men_30_50(landmark_index, :) ~= 0);
    distances_men_o50 = men_o50(landmark_index, men_o50(landmark_index, :) ~= 0);
    distances_women_u30 = women_u30(landmark_index, women_u30(landmark_index, :) ~= 0);
    distances_women_30_50 = women_30_50(landmark_index, women_30_50(landmark_index, :) ~= 0);
    distances_women_o50 = women_o50(landmark_index, women_o50(landmark_index, :) ~= 0);
    
    % Check number of unique class labels for men and women in each age group
    unique_labels_u30_men = unique([ones(size(distances_men_u30,2),1); 2*ones(size(distances_women_u30,2),1)]);
    unique_labels_u30_women = unique([ones(size(distances_men_u30,2),1); 2*ones(size(distances_women_u30,2),1)]);
    unique_labels_30_50_men = unique([ones(size(distances_men_30_50,2),1); 2*ones(size(distances_women_30_50,2),1)]);
    unique_labels_30_50_women = unique([ones(size(distances_men_30_50,2),1); 2*ones(size(distances_women_30_50,2),1)]);
    unique_labels_o50_men = unique([ones(size(distances_men_o50,2),1); 2*ones(size(distances_women_o50,2),1)]);
    unique_labels_o50_women = unique([ones(size(distances_men_o50,2),1); 2*ones(size(distances_women_o50,2),1)]);
    
    if length(unique_labels_u30_men) >= 2
        % Calculate ROC and AUC for Under 30 - Men
        [X,Y,~,AUC_u30_men] = perfcurve([ones(size(distances_men_u30,2),1); 2*ones(size(distances_women_u30,2),1)], [distances_men_u30 distances_women_u30], 1);
        AUC_values_u30_men(landmark_index) = AUC_u30_men;
        landmark_labels{landmark_index} = landmark_names{landmark_index};
        fprintf('Landmark "%s": AUC (Under 30 - Men) = %.2f\n', landmark_names{landmark_index}, AUC_u30_men);
    end
    
    if length(unique_labels_u30_women) >= 2
        % Calculate ROC and AUC for Under 30 - Women
        [X,Y,~,AUC_u30_women] = perfcurve([ones(size(distances_men_u30,2),1); 2*ones(size(distances_women_u30,2),1)], [distances_men_u30 distances_women_u30], 2);
        AUC_values_u30_women(landmark_index) = AUC_u30_women;
        landmark_labels{landmark_index} = landmark_names{landmark_index};
        fprintf('Landmark "%s": AUC (Under 30 - Women) = %.2f\n', landmark_names{landmark_index}, AUC_u30_women);
    end
    
    if length(unique_labels_30_50_men) >= 2
        % Calculate ROC and AUC for 30-50 - Men
        [X,Y,~,AUC_30_50_men] = perfcurve([ones(size(distances_men_30_50,2),1); 2*ones(size(distances_women_30_50,2),1)], [distances_men_30_50 distances_women_30_50], 1);
        AUC_values_30_50_men(landmark_index) = AUC_30_50_men;
        landmark_labels{landmark_index} = landmark_names{landmark_index};
        fprintf('Landmark "%s": AUC (30-50 - Men) = %.2f\n', landmark_names{landmark_index}, AUC_30_50_men);
    end
    
    if length(unique_labels_30_50_women) >= 2
        % Calculate ROC and AUC for 30-50 - Women
        [X,Y,~,AUC_30_50_women] = perfcurve([ones(size(distances_men_30_50,2),1); 2*ones(size(distances_women_30_50,2),1)], [distances_men_30_50 distances_women_30_50], 2);
        AUC_values_30_50_women(landmark_index) = AUC_30_50_women;
        landmark_labels{landmark_index} = landmark_names{landmark_index};
        fprintf('Landmark "%s": AUC (30-50 - Women) = %.2f\n', landmark_names{landmark_index}, AUC_30_50_women);
    end
    
    if length(unique_labels_o50_men) >= 2
        % Calculate ROC and AUC for Over 50 - Men
        [X,Y,~,AUC_o50_men] = perfcurve([ones(size(distances_men_o50,2),1); 2*ones(size(distances_women_o50,2),1)], [distances_men_o50 distances_women_o50], 1);
        AUC_values_o50_men(landmark_index) = AUC_o50_men;
        landmark_labels{landmark_index} = landmark_names{landmark_index};
        fprintf('Landmark "%s": AUC (Over 50 - Men) = %.2f\n', landmark_names{landmark_index}, AUC_o50_men);
    end
    
    if length(unique_labels_o50_women) >= 2
        % Calculate ROC and AUC for Over 50 - Women
        [X,Y,~,AUC_o50_women] = perfcurve([ones(size(distances_men_o50,2),1); 2*ones(size(distances_women_o50,2),1)], [distances_men_o50 distances_women_o50], 2);
        AUC_values_o50_women(landmark_index) = AUC_o50_women;
        landmark_labels{landmark_index} = landmark_names{landmark_index};
        fprintf('Landmark "%s": AUC (Over 50 - Women) = %.2f\n', landmark_names{landmark_index}, AUC_o50_women);
    end

end

% Plotting AUC values for Man categories
f1=figure;

% Plot AUC values for Under 30 - Men
plot(1:length(landmark_names), AUC_values_u30_men, 'o-', 'LineWidth', 1.5, 'Color','r', 'DisplayName', 'Under 30 - Men');
hold on;


% Plot AUC values for 30-50 - Men
plot(1:length(landmark_names), AUC_values_30_50_men, 'o-', 'LineWidth', 1.5, 'Color','m', 'DisplayName', '30-50 - Men');


% Plot AUC values for Over 50 - Men
plot(1:length(landmark_names), AUC_values_o50_men, 'o-', 'LineWidth', 1.5, 'Color','y', 'DisplayName', 'Over 50 - Men');

hold off;
grid on;
xlabel('Landmark');
ylabel('AUC');
title('AUC per Landmark - Discrimination by Age Group for Men');
xticks(1:length(landmark_names));
xticklabels(landmark_labels);
xtickangle(45);

% Add legend
legend('show', 'Location', 'best');

f2=figure;
% Plot AUC values for Under 30 - Women
plot(1:length(landmark_names), AUC_values_u30_women, 'o-', 'LineWidth', 1.5, 'Color','r', 'DisplayName', 'Under 30 - Women');
hold on;
% Plot AUC values for 30-50 - Women
plot(1:length(landmark_names), AUC_values_30_50_women, 'o-', 'LineWidth', 1.5, 'Color','m', 'DisplayName', '30-50 - Women');

% Plot AUC values for Over 50 - Women
plot(1:length(landmark_names), AUC_values_o50_women, 'o-', 'LineWidth', 1.5, 'Color','y', 'DisplayName', 'Over 50 - Women');


hold off;
grid on;
xlabel('Landmark');
ylabel('AUC');
title('AUC per Landmark - Discrimination by Age Group for Women');
xticks(1:length(landmark_names));
xticklabels(landmark_labels);
xtickangle(45);

% Add legend
legend('show', 'Location', 'best');


% Plotting AUC values for MAN categories
f3= figure;

% Plot AUC values for Under 30 - Men
plot(1:length(landmark_names), AUC_values_u30_men, 'o-', 'LineWidth', 1.5, 'Color','b', 'DisplayName', 'Under 30 - Men');
hold on;

% Plot AUC values for Under 30 - Women
plot(1:length(landmark_names), AUC_values_u30_women, 'o-', 'LineWidth', 1.5, 'Color','r', 'DisplayName', 'Under 30 - Women');

% Plot AUC values for 30-50 - Men
plot(1:length(landmark_names), AUC_values_30_50_men, 'o-', 'LineWidth', 1.5, 'Color','g', 'DisplayName', '30-50 - Men');

% Plot AUC values for 30-50 - Women
plot(1:length(landmark_names), AUC_values_30_50_women, 'o-', 'LineWidth', 1.5, 'Color','m', 'DisplayName', '30-50 - Women');

% Plot AUC values for Over 50 - Men
plot(1:length(landmark_names), AUC_values_o50_men, 'o-', 'LineWidth', 1.5, 'Color','c', 'DisplayName', 'Over 50 - Men');

% Plot AUC values for Over 50 - Women
plot(1:length(landmark_names), AUC_values_o50_women, 'o-', 'LineWidth', 1.5, 'Color','y', 'DisplayName', 'Over 50 - Women');

hold off;
grid on;
xlabel('Landmark');
ylabel('AUC');
title('AUC per Landmark - Discrimination by Age Group and Gender');
xticks(1:length(landmark_names));
xticklabels(landmark_labels);
xtickangle(45);

% Add legend
legend('show', 'Location', 'best');

