
classdef my_plot

    methods(Static)

        function plot_distances(all_data_clean, all_genders, all_ages, landmark_names, title_str)
            
            % Creiamo dei vettori vuoti per ogni combinazione di genere e categoria di età
            men_1 = [];
            men_2 = [];
            men_3 = [];
            women_1 = [];
            women_2 = [];
            women_3 = [];
            all_ages = double(all_ages);
            
            % Iteriamo attraverso ogni colonna
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
            
            men_1=mean(men_1,2,'omitnan');
            men_2 = mean(men_2,2,'omitnan');
            men_3 = mean(men_3,2,'omitnan');
            women_1 = mean(women_1,2,'omitnan');
            women_2 = mean(women_2,2,'omitnan');
            women_3 = mean(women_3,2,'omitnan');
            
            
            figure;
            new_title=strcat('Men distances, without BMI factor','-', title_str);
            plot(1:10, men_1,'DisplayName', 'Under 25');
            title(new_title);
            hold on;
            plot(1:10,men_2, 'DisplayName','25-60');
            plot(1:10,men_3, 'DisplayName','Over 60');
            xlabel('Landmark');
            ylabel('Distances');
            xticks(1:length(landmark_names));
            xticklabels(landmark_names);
            legend('show');
        
            
            figure;
            new_title=strcat('Women distances, without BMI factor ','-',title_str);
            
            plot(1:10, women_1,'DisplayName', 'Under 25');
            title(new_title);
            hold on;
            plot(1:10,women_2, 'DisplayName','25-60');
            plot(1:10,women_3, 'DisplayName','Over 60');
            xlabel('Landmark');
            ylabel('Distances');
            xticks(1:length(landmark_names));
            xticklabels(landmark_names);
            legend('show');
        
            mean_maps = [men_1, men_2, men_3, women_1, women_2, women_3];
        
            % Crea un vettore con i nomi delle categorie
            categories = {'Men < 25', 'Men 25-60', 'Men >= 60', 'Women < 25', 'Women 25-60', 'Women >= 60'};
            
            figure;
            new_title = strcat('Mean maps for each category, without BMI factor' ,'-', title_str);
            hold on;
            colors = ['r', 'g', 'b', 'c', 'm', 'y']; % Scegli i colori per le barre
            for i = 1:length(categories)
                bar(i, mean_maps(:, i), 'FaceColor', colors(i));
            end
            hold off;
            title(new_title);
            xticks(1:45)
            xlabel('Category');
            ylabel('Mean soft tissue thickness');
            set(gca, 'XTickLabel', categories);
        
        
        end
        
        function plot_distances_bmi(all_data_clean, all_genders, all_ages, all_bmi, landmark_names, title_str)
        
         % Creiamo dei vettori vuoti per ogni combinazione di genere e categoria di età
            men_1_1 = [];
            men_1_2 = [];
            men_1_3=[];
            men_1_4=[];
            men_2_1 = [];
            men_2_2 = [];
            men_2_3=[];
            men_2_4=[];
            men_3_1=[];
            men_3_2=[];
            men_3_3=[];
            men_3_4=[];
            
            women_1_1 = [];
            women_1_2 = [];
            women_1_3 = [];
            women_1_4 = [];
            women_2_1 = [];
            women_2_2 = [];
            women_2_3 = [];
            women_2_4 = [];
            women_3_1=[];
            women_3_2=[];
            women_3_3=[];
            women_3_4=[];
   
            all_ages = double(all_ages);
            all_genders=double(all_genders);
            all_bmi = double (all_bmi);
            
            % Iteriamo attraverso ogni colonna
            for i = 1:size(all_data_clean, 2)
                if all_genders(i) == 1
                    if all_ages(i) == 1
                        if all_bmi(i) == 1
                            men_1_1 = [men_1_1, all_data_clean(:, i)];
                        elseif all_bmi(i)==2
                            men_1_2 = [men_1_2, all_data_clean(:, i)];
                        elseif all_bmi(i)==3
                            men_1_3 = [men_1_3, all_data_clean(:, i)];
                        else 
                            men_1_4 = [men_1_4, all_data_clean(:, i)];
                        end
                            
                    elseif all_ages(i) == 2
                        if all_bmi(i) == 1
                            men_2_1 = [men_2_1, all_data_clean(:, i)];
                        elseif all_bmi(i)==2
                            men_2_2 = [men_2_2, all_data_clean(:, i)];
                        elseif all_bmi(i) == 3
                            men_2_3 = [men_2_2, all_data_clean(:,i)];
                        else
                            men_2_4 = [men_2_4, all_data_clean(:,i)];
                        end
                    else
                        if all_bmi(i) == 1
                            men_3_1 = [men_3_1, all_data_clean(:, i)];
                        elseif all_bmi(i)==2
                            men_3_2 = [men_3_2, all_data_clean(:, i)];
                        elseif all_bmi(i) == 3
                            men_3_3 = [men_3_3, all_data_clean(:,i)];
                        else
                            men_3_4 = [men_3_4, all_data_clean(:,i)];
                        end
                    
                    end
                elseif all_genders(i) == 2
                    if all_ages(i) == 1
                        if all_bmi(i) == 1
                            women_1_1 = [women_1_1, all_data_clean(:, i)];
                        elseif all_bmi(i)==2
                            women_1_2 = [women_1_2, all_data_clean(:, i)];
                        elseif all_bmi(i)==3
                            women_1_3 = [women_1_3, all_data_clean(:, i)];
                        else 
                            women_1_4 = [women_1_4, all_data_clean(:, i)];
                        end
                            
                    elseif all_ages(i) == 2
                        if all_bmi(i) == 1
                            women_2_1 = [women_2_1, all_data_clean(:, i)];
                        elseif all_bmi(i)==2
                            women_2_2 = [women_2_2, all_data_clean(:, i)];
                        elseif all_bmi(i) == 3
                            women_2_3 = [women_2_3, all_data_clean(:,i)];
                        else
                            women_2_4 = [women_2_4, all_data_clean(:,i)];
                        end
                    else
                        if all_bmi(i) == 1
                            women_3_1 = [women_3_1, all_data_clean(:, i)];
                        elseif all_bmi(i)==2
                            women_3_2 = [women_3_2, all_data_clean(:, i)];
                        elseif all_bmi(i) == 3
                            women_3_3 = [women_3_3, all_data_clean(:,i)];
                        else
                            women_3_4 = [women_3_4, all_data_clean(:,i)];
                        end
                    
                    end
                end
            end
            
            men_1_1=mean(men_1_1,2,'omitnan');
            men_1_2=mean(men_1_2,2,'omitnan');
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

            categories={};
            i=1;
            new_title = strcat('Men distances, with BMI factor','-', title_str);
            figure;
            if(~isempty(men_1_1))
                plot(1:10, men_1_1,'DisplayName', 'Under 24 Underweight' );
                categories{i}= 'Men < 24 Underweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            if(~isempty(men_1_2))
                plot(1:10,men_1_2, 'DisplayName','Under 24 Normal weight');
                categories{i}= 'Men < 24 Normal weight';
                i=i+1;
            end
            title(new_title);
            hold on;
            if(~isempty(men_1_3))
                plot(1:10,men_1_3, 'DisplayName','Under 24 Overweight');
                categories{i} = 'Men < 24 Overweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            if(~isempty(men_1_4))
                plot(1:10,men_1_4, 'DisplayName','Under 24 Obese');
                categories{i} = 'Men < 24 Obese';
                i=i+1;
            end
            title(new_title);
            hold on;
            
            if(~isempty(men_2_1))
                plot(1:10,men_2_1, 'DisplayName','24-29 Underweight');
                categories{i} = '24 <= Men <29  Underweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            
            if(~isempty(men_2_2))
                plot(1:10,men_2_2, 'DisplayName','24-29 Normal weight');
                categories{i} = '24 <= Men <29  Normal weight';
                i=i+1;
            end
            title(new_title);
            hold on;
           
            if(~isempty(men_2_3))
                plot(1:10,men_2_3, 'DisplayName','24-29 Overweight' );
                categories{i} = '24 <= Men <29  Overweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            if(~isempty(men_2_4))
                plot(1:10,men_2_4, 'DisplayName','24-29 Obese');
                categories{i} = ' 24 <= Men <29 Obese';
                i=i+1;
            end
            title(new_title);
            hold on;

            if(~isempty(men_3_1))
                plot(1:10,men_3_1, 'DisplayName','Over 29 Underweight');
                categories{i} = 'Men >= 29 Underweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            
            if(~isempty(men_3_2))
                plot(1:10,men_3_2, 'DisplayName','Over 29 Normal weight');
                categories{i} = 'Men >= 29 Normal weight';
                i=i+1;
            end
            title(new_title);
            hold on;
           
            if(~isempty(men_3_3))
                plot(1:10,men_3_3, 'DisplayName','Over 29 Overweight' );
                categories{i} = 'Men >= 29 Overweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            if(~isempty(men_3_4))
                plot(1:10,men_3_4, 'DisplayName','Over 29 Obese');
                categories{i} = 'Men >= 29 Obese';
                i=i+1;
            end
            title(new_title);
            hold on;



            xlabel('Landmark');
            ylabel('Distances');
            xticks(1:length(landmark_names));
            xticklabels(landmark_names);
            legend('show');
            new_title = strcat('Women distances, with BMI factor ','-', title_str);
            figure;
            if(~isempty(women_1_1))
                plot(1:10, women_1_1,'DisplayName', 'Under 24 Underweight');
                categories{i} = 'Women < 24 Underweight';
                i=i+1;
            end
            title(new_title);
            hold on;
           
            if(~isempty(women_1_2))
                plot(1:10,women_1_2, 'DisplayName','Under 24 Normal weight' );
                categories{i} = 'Women < 24 Normal weight';
                i=i+1;
            end
            title(new_title);
            hold on;
            
            if(~isempty(women_1_3))
                plot(1:10,women_1_3, 'DisplayName','Under 24 Overweight');
                categories{i} = 'Women < 24 Overweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            if (~isempty(women_1_4))
                plot(1:10,women_1_4, 'DisplayName','Under 24 Obese' );
                categories{i} = 'Women < 24 Obese';
                i=i+1;
            end
            title(new_title);
            hold on;
            if(~isempty(women_2_1))
                plot(1:10,women_2_1, 'DisplayName','24-29 Underweight');
                categories{i} = ' 24 <= Women < 29 Underweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            if(~isempty(women_2_2))
                plot(1:10,women_2_2, 'DisplayName','24-29 Normal weight' );
                categories{i} = '24 <= Women < 29 Normal weight';
                i=i+1;
            end
            title(new_title);
            hold on;

            if (~isempty(women_2_3))
                plot(1:10,women_2_3, 'DisplayName','24-29 Overweight' );
                categories{i} = '24 <= Women < 29 Overweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            if (~isempty(women_2_4))
                plot(1:10,women_2_4, 'DisplayName','24-29 Obese' );
                categories{i} = '24 <= Women < 29 Obese';
                i=i+1;
            end
            if(~isempty(women_3_1))
                plot(1:10,women_3_1, 'DisplayName','Over 29 Underweight');
                categories{i} = 'Women >= 29 Underweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            if(~isempty(women_3_2))
                plot(1:10,women_3_2, 'DisplayName','Over 29 Normal weight' );
                categories{i} = 'Women >= 29 Normal weight';
                i=i+1;
            end
            title(new_title);
            hold on;

            if (~isempty(women_3_3))
                plot(1:10,women_3_3, 'DisplayName','Over 29 Overweight' );
                categories{i} = 'Women >= 29 Overweight';
                i=i+1;
            end
            title(new_title);
            hold on;
            if (~isempty(women_3_4))
                plot(1:10,women_3_4, 'DisplayName','Over 29 Obese' );
                categories{i} = 'Women >= 29 Obese';
                i=i+1;
            end
            title(new_title);
            hold on;
            xlabel('Landmark');
            ylabel('Distances');
            xticks(1:length(landmark_names));
            xticklabels(landmark_names);
            legend('show');
        
            mean_maps = [men_1_1, men_1_2, men_1_3, men_1_4, men_2_1, men_2_2, men_2_3, men_2_4,  men_3_1, men_3_2, men_3_3, men_3_4, women_1_1, women_1_2, women_1_3, women_1_4, women_2_1, women_2_2, women_2_3, women_2_4, women_3_1, women_3_2, women_3_3, women_3_4];
        
            new_title = strcat('Mean maps for each category, with BMI factor ','-', title_str);
            figure;
            hold on;
            function rgb = hex2rgb(hex)
                hex = strrep(hex, '#', '');
                rgb = [hex2dec(hex(1:2)), hex2dec(hex(3:4)), hex2dec(hex(5:6))]/255;
            end
            colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k', hex2rgb('#0072BD'), hex2rgb('#D95319'), hex2rgb('#EDB120'), hex2rgb('#7E2F8E'), hex2rgb('#77AC30'), hex2rgb('#4DBEEE'), hex2rgb('#A2142F'), hex2rgb('#7F7F7F'), hex2rgb('#D8D8D8')};
            
            for i = 1:size(mean_maps,2)
                bar(i, mean_maps(:, i), 'FaceColor', colors{i});
            end
            hold off;
            title(new_title);
            xticks(1:45)
            xlabel('Category');
            ylabel('Mean soft tissue thickness');
            set(gca, 'XTickLabel', categories);
        
        end
        
    end
end