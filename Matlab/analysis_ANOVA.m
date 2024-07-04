function [choosen_landmarks]= analysis_ANOVA (all_data,all_genders, all_ages, landmark_names)% Carica i tuoi dati

    % Inizializza la matrice per i risultati
    p = zeros(size(all_data, 1), 3);
    significant_landmark = zeros(size(all_data, 1), 3);
    F_Gender = zeros(size(all_data,1),1);
    F_Age= zeros(size(all_data,1),1);
    F_Interaction=zeros(size(all_data,1),1);
    choosen_landmarks = cell(3, 1);


    % for each landmark
    for i = 1:size(all_data, 1)
        
        

        t = table(all_data(i, :)', all_genders', all_ages', 'VariableNames', {'Landmark', 'Gender', 'Age'});
        
        % two-way ANOVA
        [~, tbl, ~] = anovan(t.Landmark, {t.Gender, t.Age}, 'model', 'interaction', 'varnames', {'Gender', 'Age'}, 'display', 'off');
        
        % p-value
        p(i, :) = cell2mat(tbl(2:end-2, 7));
        F_Gender(i,:) = cell2mat(tbl(2, 6));
        F_Age(i,:)= cell2mat(tbl(3, 6));
        F_Interaction(i,:) = cell2mat(tbl(4, 6));
       
    end
    
    % Correzione per confronti multipli
    p = mafdr(p(:), 'BHFDR', true);
    p = reshape(p, size(all_data, 1), 3);

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
    
    
    fprintf('%%%%%%%%%%%%% ANOVA results %%%%%%%%%%%%%');
    

    if (~isempty(significant_gender_indices)) 
        choosen_landmarks{1} = significant_gender_indices;
        fprintf('In an initial ANOVA analysis, it allows me to say that for the gender analysis, the most significant landmark are:\n\n');
        for i=1:length(significant_gender_indices)
            fprintf('%s\n', landmark_names{significant_gender_indices(i)});
        end
    else
        fprintf(['In an initial ANOVA analysis, it allows me to say that for the gender analysis \n' ...
            'there are no significant landmark for classification by Gender\n']);
    end
    if (~isempty(significant_age_indices)) 
        choosen_landmarks{2} = significant_age_indices;
        fprintf('In an initial ANOVA analysis, it allows me to say that for the age analysis, the most significant landmark are:\n\n');
        for i=1:length(significant_age_indices)
            fprintf('%s\n', landmark_names{significant_age_indices(i)});
        end
    else
        fprintf(['In an initial ANOVA analysis, it allows me to say that for the gender analysis\n' ...
            'there are no significant landmark for classification by Age\n\n']);
    end
    if (~isempty(significant_interaction_indices)) 
        choosen_landmarks{3} = significant_interaction_indices;
        fprintf(['In an initial ANOVA analysis, it allows me to say that for the analysis of the interaction of age and gender, \n' ...
            'the most significant landmark are:\n\n']);
        
        for i=1:length(significant_interaction_indices)
            fprintf('%s', landmark_names{significant_interaction_indices(i)});
        end
    else
       fprintf(['In an initial ANOVA analysis, it allows me to say that for the analysis of the interaction of age and gender \n' ...
            'there are no significant landmark for classification by Age and Gender\n\n']);
    end

    figure;
    bar(p);
    xticks(1:size(all_data, 1));
    xticklabels(landmark_names);
    xtickangle(45);
    xlabel('Landmark');
    ylabel('p-value');
    title('Importance for each landmark');
    
    % Aggiungi una linea orizzontale al livello di significatività
    hold on;
    line(xlim, [0.05, 0.05], 'Color', 'red', 'LineStyle', '--');
    hold off;
    
    % Mostra la legenda
    legend({'Gender', 'Age', 'Interaction'}, 'Location', 'northoutside');


end
