  
function [idx_rf_ab,idx_rf_gb, idx_rf_bmi, idx_rf_gab,idx_dt_bmi,idx_dt_gb, idx_dt_ab,idx_dt_gab, model_bmi, model_gb, model_ab, model_gab]=analysis_RF_DT_BMI(landmark_names, all_data, all_genders, all_ages, all_bmi)

    num_landmarks = length(landmark_names);
    
    % Dividi il dataset in k parti (ad esempio, k = 5)
    k = 10;
    accuracy_bmi_rf_fold=zeros(k, 1); %sex
    accuracy_bmi_dt_fold=zeros(k, 1);
    accuracy_gab_rf_fold=zeros(k, 1);
    accuracy_gab_dt_fold=zeros(k, 1); 
    accuracy_gb_dt_fold=zeros(k, 1); %tot
    accuracy_gb_rf_fold=zeros(k, 1);
    accuracy_ab_rf_fold=zeros(k, 1); %age
    accuracy_ab_dt_fold=zeros(k, 1); %age
    
    importance_rf_bmi_fold = cell(k, 1);
    importance_rf_ab_fold = cell(k, 1);
    importance_gab_rf_fold = cell(k, 1);
    importance_gab_dt_fold = cell(k, 1);
    importance_dt_bmi_fold = cell(k, 1);
    importance_dt_ab_fold = cell(k, 1);
    importance_gb_dt_fold = cell(k, 1);
    importance_gb_rf_fold = cell(k, 1);

    for i=1:length(landmark_names)
        row = all_data(i, :);
        
        nan_idx = isnan(row);
        
        mean_value = mean(row(~nan_idx), 'omitnan');
        
        row(nan_idx) = mean_value;
        
        all_data(i, :) = row;
    end

    modified_landmark_names = regexprep(landmark_names, '[\s\(\)\-]', '');
    combined_labels_gb = strcat(string(all_genders), '_', string(all_bmi));
    combined_labels_ab = strcat(string(all_ages), '_', string(all_bmi));
    combined_labels_gab = strcat(string(all_genders), '_',string(all_ages),'_', string(all_bmi));

    % Creazione di oggetti cvpartition per ciascun set di etichette
    cv_bmi = cvpartition(all_bmi, 'KFold', k, 'Stratify', true);
    cv_combined_gb = cvpartition(combined_labels_gb, 'KFold', k, 'Stratify', true);
    cv_combined_ab = cvpartition(combined_labels_ab, 'KFold', k, 'Stratify', true);
    cv_combined_gab = cvpartition(combined_labels_gab, 'KFold', k, 'Stratify', true);
    
    % Inizia l'iterazione attraverso le parti
    for fold = 1:k


        trainIdx_bmi = cv_bmi.training(fold);
        testIdx_bmi = cv_bmi.test(fold);
        trainIdx_combined_ab = cv_combined_ab.training(fold);
        testIdx_combined_ab = cv_combined_ab.test(fold);
        trainIdx_combined_gb = cv_combined_gb.training(fold);
        testIdx_combined_gb = cv_combined_gb.test(fold);
        trainIdx_combined_gab = cv_combined_gab.training(fold);
        testIdx_combined_gab = cv_combined_gab.test(fold);
    
        % Dati di training e test
        X_train_fold_bmi = all_data(:, trainIdx_bmi);
        X_test_fold_bmi = all_data(:, testIdx_bmi);
        X_train_fold_ab = all_data(:, trainIdx_combined_ab);
        X_test_fold_ab = all_data(:, testIdx_combined_ab);
        X_train_fold_gb = all_data(:, trainIdx_combined_gb);
        X_test_fold_gb = all_data(:, testIdx_combined_gb);
        X_train_fold_gab = all_data(:, trainIdx_combined_gab);
        X_test_fold_gab = all_data(:, testIdx_combined_gab);
    
        y_bmi_train_fold = all_genders(trainIdx_bmi);
        y_bmi_test_fold = all_genders(testIdx_bmi);
        y_ab_train_fold = all_ages(trainIdx_combined_ab);
        y_ab_test_fold = all_ages(testIdx_combined_ab);
        y_gb_train_fold = combined_labels_gb(trainIdx_combined_gb);
        y_gb_test_fold = combined_labels_gb(testIdx_combined_gb);
        y_gab_train_fold = combined_labels_gb(trainIdx_combined_gab);
        y_gab_test_fold = combined_labels_gb(testIdx_combined_gab);
    
        % Addestramento e valutazione Random Forest
        rfModel_bmi_fold = TreeBagger(100, X_train_fold_bmi', y_bmi_train_fold, 'Method', 'classification', 'OOBPredictorImportance', 'on');
        rfModel_ab_fold = TreeBagger(100, X_train_fold_ab', y_ab_train_fold, 'Method', 'classification', 'OOBPredictorImportance', 'on');
        rfModel_gb_fold = TreeBagger(100,  X_train_fold_gb', y_gb_train_fold, 'Method', 'classification', 'OOBPredictorImportance', 'on');
        rfModel_gab_fold = TreeBagger(100, X_train_fold_gab', y_gab_train_fold, 'Method', 'classification', 'OOBPredictorImportance', 'on');


        % Valutazione Random Forest
        [y_bmi_pred_rf_fold, ~] = predict(rfModel_bmi_fold, X_test_fold_bmi');
        accuracy_bmi_rf_fold(fold) = sum(str2double(y_bmi_pred_rf_fold') == double(y_bmi_test_fold)) / length(y_bmi_test_fold);
        [y_ab_pred_rf_fold, ~] = predict(rfModel_ab_fold, X_test_fold_ab');
        accuracy_ab_rf_fold(fold) = sum(str2double(y_ab_pred_rf_fold') == double(y_ab_test_fold)) / length(y_ab_test_fold);
        [y_gab_pred_rf_fold, ~] = predict(rfModel_gab_fold, X_test_fold_gab');
        accuracy_gab_rf_fold(fold) = sum(str2double(y_gab_pred_rf_fold') == double(y_gab_test_fold)) / length(y_gab_test_fold);
        [y_gb_pred_rf_fold, ~] = predict(rfModel_gb_fold, X_test_fold_gb');
        accuracy_gb_rf_fold(fold) = sum(strcmp(y_gb_pred_rf_fold', y_gb_test_fold)) / length(y_gb_test_fold);

        importance_rf_bmi_fold{fold} = rfModel_bmi_fold.OOBPermutedPredictorDeltaError;
        importance_rf_ab_fold{fold} = rfModel_ab_fold.OOBPermutedPredictorDeltaError;
        importance_gb_rf_fold{fold} = rfModel_gb_fold.OOBPermutedPredictorDeltaError;
        importance_gab_rf_fold{fold} = rfModel_gab_fold.OOBPermutedPredictorDeltaError;
    
    
        % Addestramento e valutazione Albero di Decisione
        dtModel_bmi_fold = fitctree(X_train_fold_bmi', y_bmi_train_fold');
        dtModel_ab_fold = fitctree(X_train_fold_ab', y_ab_train_fold');
        dtModel_gb_fold = fitctree( X_train_fold_gb', y_gb_train_fold);
        dtModel_gab_fold = fitctree(X_train_fold_gab', y_gab_train_fold');
    
        % Valutazione Albero di Decisione
        [y_bmi_pred_dt_fold, ~] = predict(dtModel_bmi_fold, X_test_fold_bmi');
        accuracy_bmi_dt_fold(fold) = sum(str2double(y_bmi_pred_dt_fold') == str2double(y_bmi_test_fold)) / length(y_bmi_test_fold);
    
        [y_ab_pred_dt_fold, ~] = predict(dtModel_ab_fold, X_test_fold_ab');
        accuracy_ab_dt_fold(fold) = sum(str2double(y_ab_pred_dt_fold') == str2double(y_ab_test_fold)) / length(y_ab_test_fold);
    
        [y_gab_pred_dt_fold, ~] = predict(dtModel_gab_fold, X_test_fold_gab');
        accuracy_gab_dt_fold(fold) = sum(str2double(y_gab_pred_dt_fold') == str2double(y_gab_test_fold)) / length(y_gab_test_fold);
    

        [y_gb_pred_dt_fold, ~] = predict(dtModel_gb_fold, X_test_fold_gb');
        accuracy_gb_dt_fold(fold) = sum(str2double(y_gb_pred_dt_fold') == str2double(y_gb_test_fold)) / length(y_gb_test_fold);


        importance_dt_ab_fold{fold} = predictorImportance(dtModel_ab_fold);
        importance_gb_dt_fold{fold} = predictorImportance(dtModel_gb_fold);
        importance_dt_bmi_fold{fold} = predictorImportance(dtModel_bmi_fold);
        importance_gab_dt_fold{fold} = predictorImportance(dtModel_gab_fold);


       

 
       
    end

    
    mean_accuracy_rf_bmi = mean(accuracy_bmi_rf_fold);
    mean_accuracy_rf_ab = mean(accuracy_ab_rf_fold);
    mean_accuracy_dt_bmi = mean(accuracy_bmi_dt_fold);
    mean_accuracy_dt_ab = mean(accuracy_ab_dt_fold);
    mean_accuracy_dt_gb = mean(accuracy_gb_dt_fold);
    mean_accuracy_rf_gb = mean(accuracy_gb_rf_fold);
    mean_accuracy_dt_gab = mean(accuracy_gab_dt_fold);
    mean_accuracy_rf_gab = mean(accuracy_gab_rf_fold);
    


    % Alla fine delle iterazioni, calcola le medie delle feature importances
    importance_rf_bmi = mean(cell2mat(importance_rf_bmi_fold));
    importance_rf_ab = mean(cell2mat(importance_rf_ab_fold));
    importance_dt_bmi = mean(cell2mat(importance_dt_bmi_fold));
    importance_dt_ab = mean(cell2mat(importance_dt_ab_fold));
    importance_dt_gb = mean(cell2mat(importance_gb_dt_fold));
    importance_rf_gb = mean(cell2mat(importance_gb_rf_fold));
    importance_dt_gab = mean(cell2mat(importance_gab_dt_fold));
    importance_rf_gab = mean(cell2mat(importance_gab_rf_fold));
    
   % Calcola gli indici dei valori positivi
    positive_idx_rf_bmi = find(importance_rf_bmi > 0)
    positive_idx_rf_ab = find(importance_rf_ab > 0);
    positive_idx_dt_bmi = find(importance_dt_bmi > 0);
    positive_idx_dt_ab = find(importance_dt_ab > 0);
    positive_idx_rf_gb = find(importance_rf_gb > 0);
    positive_idx_dt_gb = find(importance_dt_gb > 0);
    positive_idx_rf_gab = find(importance_rf_gab > 0);
    positive_idx_dt_gab = find(importance_dt_gab > 0);
    
    % Ordina solo i valori positivi
    [sorted, ~] = sort(importance_rf_bmi(positive_idx_rf_bmi), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_rf_bmi = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_rf_bmi = zeros(1, length(top_rf_bmi));
    
    % Cerca ogni valore di top_rf_bmi in importance_rf_bmi
    for i = 1:length(top_rf_bmi)
        idx_rf_bmi(i) = find(importance_rf_bmi == top_rf_bmi(i), 1);
    end


    
    [sorted, ~] = sort(importance_rf_ab(positive_idx_rf_ab), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_rf_ab = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_rf_ab = zeros(1, length(top_rf_ab));
    
    % Cerca ogni valore di top_rf_bmi in importance_rf_bmi
    for i = 1:length(top_rf_ab)
        idx_rf_ab(i) = find(importance_rf_ab == top_rf_ab(i), 1);
    end


    [sorted,~ ] = sort(importance_dt_bmi(positive_idx_dt_bmi), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_dt_bmi = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_dt_bmi = zeros(1, length(top_dt_bmi));
    
    % Cerca ogni valore di top_rf_bmi in importance_rf_bmi
    for i = 1:length(top_dt_bmi)
        idx_dt_bmi(i) = find(importance_dt_bmi == top_dt_bmi(i), 1);
    end
    
    [sorted, ~] = sort(importance_dt_ab(positive_idx_dt_ab), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_dt_ab = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_dt_ab = zeros(1, length(top_dt_ab));
    
    % Cerca ogni valore di top_rf_bmi in importance_rf_bmi
    for i = 1:length(top_dt_ab)
        idx_dt_ab(i) = find(importance_dt_ab == top_dt_ab(i), 1);
    end
    

    [sorted, ~] = sort(importance_rf_gb(positive_idx_rf_gb), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_rf_gb = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_rf_gb = zeros(1, length(top_rf_gb));
    
    % Cerca ogni valore di top_rf_bmi in importance_rf_bmi
    for i = 1:length(top_rf_gb)
        idx_rf_gb(i) = find(importance_rf_gb == top_rf_gb(i), 1);
    end

    
    [sorted, ~] = sort(importance_dt_gb(positive_idx_dt_gb), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_dt_gb = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_dt_gb = zeros(1, length(top_dt_gb));
    
    % Cerca ogni valore di top_rf_bmi in importance_rf_bmi
    for i = 1:length(top_dt_gb)
        idx_dt_gb(i) = find(importance_dt_gb == top_dt_gb(i), 1);
    end



    [sorted, ~] = sort(importance_rf_gab(positive_idx_rf_gab), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_rf_gab = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_rf_gab = zeros(1, length(top_rf_gab));
    
    % Cerca ogni valore di top_rf_bmi in importance_rf_bmi
    for i = 1:length(top_rf_gab)
        idx_rf_gab(i) = find(importance_rf_gab == top_rf_gab(i), 1);
    end

    
    [sorted, ~] = sort(importance_dt_gab(positive_idx_dt_gab), 'descend');
    if(size(sorted,2)<3)
        top_size=size(sorted,2);
    else
        top_size=3;
    end
    top_dt_gab = sorted(1,1:top_size);
    % Inizializza un vettore vuoto per gli indici
    idx_dt_gab = zeros(1, length(top_dt_gab));
    
    % Cerca ogni valore di top_rf_bmi in importance_rf_bmi
    for i = 1:length(top_dt_gab)
        idx_dt_gab(i) = find(importance_dt_gab == top_dt_gab(i), 1);
    end

    % Visualizza i risultati 

    fprintf('\n\nAccuracy for BMI analysis with Random Forest : %.2f%%\n', mean_accuracy_rf_bmi * 100);
    fprintf('\n\nAccuracy for age and BMI analysis with Random Forest : %.2f%%\n', mean_accuracy_rf_ab * 100);
    fprintf('\n\nAccuracy for gender and BMI analysis with Random Forest : %.2f%%\n', mean_accuracy_rf_gb * 100);
    fprintf('\n\nAccuracy for gender,age and BMI analysis with Random Forest : %.2f%%\n', mean_accuracy_rf_gab * 100);
    fprintf('Accuracy for BMI analysis with Decision Tree: %.2f%%\n', mean_accuracy_dt_bmi * 100);
    fprintf('Accuracy for age and BMI analysis with Decision Tree: %.2f%%\n', mean_accuracy_dt_ab * 100);
    fprintf('Accuracy for gender and BMI analysis with Decision Tree: %.2f%%\n', mean_accuracy_dt_gb * 100);
    fprintf('Accuracy for gender,age and BMI analysis with Decision Tree: %.2f%%\n', mean_accuracy_dt_gab * 100);


   

    choosing_model = 'Decision Tree';
    top_ab=top_dt_ab;
    top_gb=top_dt_gb;
    top_gab=top_dt_gab;
    top_bmi=top_dt_bmi;

    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%% DECISION TREE FOR BMI,AGE AND GENDER ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%\n');

    fprintf('Analysis for the model %s', choosing_model );
    fprintf('\n\nBMI top landmarks for BMI classification are: ');
    for i = 1:length(top_bmi)
        fprintf('%s, ', landmark_names{idx_dt_bmi(i)});
    end
    fprintf('\n\n');
    
    fprintf('Age and BMI top landmarks for age and BMI classification are: ');
    for i = 1:length(top_ab)
        fprintf('%s, ', landmark_names{idx_dt_ab(i)});
    end
    fprintf('\n\n');

    fprintf('Gender and BMI top landmarks for gender and BMI classification are: ');
    for i = 1:length(top_gb)
        fprintf('%s, ', landmark_names{idx_dt_gb(i)});
    end
    fprintf('\n\n');


    fprintf('Gender,Age and BMI top landmarks for gender,age and BMI classification are: ');
    for i = 1:length(top_gab)
        fprintf('%s, ', landmark_names{idx_dt_gab(i)});
    end
    fprintf('\n\n');

    % 
    % map_gender = containers.Map({'1', '2'}, {'M','F'});
    % 
    % for j=1:3
    %     figure;
    % 
    %     boxplot(all_data(index_bmi(j),:), all_genders) ;
    %     title ('Distribution of the most important feature by Gender');
    %     xlabel ( 'Gender' ) ;
    %     ylabel(sprintf( 'Importance of the landmark %s ', landmark_names{index_bmi(j)}));
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
    %     boxplot(all_data(index_ab(j),:), all_ages) ;
    %     title ('Distribution of the most important feature by Age');
    %     xlabel ( 'Age' ) ;
    %     ylabel(sprintf( 'Importance of the landmark %s ', landmark_names{index_ab(j)}));
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
    top_ab=top_rf_ab;
    top_gb=top_rf_gb;
    top_gab=top_rf_gab;
    top_bmi=top_rf_bmi;

    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%% RANDOM FOREST FOR AGE, BMI AND GENDER ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%\n');

    fprintf('Analysis for the model %s', choosing_model );
    fprintf('\n\nBMI top landmarks for BMI classification are: ');
    for i = 1:length(top_bmi)
        fprintf('%s ', landmark_names{idx_rf_bmi(i)});
    end
    fprintf('\n\n');
    
    fprintf('Age and BMI top landmarks for age and BMI classification are: ');
    for i = 1:length(top_ab)
        fprintf('%s ', landmark_names{idx_rf_ab(i)});
    end

    fprintf('Gender and BMI top landmarks for gender and BMI classification are: ');
    for i = 1:length(top_gb)
        fprintf('%s ', landmark_names{idx_rf_gb(i)});
    end
    fprintf('\n\n');

    fprintf('Gender,Age and BMI top landmarks for gender,age and BMI classification are: ');
    for i = 1:length(top_gab)
        fprintf('%s ', landmark_names{idx_rf_gab(i)});
    end
    fprintf('\n\n');
    

    % map_gender = containers.Map({'1', '2'}, {'M','F'});

    % for j=1:3
    %     figure;
    % 
    %     boxplot(all_data(index_bmi(j),:), all_genders) ;
    %     title ('Distribution of the most important feature by Gender');
    %     xlabel ( 'Gender' ) ;
    %     ylabel(sprintf( 'Importance of the landmark %s ', landmark_names{index_bmi(j)}));
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
    %     boxplot(all_data(index_ab(j),:), all_ages) ;
    %     title ('Distribution of the most important feature by Age');
    %     xlabel ( 'Age' ) ;
    %     ylabel(sprintf( 'Importance of the landmark %s ', landmark_names{index_ab(j)}));
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

   % For bmi importance
    figure;
    subplot(1, 2, 1);
    rgb_colors = zeros(num_landmarks, 3); 
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_rf_bmi, :) = repmat([1 0 0], length(idx_rf_bmi), 1); % red for the top 3
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_rf_bmi(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title_str = sprintf('Importance for BMI for RF\n accuracy = %.2f %', mean_accuracy_rf_bmi*100);
    title(title_str);


    
    subplot(1, 2, 2);
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_dt_bmi, :) = repmat([1 0 0], length(idx_dt_bmi), 1); % red for the top 3
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_dt_bmi(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title_str = sprintf('Importance for BMI for DT\n accuracy =%.2f % ', mean_accuracy_dt_bmi*100);
    title(title_str);

    
    % For age and bmi importance
    figure;
    subplot(1, 2, 1);
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_rf_ab, :) = repmat([1 0 0], length(idx_rf_ab), 1); % red for the top 3
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_rf_ab(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title_str = sprintf('Importance for age and BMI for RF\n accuracy = %.2f % ', mean_accuracy_rf_ab*100);
    title(title_str);

    
    subplot(1, 2, 2);
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_dt_ab, :) = repmat([1 0 0], length(idx_dt_ab), 1); % red for the top 3
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_dt_ab(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title_str = sprintf('Importance for age and BMI for DT\n accuracy = %.2f %', mean_accuracy_dt_ab*100);
    title(title_str);



    %%% for gender and BMI importance
    figure;
    subplot(1, 2, 1);
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_rf_gb, :) = repmat([1 0 0], length(idx_rf_gb), 1); 
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_rf_gb(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title_str = sprintf('Importance for gender and BMI for RF\n accuracy = %.2f %', mean_accuracy_rf_gb*100);
    title(title_str);

    
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_dt_gb, :) = repmat([1 0 0], length(idx_dt_gb), 1); % rosso per i primi 3
    
    % Disegna ogni barra individualmente
    subplot(1, 2, 2);
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_dt_gb(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title_str = sprintf('Importance for gender and BMI for DT\n accuracy = %.2f %', mean_accuracy_dt_gb*100);
    title(title_str);
    

    %%% for gender,age and BMI importance
    figure;
    subplot(1, 2, 1);
    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_rf_gab, :) = repmat([1 0 0], length(idx_rf_gab), 1); 
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_rf_gab(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title_str = sprintf('Importance for gender, age and BMI for RF\n accuracy = %.2f %', mean_accuracy_rf_gab*100);
    title(title_str);


    rgb_colors = zeros(num_landmarks, 3);
    rgb_colors(:, 3) = 1; % default color is blue
    rgb_colors(idx_dt_gab, :) = repmat([1 0 0], length(idx_dt_gab), 1); % rosso per i primi 3

    subplot(1, 2, 2);
    hold on;
    for i = 1:num_landmarks
        bar(i, importance_dt_gab(i), 'FaceColor', rgb_colors(i, :));
    end
    hold off;
    
    xticks(1:num_landmarks);
    xticklabels(modified_landmark_names);
    xlabel('Landmark');
    ylabel('Importance');
    title_str = sprintf('Importance for gender, age and BMI for DT\n accuracy =%.2f %', mean_accuracy_dt_gab*100);
    title(title_str);



    

   
    % % Creare un dizionario di corrispondenza
    % map = containers.Map({'1_2', '1_3', '2_3', '1_1', '2_1','2_2'}, {'M_30_50', 'M_O50', 'F_O50', 'M_U30', 'F_U30', 'F_30_50'});
    % 
    % for j=1:3
    %     figure;
    % 
    %     boxplot(all_data(index(j),:), combined_labels_gb);
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
    %     boxplot(all_data(index(j),:), combined_labels_gb);
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

    

    
    if(mean_accuracy_rf_ab==0 && (mean_accuracy_dt_ab == 0))
        model_ab='No model';
    else
        if(mean_accuracy_rf_ab > mean_accuracy_dt_ab)
        model_ab = 'Random Forest';
        else
            model_ab = 'Decision Tree';
        end
    end

    if(mean_accuracy_rf_bmi==0 && mean_accuracy_dt_bmi==0)
        model_bmi='No model';
    else
        if(mean_accuracy_rf_bmi > mean_accuracy_dt_bmi)
            model_bmi = 'Random Forest';
        else
            model_bmi = 'Decision Tree';
        end
    end
    if(mean_accuracy_rf_gb==0 && mean_accuracy_dt_gb==0)
        model_gb='No model';
    else
        if(mean_accuracy_rf_gb > mean_accuracy_dt_gb)
            model_gb = 'Random Forest';
        else
            model_gb = 'Decision Tree';
        end
    end

   if(mean_accuracy_rf_gab==0 && mean_accuracy_dt_gab==0)
       model_gab='No model';
   else
        if(mean_accuracy_rf_gab > mean_accuracy_dt_gab)
            model_gab = 'Random Forest';
        else
            model_gab = 'Decision Tree';
        end
   end

       


    

end