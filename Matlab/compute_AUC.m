function [auc_values,categories_for_max_auc,accuracy_values ]= compute_AUC (auc_values, predictedLabels,accuracy_values,scores,data,class, i, categories_for_max_auc, categories)
    [X, Y, T, AUC] = perfcurve(data, scores(:,2), class);
     % Calcolo dell'accuratezza per l'età
    accuracy= sum(predictedLabels == data') / numel(data);
    accuracy_values(i) = accuracy;
    % Salvataggio dell'AUC per il landmark i-esimo
    auc_values(i) = AUC;
    
    % Trova l'indice dell'AUC massimo
    [~, max_auc_index] = max(AUC);
    
    % Determina la categoria di età corrispondente all'AUC massimo
    categories_for_max_auc{i} = categories{max_auc_index};

end