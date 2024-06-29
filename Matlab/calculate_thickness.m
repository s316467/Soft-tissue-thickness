


function calculate_thickness(name)
    
    load(name)
    % Definisci i landmark per tessuti molli e duri
    glabella_soft = g_soft.Position;
    nasion_soft = n_soft.Position;
    orbitaledx_soft = orr_soft.Position;
    orbitalesx_soft = orl_soft.Position;
    superiusdx_soft = osr_soft.Position;
    superiussx_soft = osl_soft.Position;
    zygiondx_soft = zyr_soft.Position;
    zygionsx_soft = zyl_soft.Position;
    midphiltrum_soft = mp_soft.Position;
    rhinion_soft = r_soft.Position;

    glabella_hard = g_hard.Position;
    nasion_hard = n_hard.Position;
    orbitaledx_hard = orr_hard.Position;
    orbitalesx_hard = orl_hard.Position;
    superiusdx_hard = osr_hard.Position;
    superiussx_hard = osl_hard.Position;
    zygiondx_hard = zyr_hard.Position;
    zygionsx_hard = zyl_hard.Position;
    midphiltrum_hard = mp_hard.Position;
    rhinion_hard = r_hard.Position;

    
    % % Print sizes of soft tissue landmarks
    % fprintf('Sizes of soft tissue landmarks:\n');
    % fprintf('glabella_soft: %s\n', mat2str(size(glabella_soft)));
    % fprintf('orbitaledx_soft: %s\n', mat2str(size(orbitaledx_soft)));
    % fprintf('orbitalesx_soft: %s\n', mat2str(size(orbitalesx_soft)));
    % fprintf('superiusdx_soft: %s\n', mat2str(size(superiusdx_soft)));
    % fprintf('superiussx_soft: %s\n', mat2str(size(superiussx_soft)));
    % fprintf('zygiondx_soft: %s\n', mat2str(size(zygiondx_soft)));
    % fprintf('zygionsx_soft: %s\n', mat2str(size(zygionsx_soft)));
    % fprintf('rhinion_soft: %s\n', mat2str(size(rhinion_soft)));
    % fprintf('apoint_soft: %s\n', mat2str(size(midphiltrum_soft)));
    % 
    % % Print sizes of hard tissue landmarks
    % fprintf('Sizes of hard tissue landmarks:\n');
    % fprintf('glabella_hard: %s\n', mat2str(size(glabella_hard)));
    % fprintf('orbitaledx_hard: %s\n', mat2str(size(orbitaledx_hard)));
    % fprintf('orbitalesx_hard: %s\n', mat2str(size(orbitalesx_hard)));
    % fprintf('superiusdx_hard: %s\n', mat2str(size(superiusdx_hard)));
    % fprintf('superiussx_hard: %s\n', mat2str(size(superiussx_hard)));
    % fprintf('zygiondx_hard: %s\n', mat2str(size(zygiondx_hard)));
    % fprintf('zygionsx_hard: %s\n', mat2str(size(zygionsx_hard)));
    % fprintf('rhinion_hard: %s\n', mat2str(size(rhinion_hard)));
    % fprintf('apoint_hard: %s\n', mat2str(size(midphiltrum_hard)));
    % 
    % % Print the actual values of the landmarks
    % fprintf('Values of soft tissue landmarks:\n');
    % disp('glabella_soft:'), disp(glabella_soft)
    % disp('nasion_soft:'), disp(nasion_soft)
    % disp('orbitaledx_soft:'), disp(orbitaledx_soft)
    % disp('orbitalesx_soft:'), disp(orbitalesx_soft)
    % disp('superiusdx_soft:'), disp(superiusdx_soft)
    % disp('superiussx_soft:'), disp(superiussx_soft)
    % disp('zygiondx_soft:'), disp(zygiondx_soft)
    % disp('zygionsx_soft:'), disp(zygionsx_soft)
    % disp('rhinion_soft:'), disp(rhinion_soft)
    % disp('apoint_soft:'), disp(midphiltrum_soft)
    % 
    % fprintf('Values of hard tissue landmarks:\n');
    % disp('glabella_hard:'), disp(glabella_hard)
    % disp('nasion_hard:'), disp(nasion_hard)
    % disp('orbitaledx_hard:'), disp(orbitaledx_hard)
    % disp('orbitalesx_hard:'), disp(orbitalesx_hard)
    % disp('superiusdx_hard:'), disp(superiusdx_hard)
    % disp('superiussx_hard:'), disp(superiussx_hard)
    % disp('zygiondx_hard:'), disp(zygiondx_hard)
    % disp('zygionsx_hard:'), disp(zygionsx_hard)
    % disp('rhinion_hard:'), disp(rhinion_hard)
    % disp('apoint_hard:'), disp(midphiltrum_hard)


    % Crea array di landmark per facile elaborazione
    landmarks_soft = [glabella_soft; nasion_soft; ...
                      orbitaledx_soft; orbitalesx_soft; ...
                      superiusdx_soft; superiussx_soft; ...
                      zygiondx_soft; zygionsx_soft;  ...
                      rhinion_soft;midphiltrum_soft];
    
    landmarks_hard = [glabella_hard; nasion_hard; orbitaledx_hard; ...
                      orbitalesx_hard;superiusdx_hard; superiussx_hard; ...
                      zygiondx_hard; zygionsx_hard; ...
                      rhinion_hard; midphiltrum_hard];
    
    % Assicurati che entrambi gli array di landmark abbiano le stesse dimensioni
    if ~isequal(size(landmarks_soft), size(landmarks_hard))
        error('The dimensions of landmarks_soft and landmarks_hard do not match');
    end
    
    % Calcola le distanze euclidee tra i landmark corrispondenti
    distances_mm = sqrt(sum((landmarks_soft - landmarks_hard).^2, 2));
    
    % Display the distances in millimeters
    landmark_names = {'Glabella', 'Nasion', ...
                      'Orbital Right', 'Orbital Left', ...
                      'Superius Right', 'Superius Left', ...
                      'Zygion Right', 'Zygion Left', ...
                      'Rhinion','Mid-Philtrum (A-Point)'};
    
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
