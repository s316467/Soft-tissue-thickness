classdef ANCOVA

    methods(Static)

        function [choosen_landmarks]= analysis_ANCOVA (all_data,all_genders, all_ages, landmark_names, title_str)% Carica i tuoi dati
        
            % Inizializza la matrice per i risultati
            p = zeros(size(all_data, 1), 3);
            significant_landmark = zeros(size(all_data, 1), 3);
            F_Gender = zeros(size(all_data,1),1);
            F_Age= zeros(size(all_data,1),1);
            F_Interaction=zeros(size(all_data,1),1);
            choosen_landmarks = cell(3, 1);
            
            title_new = strcat ('ANCOVA analysis with age and gender analysis-',title_str);
            
           for i = 1:size(all_data, 1)
                % Crea una tabella con i tuoi dati
                t = table(all_data(i, :)', double(all_genders'), double(all_ages'), 'VariableNames', {'Landmark', 'Gender', 'Age'});
                
                % Adatta un modello ANCOVA ai tuoi dati
                mdl = fitlm(t, 'Landmark ~ Gender + Age + Gender:Age');
                
                % Ottieni i p-values dal modello
                p(i,:) = mdl.Coefficients.pValue(2:end)';
                
                % Ottieni le statistiche F dal modello
                F_Gender(i,:) = mdl.Coefficients.tStat(2);
                F_Age(i,:) = mdl.Coefficients.tStat(3);
                F_Interaction(i,:) = mdl.Coefficients.tStat(4);
            end

            
        
        
            for i=1:length(landmark_names)
                % A low p-value indicates that it is unlikely to obtain the observed data if the null hypothesis (i.e., there 
                % is no difference between the groups) were true.
        
                % The F ratio is the ratio between the variance between groups and the variance within groups. 
                % An F ratio of 1 suggests that the variance between groups is equal to the variance within groups. 
                % Therefore, an F ratio greater than 1 might suggest that there is a significant difference between the groups. 
                % A large F ratio with a low p-value (below the significance level) indicates that it is unlikely to obtain 
                % the observed data if the null hypothesis were true, suggesting that there is a significant difference between the groups.
                significant_landmark(i, :) = p(i,1:3) < 0.05 & ( F_Gender(i) > 1 | F_Age(i) >1 | F_Interaction(i) >1);
                
            end
        
            
            % A significant interaction effect between gender and age would suggest that the effect of gender on landmarks depends on age,
            % or vice versa. For example, it could be that a particular landmark differs significantly between men and women, but only in 
            % a particular age group.
        
            % fprintf('Landmark\tP (Gender)\tP (Age)\tP (Interaction)\t  (F Gender)\t (F Age)\t (F Interaction)\n');
            % for i = 1:size(all_data, 1)
            %     fprintf('%d\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', i, p(i, 1), p(i, 2), p(i, 3), F_Gender(i), F_Age(i), F_Interaction(i));
            % end
            
            significant_gender_indices = find(significant_landmark(:, 1) == 1);
            
            significant_age_indices = find(significant_landmark(:, 2) == 1);
            
            significant_interaction_indices = find(significant_landmark(:, 3) == 1);
            
        
        
            % Significant landmarks
            % fprintf('\nSignificant Landmarks (1 = Yes, 0 = No):\n');
            % for i = 1:size(all_data, 1)
            %     fprintf('Landmark %d:\tGender: %d\tAge: %d\tInteraction: %d\n', i, significant_landmark(i, 1), significant_landmark(i, 2), significant_landmark(i, 3));
            % end
            
            
            fprintf('ANCOVA results');
            
        
            if (~isempty(significant_gender_indices)) 
                choosen_landmarks{1} = significant_gender_indices;
                fprintf('It allows me to say that for the gender analysis, the most significant landmark are:\n\n');
                for i=1:length(significant_gender_indices)
                    fprintf('%s\n', landmark_names{significant_gender_indices(i)});
                end
            else
                fprintf(['It allows me to say that for the gender analysis \n' ...
                    'there are no significant landmark for classification by Gender\n']);
            end
            if (~isempty(significant_age_indices)) 
                choosen_landmarks{2} = significant_age_indices;
                fprintf('It allows me to say that for the age analysis, the most significant landmark are:\n\n');
                for i=1:length(significant_age_indices)
                    fprintf('%s\n', landmark_names{significant_age_indices(i)});
                end
            else
                fprintf(['It allows me to say that for the gender analysis\n' ...
                    'there are no significant landmark for classification by Age\n\n']);
            end
            if (~isempty(significant_interaction_indices)) 
                choosen_landmarks{3} = significant_interaction_indices;
                fprintf(['It allows me to say that for the analysis of the interaction of age and gender, \n' ...
                    'the most significant landmark are:\n\n']);
                
                for i=1:length(significant_interaction_indices)
                    fprintf('%s\n', landmark_names{significant_interaction_indices(i)});
                end
            else
               fprintf(['It allows me to say that for the analysis of the interaction of age and gender \n' ...
                    'there are no significant landmark for classification by Age and Gender\n\n']);
            end
        
            figure;
            bar(p);
            xticks(1:size(all_data, 1));
            xticklabels(landmark_names);
            xtickangle(45);
            xlabel('Landmark');
            ylabel('p-value');
            title(title_new);
            
            % Aggiungi una linea orizzontale al livello di significatività
            hold on;
            line(xlim, [0.05, 0.05], 'Color', 'red', 'LineStyle', '--');
            hold off;
            
            % Mostra la legenda
            legend({'Gender', 'Age', 'Interaction'}, 'Location', 'northoutside');
        
        
        end




        %%%%%%%%%%%%%%%%%%%% for BMI analysis 

        function [choosen_landmarks]= analysis_ANCOVA_bmi (all_data,all_genders, all_ages, all_bmi, landmark_names, title_str)% Carica i tuoi dati

                % Inizializza la matrice per i risultati
                p = zeros(size(all_data, 1), 7);
                significant_landmark = zeros(size(all_data, 1), 7);
                F_Gender = zeros(size(all_data,1),1);
                F_Age= zeros(size(all_data,1),1);
                F_BMI = zeros(size(all_data,1),1);
                F_Interaction_GA=zeros(size(all_data,1),1);
                F_Interaction_GB=zeros(size(all_data,1),1);
                F_Interaction_AB=zeros(size(all_data,1),1);
                F_Interaction_GAB=zeros(size(all_data,1),1);
                choosen_landmarks = cell(7, 1);
                title_new = strcat ('ANCOVA analysis with BMI analysis-',title_str);
            
                
                for i = 1:size(all_data, 1)
                    % Crea una tabella con i tuoi dati
                    t = table(all_data(i, :)', double(all_genders'), double(all_ages'), all_bmi', 'VariableNames', {'Landmark', 'Gender', 'Age', 'BMI'});
                    
                    % Adatta un modello ANCOVA ai tuoi dati
                    mdl = fitlm(t, 'Landmark ~ Gender + Age + BMI + Gender:Age + Gender:BMI + Age:BMI + Gender:Age:BMI');
                    
                    % Ottieni i p-values dal modello
                    p(i,:) = mdl.Coefficients.pValue(2:end)';
                    
                    % Ottieni le statistiche F dal modello
                    F_Gender(i,:) = mdl.Coefficients.tStat(2);
                    F_Age(i,:) = mdl.Coefficients.tStat(3);
                    F_BMI(i,:) = mdl.Coefficients.tStat(4);
                    F_Interaction_GA(i,:) = mdl.Coefficients.tStat(5);
                    F_Interaction_GB(i,:) = mdl.Coefficients.tStat(6);
                    F_Interaction_AB(i,:) = mdl.Coefficients.tStat(7);
                    F_Interaction_GAB(i,:) = mdl.Coefficients.tStat(8);
                    
                end

                 for i=1:length(landmark_names)
                   

                    % - p(i,1) is the p-value for the effect of gender. A low p-value suggests that gender has a significant effect 
                    % on the response variable.
                    % - p(i,2) is the p-value for the effect of age. A low p-value suggests that age has a significant effect on 
                    % the response variable.
                    % - p(i,3) is the p-value for the effect of BMI. A low p-value suggests that BMI has a significant effect on the 
                    % response variable.
                    % - p(i,4) is the p-value for the interaction between gender and age. A low p-value suggests that the effect of 
                    % gender on the response variable depends on age.
                    % - p(i,5) is the p-value for the interaction between gender and BMI. A low p-value suggests that the effect of 
                    % gender on the response variable depends on BMI.
                    % - p(i,6) is the p-value for the interaction between age and BMI. A low p-value suggests that the effect of age 
                    % on the response variable depends on BMI.
                    % - p(i,7) is the p-value for the interaction between gender, age, and BMI. A low p-value suggests that the effect 
                    % of gender on the response variable depends on both age and BMI.
                    
                    significant_landmark(i, :) = p(i,1:7) < 0.05 & ( F_Gender(i) > 1 | F_Age(i) >1 | F_BMI(i)>1| F_Interaction_GA(i) >1 | F_Interaction_GB(i)>1 | F_Interaction_AB(i)>1 | F_Interaction_GAB(i)>1);
                 
                 end

                significant_gender_indices = find(significant_landmark(:, 1) == 1);
                
                significant_age_indices = find(significant_landmark(:, 2) == 1);
                
                significant_bmi_indices = find(significant_landmark(:, 3) == 1);
            
                significant_interactionGA_indices = find(significant_landmark(:, 4) == 1);
            
                significant_interactionGB_indices = find(significant_landmark(:, 5) == 1);
            
                significant_interactionAB_indices = find(significant_landmark(:, 6) == 1);
            
                significant_interactionGAB_indices = find(significant_landmark(:,7) == 1);



                if (~isempty(significant_gender_indices)) 
                    choosen_landmarks{1} = significant_gender_indices;
                    fprintf('\nIt allows me to say that for the gender analysis, the most significant landmark are:\n\n');
                    for i=1:length(significant_gender_indices)
                        fprintf('%s\n', landmark_names{significant_gender_indices(i)});
                    end
                else
                    fprintf(['\nIt allows me to say that for the gender analysis \n' ...
                        'there are no significant landmark for classification by Gender\n']);
                end
                if (~isempty(significant_age_indices)) 
                    choosen_landmarks{2} = significant_age_indices;
                    fprintf('\nt allows me to say that for the age analysis, the most significant landmark are:\n\n');
                    for i=1:length(significant_age_indices)
                        fprintf('%s\n', landmark_names{significant_age_indices(i)});
                    end
                else
                    fprintf(['\nIt allows me to say that for the gender analysis\n' ...
                        'there are no significant landmark for classification by Age\n\n']);
                end
                if (~isempty(significant_bmi_indices)) 
                    choosen_landmarks{3} = significant_bmi_indices;
                    fprintf('nIt allows me to say that for the BMI analysis, the most significant landmark are:\n\n');
                    for i=1:length(significant_bmi_indices)
                        fprintf('%s\n', landmark_names{significant_bmi_indices(i)});
                    end
                else
                    fprintf(['\nIt allows me to say that for the BMI analysis\n' ...
                        'there are no significant landmark for classification by BMI \n\n']);
                end
            
                if (~isempty(significant_interactionGA_indices)) 
                    choosen_landmarks{4} = significant_interactionGA_indices;
                    fprintf(['\nIt allows me to say that for the analysis of the interaction of age and gender, \n' ...
                        'the most significant landmark are:\n\n']);
                    
                    for i=1:length(significant_interactionGA_indices)
                        fprintf('%s\n', landmark_names{significant_interactionGA_indices(i)});
                    end
                else
                   fprintf(['\nIt allows me to say that for the analysis of the interaction of age and gender \n' ...
                        'there are no significant landmark for classification by Age and Gender\n\n']);
                end
            
            
                 if (~isempty(significant_interactionGB_indices)) 
                    choosen_landmarks{5} = significant_interactionGB_indices;
                    fprintf(['\nIt allows me to say that for the analysis of the interaction of gender and BMI, \n' ...
                        'the most significant landmark are:\n\n']);
                    
                    for i=1:length(significant_interactionGB_indices)
                        fprintf('%s\n', landmark_names{significant_interactionGB_indices(i)});
                    end
                else
                   fprintf(['\nIt allows me to say that for the analysis of the interaction of  gender and BMI \n' ...
                        'there are no significant landmark for classification by Gender and BMI \n\n']);
                 end
            
            
                 if (~isempty(significant_interactionAB_indices)) 
                    choosen_landmarks{6} = significant_interactionAB_indices;
                    fprintf(['\nIt allows me to say that for the analysis of the interaction of age and BMI, \n' ...
                        'the most significant landmark are:\n\n']);
                    
                    for i=1:length(significant_interactionAB_indices)
                        fprintf('%s\n', landmark_names{significant_interactionAB_indices(i)});
                    end
                else
                   fprintf(['\nIt allows me to say that for the analysis of the interaction of age and BMI \n' ...
                        'there are no significant landmark for classification by age and BMI \n\n']);
                 end
            
                 if (~isempty(significant_interactionGAB_indices)) 
                    choosen_landmarks{7} = significant_interactionGAB_indices;
                    fprintf(['\nIt allows me to say that for the analysis of the interaction of age, gender and BMI, \n' ...
                        'the most significant landmark are:\n\n']);
                    
                    for i=1:length(significant_interactionGAB_indices)
                        fprintf('%s\n', landmark_names{significant_interactionGAB_indices(i)});
                    end
                else
                   fprintf(['\nIt allows me to say that for the analysis of the interaction of age, gender and BMI \n' ...
                        'there are no significant landmark for classification by age, gender and BMI \n\n']);
                end
            
                figure;
                bar(p);
                xticks(1:size(all_data, 1));
                xticklabels(landmark_names);
                xtickangle(45);
                xlabel('Landmark');
                ylabel('p-value');
                title(title_new);
                
                % Aggiungi una linea orizzontale al livello di significatività
                hold on;
                line(xlim, [0.05, 0.05], 'Color', 'red', 'LineStyle', '--');
                hold off;
                
                % Mostra la legenda
                legend({'Gender', 'Age', 'BMI', 'Gender-Age', 'Gender-BMI', 'Age-BMI', 'Gender-Age-BMI'}, 'Location', 'northoutside');
            
            

            end


    end
end