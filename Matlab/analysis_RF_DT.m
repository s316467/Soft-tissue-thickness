  
function [idx_rf_age,idx_rf_sex,idx_rf,idx_dt_age,idx_dt_sex,idx_dt,model_age,model_sex,model_ga]=analysis_RF_DT(landmark_names, all_data, all_genders, all_ages)

    num_landmarks = length(landmark_names);
    
    % Dividi il dataset in k parti (ad esempio, k = 5)
    k = 5;
    accuracy_sex_rf_fold=zeros(k, 1);
    accuracy_sex_dt_fold=zeros(k, 1);
    accuracy_age_rf_fold=zeros(k, 1);
    accuracy_age_dt_fold=zeros(k, 1);
    accuracy_dt_fold=zeros(k, 1);
    accuracy_rf_fold=zeros(k, 1);
    
    importance_rf_sex_fold = cell(k, 1);
    importance_rf_age_fold = cell(k, 1);
    importance_dt_sex_fold = cell(k, 1);
    importance_dt_age_fold = cell(k, 1);
    importance_dt_fold = cell(k, 1);
    importance_rf_fold = cell(k, 1);

    for i=1:length(landmark_names)
        row = all_data(i, :);
        
        nan_idx = isnan(row);
        
        mean_value = mean(row(~nan_idx), 'omitnan');
        
        row(nan_idx) = mean_value;
        
        all_data(i, :) = row;
    end

    modified_landmark_names = regexprep(landmark_names, '[\s\(\)\-]', '');
    combined_labels = strcat(string(all_genders), '_', string(all_ages));

    % Creazione di oggetti cvpartition per ciascun set di etichette
    cv_genders = cvpartition(all_genders, 'KFold', k, 'Stratify', true);
    cv_ages = cvpartition(all_ages, 'KFold', k, 'Stratify', true);
    cv_combined = cvpartition(combined_labels, 'KFold', k, 'Stratify', true);

    
    % Inizia l'iterazione attraverso le parti
    for fold = 1:k


        trainIdx_genders = cv_genders.training(fold);
        testIdx_genders = cv_genders.test(fold);
        trainIdx_ages = cv_ages.training(fold);
        testIdx_ages = cv_ages.test(fold);
        trainIdx_combined = cv_combined.training(fold);
        testIdx_combined = cv_combined.test(fold);
    
        % Dati di training e test
        X_train_fold_genders = all_data(:, trainIdx_genders);
        X_test_fold_genders = all_data(:, testIdx_genders);
        X_train_fold_ages = all_data(:, trainIdx_ages);
        X_test_fold_ages = all_data(:, testIdx_ages);
        X_train_fold_combined = all_data(:, trainIdx_combined);
        X_test_fold_combined = all_data(:, testIdx_combined);
    
        y_sex_train_fold = all_genders(trainIdx_genders);
        y_sex_test_fold = all_genders(testIdx_genders);
        y_age_train_fold = all_ages(trainIdx_ages);
        y_age_test_fold = all_ages(testIdx_ages);
        y_train_fold = combined_labels(trainIdx_combined);
        y_test_fold = combined_labels(testIdx_combined);
    
        % Addestramento e valutazione Random Forest
        rfModel_sex_fold = TreeBagger(100, X_train_fold_genders', y_sex_train_fold, 'Method', 'classification', 'OOBPredictorImportance', 'on');
        rfModel_age_fold = TreeBagger(100, X_train_fold_ages', y_age_train_fold, 'Method', 'classification', 'OOBPredictorImportance', 'on');
    
        % Valutazione Random Forest
        [y_sex_pred_rf_fold, ~] = predict(rfModel_sex_fold, X_test_fold_genders');
        accuracy_sex_rf_fold(fold) = sum(str2double(y_sex_pred_rf_fold') == double(y_sex_test_fold)) / length(y_sex_test_fold);
    
        [y_age_pred_rf_fold, ~] = predict(rfModel_age_fold, X_test_fold_ages');
        accuracy_age_rf_fold(fold) = sum(str2double(y_age_pred_rf_fold') == double(y_age_test_fold)) / length(y_age_test_fold);
    
        importance_rf_sex_fold{fold} = rfModel_sex_fold.OOBPermutedPredictorDeltaError;
        importance_rf_age_fold{fold} = rfModel_age_fold.OOBPermutedPredictorDeltaError;
    
        % Addestramento e valutazione Albero di Decisione
        dtModel_sex_fold = fitctree(X_train_fold_genders', y_sex_train_fold');
        dtModel_age_fold = fitctree(X_train_fold_ages', y_age_train_fold');
    
        % Valutazione Albero di Decisione
        [y_sex_pred_dt_fold, ~] = predict(dtModel_sex_fold, X_test_fold_genders');
        accuracy_sex_dt_fold(fold) = sum(double(y_sex_pred_dt_fold') == double(y_sex_test_fold)) / length(y_sex_test_fold);
    
        [y_age_pred_dt_fold, ~] = predict(dtModel_age_fold, X_test_fold_ages');
        accuracy_age_dt_fold(fold) = sum(double(y_age_pred_dt_fold') == double(y_age_test_fold)) / length(y_age_test_fold);
    
        importance_dt_age_fold{fold} = predictorImportance(dtModel_age_fold);
        importance_dt_sex_fold{fold} = predictorImportance(dtModel_sex_fold);
    
        % Addestramento e valutazione Random Forest per etichette combinate
        rfModel_combined = TreeBagger(100,  X_train_fold_combined', y_train_fold, 'Method', 'classification', 'OOBPredictorImportance', 'on');
    
        [y_pred_rf_fold, ~] = predict(rfModel_combined, X_test_fold_combined');
        accuracy_rf_fold(fold) = sum(strcmp(y_pred_rf_fold', y_test_fold)) / length(y_test_fold);
    
        importance_rf_fold{fold} = rfModel_combined.OOBPermutedPredictorDeltaError;
    
        % Addestramento e valutazione Decision Tree per etichette combinate
        dtModel_combined = fitctree( X_train_fold_combined', y_train_fold);
    
        [y_pred_dt_fold, ~] = predict(dtModel_combined, X_test_fold_combined');
        accuracy_dt_fold(fold) = sum(strcmp(y_pred_dt_fold', y_test_fold)) / length(y_test_fold);
    
        importance_dt_fold{fold} = predictorImportance(dtModel_combined);
    end

    
    mean_accuracy_rf_sex = mean(accuracy_sex_rf_fold);
    mean_accuracy_rf_age = mean(accuracy_age_rf_fold);
    mean_accuracy_dt_sex = mean(accuracy_sex_dt_fold);
    mean_accuracy_dt_age = mean(accuracy_age_dt_fold);
    mean_accuracy_dt = mean(accuracy_dt_fold);
    mean_accuracy_rf = mean(accuracy_rf_fold);
    


    % Alla fine delle iterazioni, calcola le medie delle feature importances
    importance_rf_sex = mean(cell2mat(importance_rf_sex_fold))
    importance_rf_age = mean(cell2mat(importance_rf_age_fold));
    importance_dt_sex = mean(cell2mat(importance_dt_sex_fold));
    importance_dt_age = mean(cell2mat(importance_dt_age_fold));
    importance_dt = mean(cell2mat(importance_dt_fold));
    importance_rf = mean(cell2mat(importance_rf_fold));
    
   % Calcola gli indici dei valori positivi
    positive_idx_rf_sex = find(importance_rf_sex > 0);
    positive_idx_rf_age = find(importance_rf_age > 0);
    positive_idx_dt_sex = find(importance_dt_sex > 0);
    positive_idx_dt_age = find(importance_dt_age > 0);
    positive_idx_rf = find(importance_rf > 0);
    positive_idx_dt = find(importance_dt > 0);
    
    % Ordina solo i valori positivi
    [sorted, ~] = sort(importance_rf_sex(positive_idx_rf_sex), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_3_rf_sex = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_rf_sex = zeros(1, length(top_3_rf_sex));
    
    % Cerca ogni valore di top_3_rf_sex in importance_rf_sex
    for i = 1:length(top_3_rf_sex)
        idx_rf_sex(i) = find(importance_rf_sex == top_3_rf_sex(i), 1)
    end


    
    [sorted, ~] = sort(importance_rf_age(positive_idx_rf_age), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_3_rf_age = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_rf_age = zeros(1, length(top_3_rf_age));
    
    % Cerca ogni valore di top_3_rf_sex in importance_rf_sex
    for i = 1:length(top_3_rf_age)
        idx_rf_age(i) = find(importance_rf_age == top_3_rf_age(i), 1);
    end


    [sorted,~ ] = sort(importance_dt_sex(positive_idx_dt_sex), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_3_dt_sex = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_dt_sex = zeros(1, length(top_3_dt_sex));
    
    % Cerca ogni valore di top_3_rf_sex in importance_rf_sex
    for i = 1:length(top_3_dt_sex)
        idx_dt_sex(i) = find(importance_dt_sex == top_3_dt_sex(i), 1);
    end
    
    [sorted, ~] = sort(importance_dt_age(positive_idx_dt_age), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_3_dt_age = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_dt_age = zeros(1, length(top_3_dt_age));
    
    % Cerca ogni valore di top_3_rf_sex in importance_rf_sex
    for i = 1:length(top_3_dt_age)
        idx_dt_age(i) = find(importance_dt_age == top_3_dt_age(i), 1);
    end
    

    [sorted, ~] = sort(importance_rf(positive_idx_rf), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_3_rf = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_rf = zeros(1, length(top_3_rf));
    
    % Cerca ogni valore di top_3_rf_sex in importance_rf_sex
    for i = 1:length(top_3_rf)
        idx_rf(i) = find(importance_rf == top_3_rf(i), 1)
    end

    
    [sorted, ~] = sort(importance_dt(positive_idx_dt), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_3_dt = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_dt = zeros(1, length(top_3_dt));
    
    % Cerca ogni valore di top_3_rf_sex in importance_rf_sex
    for i = 1:length(top_3_dt)
        idx_dt(i) = find(importance_dt == top_3_dt(i), 1);
    end



    % Visualizza i risultati 

    fprintf('\n\nAccuracy for gender analysis with Random Forest : %.2f%%\n', mean_accuracy_rf_sex * 100);
    fprintf('\n\nAccuracy for age analysis with Random Forest : %.2f%%\n', mean_accuracy_rf_age * 100);
    
    fprintf('Accuracy for gender analysis with Decision Tree: %.2f%%\n', mean_accuracy_dt_sex * 100);
    fprintf('Accuracy for age analysis with Decision Tree: %.2f%%\n', mean_accuracy_dt_age * 100);
    


   

    choosing_model = 'Decision Tree';
    top3_age=top_3_dt_age;
    top3_gender=top_3_dt_sex;
    index_age= idx_dt_age;
    index_gender = idx_dt_sex;

    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%% DECISION TREE FOR AGE AND GENDER ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%\n');

    fprintf('Analysis for the model %s', choosing_model );
    fprintf('\n\nGender top-3 landmarks for gender classification are: ');
    for i = 1:length(top3_gender)
        fprintf('%s ', landmark_names{idx_dt_sex(i)});
    end
    fprintf('\n\n');
    
    fprintf('Gender top-3 landmarks for age classification are: ');
    for i = 1:length(top3_age)
        fprintf('%s ', landmark_names{idx_dt_age(i)});
    end
    fprintf('\n\n');

    fprintf('In the order we have for gender classification\n');
    fprintf('%s\n', landmark_names{index_gender});
    fprintf('In the order we have for age classification\n');
    fprintf('%s\n', landmark_names{index_age});
    % 
    % map_gender = containers.Map({'1', '2'}, {'M','F'});
    % 
    % for j=1:3
    %     figure;
    % 
    %     boxplot(all_data(index_gender(j),:), all_genders) ;
    %     title ('Distribution of the most important feature by Gender');
    %     xlabel ( 'Gender' ) ;
    %     ylabel(sprintf( 'Importance of the landmark %s ', landmark_names{index_gender(j)}));
    % 
    %     % Ottenere le etichette correnti
    %     labels = xticklabels;
    % 
    %     % Mappare le etichette correnti a quelle desiderate
    %     new_labels = cell(size(labels));
    %     for i = 1:length(labels)
    %         if isKey(map_gender, labels{i})
    %             new_labels{i} = map_gender(labels{i});
    %         else
    %             new_labels{i} = labels{i};
    %         end
    %     end
    % 
    %     % Impostare le nuove etichette
    %     xticklabels(new_labels);
    % end
    % 
    %  map_age = containers.Map({'1', '2', '3'}, {'U30','30-50','O50'});
    % 
    % 
    % for j=1:3
    %     figure;
    % 
    %     boxplot(all_data(index_age(j),:), all_ages) ;
    %     title ('Distribution of the most important feature by Age');
    %     xlabel ( 'Age' ) ;
    %     ylabel(sprintf( 'Importance of the landmark %s ', landmark_names{index_age(j)}));
    % 
    %     % Ottenere le etichette correnti
    %     labels = xticklabels;
    % 
    %     % Mappare le etichette correnti a quelle desiderate
    %     new_labels = cell(size(labels));
    %     for i = 1:length(labels)
    %         if isKey(map_age, labels{i})
    %             new_labels{i} = map_age(labels{i});
    %         else
    %             new_labels{i} = labels{i};
    %         end
    %     end
    % 
    %     % Impostare le nuove etichette
    %     xticklabels(new_labels);
    % end
    

    choosing_model = 'Random Forest';
    top3_age=top_3_rf_age;
    top3_gender=top_3_rf_sex;
    index_age= idx_rf_age;
    index_gender = idx_rf_sex;

    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%% RANDOM FOREST FOR AGE AND GENDER ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%\n');

    fprintf('Analysis for the model %s', choosing_model );
    fprintf('\n\nGender top-3 landmarks for gender classification are: ');
    for i = 1:length(top3_gender)
        fprintf('%s ', landmark_names{idx_rf_sex(i)});
    end
    fprintf('\n\n');
    
    fprintf('Gender top-3 landmarks for age classification are: ');
    for i = 1:length(top3_age)
        fprintf('%s ', landmark_names{idx_rf_age(i)});
    end
    fprintf('\n\n');
    fprintf('In the order we have for gender classification\n');
    fprintf('%s\n', landmark_names{index_gender});
    fprintf('In the order we have for age classification\n');
    fprintf('%s\n', landmark_names{index_age});

    % map_gender = containers.Map({'1', '2'}, {'M','F'});

    % for j=1:3
    %     figure;
    % 
    %     boxplot(all_data(index_gender(j),:), all_genders) ;
    %     title ('Distribution of the most important feature by Gender');
    %     xlabel ( 'Gender' ) ;
    %     ylabel(sprintf( 'Importance of the landmark %s ', landmark_names{index_gender(j)}));
    % 
    %     % Ottenere le etichette correnti
    %     labels = xticklabels;
    % 
    %     % Mappare le etichette correnti a quelle desiderate
    %     new_labels = cell(size(labels));
    %     for i = 1:length(labels)
    %         if isKey(map_gender, labels{i})
    %             new_labels{i} = map_gender(labels{i});
    %         else
    %             new_labels{i} = labels{i};
    %         end
    %     end
    % 
    %     % Impostare le nuove etichette
    %     xticklabels(new_labels);
    % end
    % 
    %  map_age = containers.Map({'1', '2', '3'}, {'U30','30-50','O50'});
    % 
    % 
    % for j=1:3
    %     figure;
    % 
    %     boxplot(all_data(index_age(j),:), all_ages) ;
    %     title ('Distribution of the most important feature by Age');
    %     xlabel ( 'Age' ) ;
    %     ylabel(sprintf( 'Importance of the landmark %s ', landmark_names{index_age(j)}));
    % 
    %     % Ottenere le etichette correnti
    %     labels = xticklabels;
    % 
    %     % Mappare le etichette correnti a quelle desiderate
    %     new_labels = cell(size(labels));
    %     for i = 1:length(labels)
    %         if isKey(map_age, labels{i})
    %             new_labels{i} = map_age(labels{i});
    %         else
    %             new_labels{i} = labels{i};
    %         end
    %     end
    % 
    %     % Impostare le nuove etichette
    %     xticklabels(new_labels);
    % end
    % 
    % 

   % For gender importance
    figure;
    subplot(1, 2, 1);
    rgb_colors = zeros(num_landmarks, 3); 
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_rf_sex, :) = repmat([1 0 0], length(idx_rf_sex), 1); % red for the top 3
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_rf_sex(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title('Importance for Gender for Random Forest');

    
    subplot(1, 2, 2);
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_dt_sex, :) = repmat([1 0 0], length(idx_dt_sex), 1); % red for the top 3
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_dt_sex(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title('Importance for Gender for SDT');

    
    % For age importance
    figure;
    subplot(1, 2, 1);
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_rf_age, :) = repmat([1 0 0], length(idx_rf_age), 1); % red for the top 3
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_rf_age(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title('Importance for Age for Random Forest');
    
    subplot(1, 2, 2);
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_dt_age, :) = repmat([1 0 0], length(idx_dt_age), 1); % red for the top 3
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_dt_age(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title('Importance for Age for SDT');
    
    %%% Combined Labels
    
    choosing_model = 'Decision Tree';
    top3=top_3_dt;
    index= idx_dt;
    
    fprintf('Accuracy with Decision Tree with combined labels: %.2f%%\n', mean_accuracy_dt*100);
    fprintf('Accuracy with Random Fores with combined labels: %.2f%%\n', mean_accuracy_rf*100);
    
    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%% DECISION TREE FOR COMBINED LABEL ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%\n');
    fprintf('Analysis for the model %s\n', choosing_model );
    fprintf('In the order we have for combined classification\n');
    fprintf('%s\n', landmark_names{index});
    for i = 1:length(top3)
        fprintf('%s ', landmark_names{idx_dt(i)});
    end
    fprintf('\n\n');
    
    
            
    % % Creare un dizionario di corrispondenza
    % map = containers.Map({'1_2', '1_3', '2_3', '1_1', '2_1','2_2'}, {'M_30_50', 'M_O50', 'F_O50', 'M_U30', 'F_U30', 'F_30_50'});
    % 
    % for j=1:3
    %     figure;
    % 
    %     boxplot(all_data(index(j),:), combined_labels);
    %     title ('Distribution of the most important feature in combined labels');
    %     xlabel ( 'Gender' );
    %     ylabel(sprintf( 'Importance of the landmark %s ', landmark_names{index(j)}));
    % 
    %     % Ottenere le etichette correnti
    %     labels = xticklabels;
    % 
    %     % Mappare le etichette correnti a quelle desiderate
    %     new_labels = cell(size(labels));
    %     for i = 1:length(labels)
    %         if isKey(map, labels{i})
    %             new_labels{i} = map(labels{i});
    %         else
    %             new_labels{i} = labels{i};
    %         end
    %     end
    % 
    %     % Impostare le nuove etichette
    %     xticklabels(new_labels);
    % end
    % 
    % 
    % 
   

    % 
    % % Creare un dizionario di corrispondenza
    % map = containers.Map({'1_2', '1_3', '2_3', '1_1', '2_1','2_2'}, {'M_30_50', 'M_O50', 'F_O50', 'M_U30', 'F_U30', 'F_30_50'});
    % 
    % for j=1:3
    %     figure;
    % 
    %     boxplot(all_data(index(j),:), combined_labels);
    %     title ('Distribution of the most important feature in combined labels');
    %     xlabel ( 'Gender' );
    %     ylabel(sprintf( 'Importance of the landmark %s ', landmark_names{index(j)}));
    % 
    %     % Ottenere le etichette correnti
    %     labels = xticklabels;
    % 
    %     % Mappare le etichette correnti a quelle desiderate
    %     new_labels = cell(size(labels));
    %     for i = 1:length(labels)
    %         if isKey(map, labels{i})
    %             new_labels{i} = map(labels{i});
    %         else
    %             new_labels{i} = labels{i};
    %         end
    %     end
    % 
    %     % Impostare le nuove etichette
    %     xticklabels(new_labels);
    % end
    % 
    % 
    % 


    choosing_model= 'Random Forest';
    top3=top_3_rf;
    index= idx_rf;

    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%% RANDOM FOREST FOR COMBINED LABEL ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%\n\n');

    fprintf('Analysis for the model %s', choosing_model );
    fprintf('In the order we have for combined classification\n');
    fprintf('%s\n', landmark_names{index});
    for i = 1:length(top3)
        fprintf('%s ', landmark_names{idx_dt(i)});
    end
    fprintf('\n\n');
    



    figure;
    subplot(1, 2, 1);
    
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % 
    rgb_colors(idx_rf(1:3), :) = repmat([1 0 0], length(idx_rf(1:3)), 1); 
    
        
    % Draw each bar individually
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_rf(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title('Importance for combined labels for Random Forest');
    
        
    % Crea un array di colori RGB
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % il colore predefinito è blu
    rgb_colors(idx_dt(1:3), :) = repmat([1 0 0], length(idx_dt(1:3)), 1); % rosso per i primi 3
    
    % Disegna ogni barra individualmente
    subplot(1, 2, 2);
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_dt(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title('Importance for combined labels for SDT');

    
    if(mean_accuracy_rf_age > mean_accuracy_dt_age)
        model_age = 'Random Forest';
    else
        model_age = 'Decision Tree';
    end

    if(mean_accuracy_rf_sex > mean_accuracy_dt_sex)
        model_sex = 'Random Forest';
    else
        model_sex = 'Decision Tree';
    end
    if(mean_accuracy_rf > mean_accuracy_dt)
        model_ga = 'Random Forest';
    else
        model_ga = 'Decision Tree';
    end
       


    

end
