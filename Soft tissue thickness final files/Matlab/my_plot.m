classdef my_plot

    methods(Static)

        function plot_distances(all_data_clean, all_genders, all_ages, landmark_names, title_str)
            
            % Create empty vectors for each combination of gender and age category
            men_1 = [];
            men_2 = [];
            men_3 = [];
            women_1 = [];
            women_2 = [];
            women_3 = [];
            all_ages = double(all_ages);
            MEAN_DISTANCES = './MEAN_DISTANCES';

            if ~exist(MEAN_DISTANCES, 'dir')
                mkdir(MEAN_DISTANCES);
            end
          
            % Iterate through each column
            for i = 1:size(all_data_clean, 2)
                if all_genders(i) == 1
                    if all_ages(i) == 1
                        men_1 = [men_1, all_data_clean(:, i)];
                    elseif all_ages(i) == 2
                        men_2 = [men_2, all_data_clean(:, i)];
                    elseif all_ages(i) == 3
                        men_3 = [men_3, all_data_clean(:, i)];
                    end
                elseif all_genders(i) == 2
                    if all_ages(i) == 1
                        women_1 = [women_1, all_data_clean(:, i)];
                    elseif all_ages(i) == 2
                        women_2 = [women_2, all_data_clean(:, i)];
                    elseif all_ages(i) == 3
                        women_3 = [women_3, all_data_clean(:, i)];
                    end
                end
            end
            
            all_data_men = [men_1,men_2,men_3];
            all_data_women = [women_1,women_2,women_3];
            men_1 = mean(men_1,2,'omitnan');
            men_2 = mean(men_2,2,'omitnan');
            men_3 = mean(men_3,2,'omitnan');
            women_1 = mean(women_1,2,'omitnan');
            women_2 = mean(women_2,2,'omitnan');
            women_3 = mean(women_3,2,'omitnan');
            
            mean_overall_men = mean(all_data_men,2, 'omitnan');
            mean_overall_women = mean(all_data_women,2,'omitnan');
            for i = 1:length(landmark_names)
                skewness_men(i,:) = skewness(all_data_men(i,:));
                skewness_women(i,:) = skewness(all_data_women(i,:));
            end
            
            f1 = figure;
            new_title = ['Men distances, without BMI factor -', title_str];
            plot(1:10, men_1, 'DisplayName', 'Under 25');
            title(new_title);
            hold on;
            plot(1:10, men_2, 'DisplayName', '25-60');
            plot(1:10, men_3, 'DisplayName', 'Over 60');
            xlabel('Landmark');
            ylabel('Distances');
            xticks(1:length(landmark_names));
            xticklabels(landmark_names);
            legend('show');
            hold off;
            
            title_new = strrep(title_str, ' ', '_');
            name_file = sprintf('Men_distances_%s', title_new);
            name_file = strcat(name_file, '.png');
            saveas(f1, fullfile(MEAN_DISTANCES, name_file));
        
            f2 = figure;
            new_title = ['Women distances, without BMI factor -', title_str];
            
            plot(1:10, women_1, 'DisplayName', 'Under 25');
            title(new_title);
            hold on;
            plot(1:10, women_2, 'DisplayName', '25-60');
            plot(1:10, women_3, 'DisplayName', 'Over 60');
            xlabel('Landmark');
            ylabel('Distances');
            xticks(1:length(landmark_names));
            xticklabels(landmark_names);
            legend('show');
            hold off;
            
            name_file = sprintf('Women_distances_%s', title_new);
            name_file = strcat(name_file, '.png');
            saveas(f2, fullfile(MEAN_DISTANCES, name_file));
        
            mean_maps = [men_1, men_2, men_3, women_1, women_2, women_3];
        
            % Create a vector with category names
            categories = {'Men < 25', 'Men 25-60', 'Men >= 60', 'Women < 25', 'Women 25-60', 'Women >= 60'};
            
            f3 = figure;
            new_title = ['Mean maps for each category, without BMI factor -', title_str];
            hold on;
            colors = ['r', 'g', 'b', 'c', 'm', 'y']; % Choose colors for the bars
            for i = 1:length(categories)
                bar(i, mean_maps(:, i), 'FaceColor', colors(i));
            end
            hold off;
            title(new_title);
            xticks(1:6);
            xlabel('Category');
            ylabel('Mean soft tissue thickness');
            set(gca, 'XTickLabel', categories);
            
            name_file = sprintf('Mean_Distribution_%s', title_new);
            name_file = strcat(name_file, '.png');
            saveas(f3, fullfile(MEAN_DISTANCES, name_file));
        
            f4 = figure;
            new_title = ['Men distances and Women distances -', title_str];
            plot(1:10, mean_overall_men, 'DisplayName', 'Men');
            title(new_title);
            hold on;
            plot(1:10, mean_overall_women, 'DisplayName', 'Women');
            xlabel('Landmark');
            ylabel('Distances');
            xticks(1:length(landmark_names));
            xticklabels(landmark_names);
            legend('show');
            hold off;
            
            name_file = sprintf('MenAndWomen_%s', title_new);
            name_file = strcat(name_file, '.png');
            saveas(f4, fullfile(MEAN_DISTANCES, name_file));
        
            title_new = strrep(title_str, ' ', '_');
            std_women = std(all_data_women, 0, 2,'omitnan');
            std_men = std(all_data_men, 0, 2,'omitnan');
        
            not_nan = isfinite(all_data_men);
            num_men = sum(not_nan, 2);
            not_nan = isfinite(all_data_women);
            num_women = sum(not_nan, 2);
        
            table_mean = table(landmark_names', mean_overall_men, std_men, skewness_men, num_men, mean_overall_women, std_women, skewness_women, num_women);
            table_mean.Properties.VariableNames = {'Landmarks', 'Men mean', 'Men std', 'Skewness men', 'N men', 'Women mean', 'Women std', 'Skewness women', 'N women'};
            new_title = sprintf('MenAndWoman_%s.csv', title_new);
            writetable(table_mean, new_title);
        end
        
        function plot_distances_bmi(all_data_clean, all_genders, all_ages, all_bmi, landmark_names, title_str)
            MEAN_DISTANCES = './MEAN_DISTANCES';
            if ~exist(MEAN_DISTANCES, 'dir')
                mkdir(MEAN_DISTANCES);
            end
        
            % Create empty vectors for each combination of gender, age, and BMI category
            men_1_1 = [];
            men_1_2 = [];
            men_1_3 = [];
            men_1_4 = [];
            men_2_1 = [];
            men_2_2 = [];
            men_2_3 = [];
            men_2_4 = [];
            men_3_1 = [];
            men_3_2 = [];
            men_3_3 = [];
            men_3_4 = [];
            
            women_1_1 = [];
            women_1_2 = [];
            women_1_3 = [];
            women_1_4 = [];
            women_2_1 = [];
            women_2_2 = [];
            women_2_3 = [];
            women_2_4 = [];
            women_3_1 = [];
            women_3_2 = [];
            women_3_3 = [];
            women_3_4 = [];
        
            all_ages = double(all_ages);
            all_genders = double(all_genders);
            all_bmi = double(all_bmi);
            
            % Iterate through each column
            for i = 1:size(all_data_clean, 2)
                if all_genders(i) == 1
                    if all_ages(i) == 1
                        if all_bmi(i) == 1
                            men_1_1 = [men_1_1, all_data_clean(:, i)];
                        elseif all_bmi(i) == 2
                            men_1_2 = [men_1_2, all_data_clean(:, i)];
                        elseif all_bmi(i) == 3
                            men_1_3 = [men_1_3, all_data_clean(:, i)];
                        else
                            men_1_4 = [men_1_4, all_data_clean(:, i)];
                        end
                    elseif all_ages(i) == 2
                        if all_bmi(i) == 1
                            men_2_1 = [men_2_1, all_data_clean(:, i)];
                        elseif all_bmi(i) == 2
                            men_2_2 = [men_2_2, all_data_clean(:, i)];
                        elseif all_bmi(i) == 3
                            men_2_3 = [men_2_3, all_data_clean(:, i)];
                        else
                            men_2_4 = [men_2_4, all_data_clean(:, i)];
                        end
                    else
                        if all_bmi(i) == 1
                            men_3_1 = [men_3_1, all_data_clean(:, i)];
                        elseif all_bmi(i) == 2
                            men_3_2 = [men_3_2, all_data_clean(:, i)];
                        elseif all_bmi(i) == 3
                            men_3_3 = [men_3_3, all_data_clean(:, i)];
                        else
                            men_3_4 = [men_3_4, all_data_clean(:, i)];
                        end
                    end
                elseif all_genders(i) == 2
                    if all_ages(i) == 1
                        if all_bmi(i) == 1
                            women_1_1 = [women_1_1, all_data_clean(:, i)];
                        elseif all_bmi(i) == 2
                            women_1_2 = [women_1_2, all_data_clean(:, i)];
                        elseif all_bmi(i) == 3
                            women_1_3 = [women_1_3, all_data_clean(:, i)];
                        else
                            women_1_4 = [women_1_4, all_data_clean(:, i)];
                        end
                    elseif all_ages(i) == 2
                        if all_bmi(i) == 1
                            women_2_1 = [women_2_1, all_data_clean(:, i)];
                        elseif all_bmi(i) == 2
                            women_2_2 = [women_2_2, all_data_clean(:, i)];
                        elseif all_bmi(i) == 3
                            women_2_3 = [women_2_3, all_data_clean(:, i)];
                        else
                            women_2_4 = [women_2_4, all_data_clean(:, i)];
                        end
                    else
                        if all_bmi(i) == 1
                            women_3_1 = [women_3_1, all_data_clean(:, i)];
                        elseif all_bmi(i) == 2
                            women_3_2 = [women_3_2, all_data_clean(:, i)];
                        elseif all_bmi(i) == 3
                            women_3_3 = [women_3_3, all_data_clean(:, i)];
                        else
                            women_3_4 = [women_3_4, all_data_clean(:, i)];
                        end
                    end
                end
            end
            
            all_data_men = [men_1_1, men_1_2, men_1_3, men_1_4, men_2_1, men_2_2, men_2_3, men_2_4, men_3_1, men_3_2, men_3_3, men_3_4];
            all_data_women = [women_1_1, women_1_2, women_1_3, women_1_4, women_2_1, women_2_2, women_2_3, women_2_4, women_3_1, women_3_2, women_3_3, women_3_4];
            for i = 1:length(landmark_names)
                skewness_men(i,:) = skewness(all_data_men(i,:));
                skewness_women(i,:) = skewness(all_data_women(i,:));
            end
            mean_overall_men = mean(all_data_men,2,'omitnan');
            mean_overall_women = mean(all_data_women,2,'omitnan');

            men_1_1 = mean(men_1_1,2,'omitnan');
            men_1_2 = mean(men_1_2,2,'omitnan');
            men_1_3 = mean(men_1_3,2,'omitnan');
            men_1_4 = mean(men_1_4,2,'omitnan');

            men_2_1 = mean(men_2_1,2,'omitnan');
            men_2_2 = mean(men_2_2,2,'omitnan');
            men_2_3 = mean(men_2_3,2,'omitnan');
            men_2_4 = mean(men_2_4,2,'omitnan');

            men_3_1 = mean(men_3_1,2,'omitnan');
            men_3_2 = mean(men_3_2,2,'omitnan');
            men_3_3 = mean(men_3_3,2,'omitnan');
            men_3_4 = mean(men_3_4,2,'omitnan');

            women_1_1 = mean(women_1_1,2,'omitnan');
            women_1_2 = mean(women_1_2,2,'omitnan');
            women_1_3 = mean(women_1_3,2,'omitnan');
            women_1_4 = mean(women_1_4,2,'omitnan');

            women_2_1 = mean(women_2_1,2,'omitnan');
            women_2_2 = mean(women_2_2,2,'omitnan');
            women_2_3 = mean(women_2_3,2,'omitnan');
            women_2_4 = mean(women_2_4,2,'omitnan');

            women_3_1 = mean(women_3_1,2,'omitnan');
            women_3_2 = mean(women_3_2,2,'omitnan');
            women_3_3 = mean(women_3_3,2,'omitnan');
            women_3_4 = mean(women_3_4,2,'omitnan');
            
            mean_overall_men = mean(all_data_men,2, 'omitnan');
            mean_overall_women = mean(all_data_women,2,'omitnan');

            categories = {};
            i = 1;
            new_title = ['Men distances, with BMI factor -', title_str];
            f4 = figure;
            if(~isempty(men_1_1))
                plot(1:10, men_1_1, 'DisplayName', 'Under 24 Underweight');
                categories{i} = 'Men < 24 Underweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if(~isempty(men_1_2))
                plot(1:10, men_1_2, 'DisplayName', 'Under 24 Normal weight');
                categories{i} = 'Men < 24 Normal weight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if(~isempty(men_1_3))
                plot(1:10, men_1_3, 'DisplayName', 'Under 24 Overweight');
                categories{i} = 'Men < 24 Overweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if(~isempty(men_1_4))
                plot(1:10, men_1_4, 'DisplayName', 'Under 24 Obese');
                categories{i} = 'Men < 24 Obese';
                i = i + 1;
            end
            title(new_title);
            hold on;
            
            if(~isempty(men_2_1))
                plot(1:10, men_2_1, 'DisplayName', '24-29 Underweight');
                categories{i} = '24 <= Men <29 Underweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            
            if(~isempty(men_2_2))
                plot(1:10, men_2_2, 'DisplayName', '24-29 Normal weight');
                categories{i} = '24 <= Men <29 Normal weight';
                i = i + 1;
            end
            title(new_title);
            hold on;
           
            if(~isempty(men_2_3))
                plot(1:10, men_2_3, 'DisplayName', '24-29 Overweight');
                categories{i} = '24 <= Men <29 Overweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if(~isempty(men_2_4))
                plot(1:10, men_2_4, 'DisplayName', '24-29 Obese');
                categories{i} = '24 <= Men <29 Obese';
                i = i + 1;
            end
            title(new_title);
            hold on;

            if(~isempty(men_3_1))
                plot(1:10, men_3_1, 'DisplayName', 'Over 29 Underweight');
                categories{i} = 'Men >= 29 Underweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            
            if(~isempty(men_3_2))
                plot(1:10, men_3_2, 'DisplayName', 'Over 29 Normal weight');
                categories{i} = 'Men >= 29 Normal weight';
                i = i + 1;
            end
            title(new_title);
            hold on;
           
            if(~isempty(men_3_3))
                plot(1:10, men_3_3, 'DisplayName', 'Over 29 Overweight');
                categories{i} = 'Men >= 29 Overweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if(~isempty(men_3_4))
                plot(1:10, men_3_4, 'DisplayName', 'Over 29 Obese');
                categories{i} = 'Men >= 29 Obese';
                i = i + 1;
            end
            title(new_title);
            hold on;

            xlabel('Landmark');
            ylabel('Distances');
            xticks(1:length(landmark_names));
            xticklabels(landmark_names);
            legend('show');
            
            title_new = strrep(title_str, ' ', '_');
            name_file = sprintf('Men_distances_BMI_%s', title_new);
            name_file = strcat(name_file, '.png');
            saveas(f4, fullfile(MEAN_DISTANCES, name_file));
        
            new_title = ['Women distances, with BMI factor -', title_str];
            f5 = figure;
            if(~isempty(women_1_1))
                plot(1:10, women_1_1, 'DisplayName', 'Under 24 Underweight');
                categories{i} = 'Women < 24 Underweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
           
            if(~isempty(women_1_2))
                plot(1:10, women_1_2, 'DisplayName', 'Under 24 Normal weight');
                categories{i} = 'Women < 24 Normal weight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            
            if(~isempty(women_1_3))
                plot(1:10, women_1_3, 'DisplayName', 'Under 24 Overweight');
                categories{i} = 'Women < 24 Overweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if (~isempty(women_1_4))
                plot(1:10, women_1_4, 'DisplayName', 'Under 24 Obese');
                categories{i} = 'Women < 24 Obese';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if(~isempty(women_2_1))
                plot(1:10, women_2_1, 'DisplayName', '24-29 Underweight');
                categories{i} = '24 <= Women < 29 Underweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if(~isempty(women_2_2))
                plot(1:10, women_2_2, 'DisplayName', '24-29 Normal weight');
                categories{i} = '24 <= Women < 29 Normal weight';
                i = i + 1;
            end
            title(new_title);
            hold on;

            if (~isempty(women_2_3))
                plot(1:10, women_2_3, 'DisplayName', '24-29 Overweight');
                categories{i} = '24 <= Women < 29 Overweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if (~isempty(women_2_4))
                plot(1:10, women_2_4, 'DisplayName', '24-29 Obese');
                categories{i} = '24 <= Women < 29 Obese';
                i = i + 1;
            end
            if(~isempty(women_3_1))
                plot(1:10, women_3_1, 'DisplayName', 'Over 29 Underweight');
                categories{i} = 'Women >= 29 Underweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if(~isempty(women_3_2))
                plot(1:10, women_3_2, 'DisplayName', 'Over 29 Normal weight');
                categories{i} = 'Women >= 29 Normal weight';
                i = i + 1;
            end
            title(new_title);
            hold on;

            if (~isempty(women_3_3))
                plot(1:10, women_3_3, 'DisplayName', 'Over 29 Overweight');
                categories{i} = 'Women >= 29 Overweight';
                i = i + 1;
            end
            title(new_title);
            hold on;
            if (~isempty(women_3_4))
                plot(1:10, women_3_4, 'DisplayName', 'Over 29 Obese');
                categories{i} = 'Women >= 29 Obese';
                i = i + 1;
            end
            title(new_title);
            hold on;
            xlabel('Landmark');
            ylabel('Distances');
            xticks(1:length(landmark_names));
            xticklabels(landmark_names);
            legend('show');

            title_new = strrep(title_str, ' ', '_');
            name_file = sprintf('Women_distances_BMI_%s', title_new);
            name_file = strcat(name_file, '.png');
            saveas(f5, fullfile(MEAN_DISTANCES, name_file));
        
            mean_maps = [men_1_1, men_1_2, men_1_3, men_1_4, men_2_1, men_2_2, men_2_3, men_2_4, men_3_1, men_3_2, men_3_3, men_3_4, women_1_1, women_1_2, women_1_3, women_1_4, women_2_1, women_2_2, women_2_3, women_2_4, women_3_1, women_3_2, women_3_3, women_3_4];
        
            new_title = ['Mean maps for each category, with BMI factor -', title_str];
            f6 = figure;
            hold on;
            colors = lines(length(categories)); % Generate distinct colors
            for i = 1:size(mean_maps,2)
                bar(i, mean_maps(:, i), 'FaceColor', colors(i,:));
            end
            hold off;
            title(new_title);
            xticks(1:length(categories));
            xlabel('Category');
            ylabel('Mean soft tissue thickness');
            set(gca, 'XTickLabel', categories);

            name_file = sprintf('Mean_Distribution_BMI_%s', title_new);
            name_file = strcat(name_file, '.png');
            saveas(f6, fullfile(MEAN_DISTANCES, name_file));

            f7 = figure;
            new_title = ['Men distances and Women distances with BMI factors -', title_str];
            plot(1:10, mean_overall_men, 'DisplayName', 'Men');
            title(new_title);
            hold on;
            plot(1:10, mean_overall_women, 'DisplayName', 'Women');
            xlabel('Landmark');
            ylabel('Distances');
            xticks(1:length(landmark_names));
            xticklabels(landmark_names);
            legend('show');

            name_file = sprintf('MenAndWomen_BMI_%s', title_new);
            name_file = strcat(name_file, '.png');
            saveas(f7, fullfile(MEAN_DISTANCES, name_file));
            
            title_new = strrep(title_str, ' ', '_');
            std_women = std(all_data_women, 0, 2,'omitnan');
            std_men = std(all_data_men, 0, 2,'omitnan');

            not_nan = isfinite(all_data_men);
            num_men = sum(not_nan, 2);
            not_nan = isfinite(all_data_women);
            num_women = sum(not_nan, 2);

            table_mean = table(landmark_names', mean_overall_men, std_men, skewness_men, num_men, mean_overall_women, std_women, skewness_women, num_women);
            table_mean.Properties.VariableNames = {'Landmarks', 'Men mean', 'Men std', 'Skewness men', 'N men', 'Women mean', 'Women std', 'Skewness women', 'N women'};
            new_title = sprintf('MenAndWoman_BMI_%s.csv', title_new);
            writetable(table_mean, new_title);
        end
        
    end
end