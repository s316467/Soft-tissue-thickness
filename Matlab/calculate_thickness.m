


function calculate_thickness(name)
    
    load(name)
    % Definisci i landmark per tessuti molli e duri
    glabella_soft = g_soft.Position;
    nasion_soft = n_soft.Position;
    sellion_soft = se_soft.Position;
    endocanthiondx_soft = enr_soft.Position;
    endocanthionsx_soft = enl_soft.Position;
    exocanthiondx_soft = exr_soft.Position;
    exocanthionsx_soft = exl_soft.Position;
    orbitaledx_soft = orr_soft.Position;
    orbitalesx_soft = orl_soft.Position;
    superiusdx_soft = osr_soft.Position;
    superiussx_soft = osl_soft.Position;
    zygiondx_soft = zyr_soft.Position;
    zygionsx_soft = zyl_soft.Position;
    alarcurvaturedx_soft = acr_soft.Position;
    alarcurvaturesx_soft = acl_soft.Position;
    
    glabella_hard = g_hard.Position;
    nasion_hard = n_hard.Position;
    sellion_hard = se_hard.Position;
    endocanthiondx_hard = enr_hard.Position;
    endocanthionsx_hard = enl_hard.Position;
    exocanthiondx_hard = exr_hard.Position;
    exocanthionsx_hard = exl_hard.Position;
    orbitaledx_hard = orr_hard.Position;
    orbitalesx_hard = orl_hard.Position;
    superiusdx_hard = osr_hard.Position;
    superiussx_hard = osl_hard.Position;
    zygiondx_hard = zyr_hard.Position;
    zygionsx_hard = zyl_hard.Position;
    alarcurvaturedx_hard = acr_hard.Position;
    alarcurvaturesx_hard = acl_hard.Position;
    
    % Crea array di landmark per facile elaborazione
    landmarks_soft = [glabella_soft; nasion_soft; sellion_soft; ...
                      endocanthiondx_soft; endocanthionsx_soft; exocanthiondx_soft; ...
                      exocanthionsx_soft; orbitaledx_soft; orbitalesx_soft; ...
                      superiusdx_soft; superiussx_soft; ...
                      zygiondx_soft; zygionsx_soft; alarcurvaturedx_soft; alarcurvaturesx_soft];
    
    landmarks_hard = [glabella_hard; nasion_hard; sellion_hard; ...
                      endocanthiondx_hard; endocanthionsx_hard; exocanthiondx_hard; ...
                      exocanthionsx_hard; orbitaledx_hard; orbitalesx_hard; ...
                      superiusdx_hard; superiussx_hard; ...
                      zygiondx_hard; zygionsx_hard; alarcurvaturedx_hard; alarcurvaturesx_hard];
    
    % Assicurati che entrambi gli array di landmark abbiano le stesse dimensioni
    if ~isequal(size(landmarks_soft), size(landmarks_hard))
        error('Le dimensioni di landmarks_soft e landmarks_hard non corrispondono');
    end
    
    % Calcola le distanze euclidee tra i landmark corrispondenti
    distances_mm = sqrt(sum((landmarks_soft - landmarks_hard).^2, 2));
    
    % Display the distances in millimeters
    landmark_names = {'Glabella', 'Nasion', 'Sellion', ...
                      'Endocanthion Right', 'Endocanthion Left', ...
                      'Exocanthion Right', 'Exocanthion Left', ...
                      'Orbital Right', 'Orbital Left', ...
                      'Superius Right', 'Superius Left', ...
                      'Zygion Right', 'Zygion Left', ...
                      'Alar Curvature Right', 'Alar Curvature Left'};
    
    for i = 1:length(distances_mm)
        fprintf('Distance for landmark %s: %f mm\n', landmark_names{i}, distances_mm(i));
    end
    
    
    
    % Definisci il nome del file come variabile
    filename = strsplit(name,'.');
    disp(filename{1})
    % Salva le distanze in un file .mat
    save(sprintf('hmr/distances/%s.mat', filename{1}), 'distances_mm');
    
    % Salva le distanze in un file .csv
    T = table(landmark_names', distances_mm, 'VariableNames', {'Landmark', 'Distance_mm'});
    writetable(T, sprintf('hmr/distances/%s.csv', filename{1}));
    fprintf('Distances have been saved to %s.mat and %s.csv\n', filename{1}, filename{1});
    
    
    % Aggiungi le linee delle distanze tra i landmark
    for i = 1:length(distances_mm)
        line_x = [landmarks_soft(i, 1), landmarks_hard(i, 1)];
        line_y = [landmarks_soft(i, 2), landmarks_hard(i, 2)];
        line_z = [landmarks_soft(i, 3), landmarks_hard(i, 3)];
        % Grafico delle mesh sovrapposte con le distanze evidenziate
        f1=figure;
        surf(Xb,Yb,Zb, 'FaceColor', [0.8 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'DisplayName','Hard Tissue');
        hold on;
        surf( Xs,Ys,Zs, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'DisplayName', 'Soft Tissue');
        axis equal;
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        paziente=patient{1}+" "+patient{2};
        titolo = sprintf('Mesh Dura e Molle Sovrapposte - %s', paziente);
        title(titolo);
        
        view(0,90);
        camlight;
        rotate3d on;
        plot3(line_x, line_y, line_z, 'r-', 'LineWidth', 2, 'DisplayName', landmark_names{i});
        text(mean(line_x), mean(line_y), mean(line_z), sprintf('%.2f mm', distances_mm(i)), 'FontSize', 8, 'Color', 'r');
        % Mostra la legenda per le distanze
        legend('show');
        patient = strsplit(name, '_');
        name_patient = strcat(patient{1},'_', patient{2});
        mkdir(fullfile('hmr', 'distances_photo'), name_patient);
        saveas(f1, sprintf('hmr/distances_photo/%s/%s.png', name_patient,landmark_names{i}));
        close all;
    
    
    
    end
    
    
end
