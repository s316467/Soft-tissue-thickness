% Definisci nome del paziente (servirà per percorso a file evetnuale e per
% grafici)
clear all;
close all;

% Definisci percorso a workspace -> (salvato come workspace_nomePaziente)
path_name = "soggetto_009_landmark.mat";
path = "hmr_mio/landmark/";

% Carica workspace del paziente 
% (serve per caricare le coordinate dei landmark)
load(path + path_name);
name = "soggetto_009";

% Definisci i landmark per tessuti molli e duri
glabella_soft = g_soft.Position;
nasion_soft = n_soft.Position;
rhinion_soft = r_soft.Position;
orbitaledx_soft = orr_soft.Position;
orbitalesx_soft = orl_soft.Position;
superiusdx_soft = osr_soft.Position;
superiussx_soft = osl_soft.Position;
zygiondx_soft = zyr_soft.Position;
zygionsx_soft = zyl_soft.Position;
midphiltrum_soft = mp_soft.Position;

glabella_hard = g_hard.Position;
nasion_hard = n_hard.Position;
rhinion_hard = r_hard.Position;
orbitaledx_hard = orr_hard.Position;
orbitalesx_hard = orl_hard.Position;
superiusdx_hard = osr_hard.Position;
superiussx_hard = osl_hard.Position;
zygiondx_hard = zyr_hard.Position;
zygionsx_hard = zyl_hard.Position;
midphiltrum_hard = mp_hard.Position;

% Crea array di landmark per facile elaborazione
% (Differenzia landmark per lato destro (r) e sinistro (l) della faccia 
% (serve per grafici -> eventuale modifica per semplificare)
landmarks_soft = [glabella_soft; nasion_soft; ...
                  orbitaledx_soft; orbitalesx_soft; ...
                  superiusdx_soft; superiussx_soft; ...
                  zygiondx_soft; zygionsx_soft; ...
                  rhinion_soft; midphiltrum_soft];

landmarks_soft_r = [glabella_soft;  ...
                  orbitaledx_soft; ...
                  superiusdx_soft; ...
                  zygiondx_soft; ...
                  rhinion_soft; midphiltrum_soft];

landmarks_soft_l = [nasion_soft; ...
                  orbitalesx_soft; ...
                  superiussx_soft; ...
                  zygionsx_soft; ...
                  midphiltrum_soft];

landmarks_hard = [glabella_hard; nasion_hard;  ...
                  orbitaledx_hard; orbitalesx_hard; ...
                  superiusdx_hard; superiussx_hard; ...
                  zygiondx_hard; zygionsx_hard; ...
                  rhinion_hard; midphiltrum_hard];

landmarks_hard_r = [glabella_hard;  ...
                  orbitaledx_hard; ...
                  superiusdx_hard; ...
                  zygiondx_hard; ...
                  rhinion_hard; midphiltrum_hard];

landmarks_hard_l = [nasion_hard;  ...
                  orbitalesx_hard; ...
                  superiussx_hard; ...
                  zygionsx_hard; ...
                  midphiltrum_hard];


% Assicurati che entrambi gli array di landmark abbiano le stesse dimensioni
if ~isequal(size(landmarks_soft), size(landmarks_hard))
    error('Le dimensioni di landmarks_soft e landmarks_hard non corrispondono');
end

% Calcola le distanze euclidee tra i landmark corrispondenti
% (Differenzia per landmark lato destro (r) e sinistro (l) della faccia 
% (serve per grafici -> eventuale modifica per semplificare)
distances_mm = sqrt(sum((landmarks_soft - landmarks_hard).^2, 2));

distances_mm_r = sqrt(sum((landmarks_soft_r - landmarks_hard_r).^2, 2));

distances_mm_l = sqrt(sum((landmarks_soft_l - landmarks_hard_l).^2, 2));

% Definisci array con nomi dei landmark
% (Differenzia landmark lato destro (r) e sinistro (l) della faccia 
% (serve per grafici -> eventuale modifica per semplificare)
landmark_names = {'Glabella', 'Nasion', ...
                  'Orbital Right', 'Orbital Left', ...
                  'Superius Right', 'Superius Left', ...
                  'Zygion Right', 'Zygion Left', ...
                  'Rhinion', 'Midphiltrum'};

landmark_names_r = {'Glabella', ...
                  'Orbital Right',  ...
                  'Superius Right', ...
                  'Zygion Right', ...
                  'Rhinion', 'Midphiltrum'};

landmark_names_l = {'Nasion', ...
                  'Orbital Left', ...
                  'Superius Left', ...
                  'Zygion Left', ...
                  'Midphiltrum'};

% Display the distances in millimeters
for i = 1:length(distances_mm)
    fprintf('Distance for landmark %s: %f mm\n', landmark_names{i}, distances_mm(i));
end

% Salva le distanze in un file .csv
T = table(landmark_names', distances_mm, 'VariableNames', {'Landmark', 'Distance_mm'});
writetable(T, sprintf('hmr_mio/distances/hmr/%s.csv', name));
fprintf('Distances have been saved to %s.csv\n', name);

% Carica le mesh create dalla funzione demonstration_fun
load(sprintf('hmr_mio/mat_mesh/%s', name), 'Xb', 'Yb', 'Zb', 'Xs', 'Ys', 'Zs');

% Visualizzazione frontale delle mesh sovrapposte con i landmark evidenziati
f1 = figure;
surf(Xb, Yb, Zb, 'FaceColor', [ 0.7  0.7  0.7], 'EdgeColor', 'none', 'FaceAlpha',    0.75, 'DisplayName', 'Hard Tissue');
hold on;
surf(Xs, Ys, Zs, 'FaceColor', [ 0.9  0.9  0.9], 'EdgeColor', 'none', 'FaceAlpha',    0.75, 'DisplayName', 'Soft Tissue');
scatter3(landmarks_soft(:,1), landmarks_soft(:,2), landmarks_soft(:,3), 300, 'r.', 'DisplayName', 'Soft Landmarks');
scatter3(landmarks_hard(:,1), landmarks_hard(:,2), landmarks_hard(:,3), 300, 'g.', 'DisplayName', 'Hard Landmarks');
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
title(sprintf('Mesh Dura e Molle Sovrapposte (Frontale)'));
legend;
view(0, 90);
camlight;
rotate3d on;
mkdir(fullfile('distances_photo'), name);
saveas(f1, sprintf('distances_photo/%s/front_view.png', name));
close(f1);

% Visualizzazione frontale con solo i landmark del tessuto duro
f3 = figure;
surf(Xb, Yb, Zb, 'FaceColor', [ 0.7  0.7  0.7], 'EdgeColor', 'none', 'FaceAlpha',    0.75, 'DisplayName', 'Hard Tissue');
hold on;
scatter3(landmarks_hard(:,1), landmarks_hard(:,2), landmarks_hard(:,3), 300, 'g.', 'DisplayName', 'Hard Landmarks');
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
title(sprintf('Mesh Dura (Frontale)'));
legend;
view(0, 90);
camlight;
rotate3d on;
saveas(f3, sprintf('distances_photo/%s/front_view_hard.png', name));
close(f3);

% Visualizzazione frontale con solo i landmark del tessuto molle
f4 = figure;
surf(Xs, Ys, Zs, 'FaceColor', [ 0.9  0.9  0.9], 'EdgeColor', 'none', 'FaceAlpha',    0.75, 'DisplayName', 'Soft Tissue');
hold on;
scatter3(landmarks_soft(:,1), landmarks_soft(:,2), landmarks_soft(:,3), 300, 'r.', 'DisplayName', 'Soft Landmarks');
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
title(sprintf('Mesh Molle (Frontale)'));
legend;
view(0, 90);
camlight;
rotate3d on;
saveas(f4, sprintf('distances_photo/%s/front_view_soft.png', name));
close(f4);

% Visualizzazione laterale delle mesh sovrapposte con le linee di distanza tra i landmark
f2 = figure;
surf(Xb, Yb, Zb, 'FaceColor', [ 0.7  0.7  0.7], 'EdgeColor', 'none', 'FaceAlpha',   0.5, 'DisplayName', 'Hard Tissue');
hold on;
surf(Xs, Ys, Zs, 'FaceColor', [ 0.9  0.9  0.9], 'EdgeColor', 'none', 'FaceAlpha',   0.5, 'DisplayName', 'Soft Tissue');
scatter3(landmarks_soft(:,1), landmarks_soft(:,2), landmarks_soft(:,3), 100, 'r.', 'DisplayName', 'Soft Landmarks');
scatter3(landmarks_hard(:,1), landmarks_hard(:,2), landmarks_hard(:,3), 100, 'g.', 'DisplayName', 'Hard Landmarks');

% Aggiungi le linee delle distanze tra i landmark
for i = 1:length(landmark_names)
    line_x = [landmarks_soft(i, 1), landmarks_hard(i, 1)];
    line_y = [landmarks_soft(i, 2), landmarks_hard(i, 2)];
    line_z = [landmarks_soft(i, 3), landmarks_hard(i, 3)];
    plot3(line_x, line_y, line_z, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Distance %s', landmark_names{i}));
    text(mean(line_x), mean(line_y), mean(line_z), sprintf('%.2f mm', distances_mm(i)), 'FontSize', 10, 'Color', 'r');
end

% Visualizzazione laterale delle mesh sovrapposte con le linee di distanza
% tra i landmark -> continuazione
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
title(sprintf('Mesh Dura e Molle Sovrapposte (Laterale)'));
legend('show');
view(90, 180);
camlight;
rotate3d on;
saveas(f2, sprintf('distances_photo/%s/side_view.png', name));
close(f2);

% Visualizzazione laterale del lato destro
visualize_side_view_r(name, Xb, Yb, Zb, Xs, Ys, Zs, landmarks_soft_r, landmarks_hard_r, distances_mm_r, landmark_names_r);

% Visualizzazione laterale del lato sinistro
visualize_side_view_l(name, Xb, Yb, Zb, Xs, Ys, Zs, landmarks_soft_l, landmarks_hard_l, distances_mm_l, landmark_names_l);



% Visualizzazione lato destro delle mesh sovrapposte con le linee 
% di distanza tra i landmark 
function visualize_side_view_r(name, Xb, Yb, Zb, Xs, Ys, Zs, landmarks_soft, landmarks_hard, distances_mm, landmark_names)
    f = figure;
    % Definisci l'angolo di rotazione in radianti (90 gradi in senso antiorario attorno all'asse y e 90 gradi in senso orario attorno all'asse z)
    ty = -2*pi; 
    tz = pi;
    tx = -1.5*pi;
    
    % Crea le matrici di rotazione attorno all'asse y e z
    Ry = [cos(ty) 0 sin(ty); 0 1 0; -sin(ty) 0 cos(ty)];
    Rz = [cos(tz) -sin(tz) 0; sin(tz) cos(tz) 0; 0 0 1];
    Rx = [1 0 0; 0 cos(tx) -sin(tx); 0 sin(tx) cos(tx)];
    % Crea una matrice di punti 3D
    Vb = [Xb(:), Yb(:), Zb(:)];
    Vs = [Xs(:), Ys(:), Zs(:)];


    
    % Applica le rotazioni ai punti del modello
    Vb_rot = Vb * Ry * Rz *Rx;
    Vs_rot = Vs * Ry * Rz *Rx;
    
    % Aggiorna i punti dei landmark se necessario
    landmarks_soft_rot = landmarks_soft * Ry * Rz *Rx;
    landmarks_hard_rot = landmarks_hard * Ry * Rz *Rx;
    
    % Riformatta i punti ruotati nelle matrici Xb, Yb, e Zb
    Xb_rot = reshape(Vb_rot(:,1), size(Xb));
    Yb_rot = reshape(Vb_rot(:,2), size(Yb));
    Zb_rot = reshape(Vb_rot(:,3), size(Zb));
    
    Xs_rot = reshape(Vs_rot(:,1), size(Xs));
    Ys_rot = reshape(Vs_rot(:,2), size(Ys));
    Zs_rot = reshape(Vs_rot(:,3), size(Zs));

       

    surf(Xb_rot, Yb_rot, Zb_rot, 'FaceColor', [ 0.7  0.7  0.7], 'EdgeColor', 'none', 'FaceAlpha',   0.5, 'DisplayName', 'Hard Tissue');
    hold on;
    surf(Xs_rot, Ys_rot, Zs_rot, 'FaceColor', [ 0.9  0.9  0.9], 'EdgeColor', 'none', 'FaceAlpha',   0.5, 'DisplayName', 'Soft Tissue');
    
   
    side_label = 'Destro';
    scatter3(landmarks_soft_rot(:,1), landmarks_soft_rot(:,2), landmarks_soft_rot(:,3), 100, 'r.', 'DisplayName', 'Soft Landmarks');
    scatter3(landmarks_hard_rot(:,1), landmarks_hard_rot(:,2), landmarks_hard_rot(:,3), 100, 'g.', 'DisplayName', 'Hard Landmarks');

    % Aggiungi le linee delle distanze tra i landmark
    for i = 1:length(landmark_names)'
        line_x = [landmarks_soft_rot(i, 1), landmarks_hard_rot(i, 1)];
        line_y = [landmarks_soft_rot(i, 2), landmarks_hard_rot(i, 2)];
        line_z = [landmarks_soft_rot(i, 3), landmarks_hard_rot(i, 3)];
        plot3(line_x, line_y, line_z, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Distance %s', landmark_names{i}));
        text(mean(line_x), mean(line_y), mean(line_z), sprintf('%.2f mm', distances_mm(i)), 'FontSize', 10, 'Color', 'r');
    end


    % Visualizzazione lato destro delle mesh sovrapposte con le linee 
    % di distanza tra i landmark -> continuazione
    axis equal;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title(sprintf('Mesh Dura e Molle Sovrapposte (Laterale %)', side_label));
    legend('show');
    view(90,0);
    camlight;
    rotate3d on;
    grid off;
    saveas(f, sprintf('distances_photo/%s/side_view_%s.png', name, lower(side_label)));

end

% Visualizzazione lato sinistro delle mesh sovrapposte con le linee 
% di distanza tra i landmark
function visualize_side_view_l(name, Xb, Yb, Zb, Xs, Ys, Zs, landmarks_soft, landmarks_hard, distances_mm, landmark_names)

    f = figure;
    % Definisci l'angolo di rotazione in radianti (90 gradi in senso antiorario attorno all'asse y e 90 gradi in senso orario attorno all'asse z)
    ty = pi; 
    tz = pi;
    tx = -1.5*pi;
    
    % Crea le matrici di rotazione attorno all'asse y e z
    Ry = [cos(ty) 0 sin(ty); 0 1 0; -sin(ty) 0 cos(ty)];
    Rz = [cos(tz) -sin(tz) 0; sin(tz) cos(tz) 0; 0 0 1];
    Rx = [1 0 0; 0 cos(tx) -sin(tx); 0 sin(tx) cos(tx)];
    % Crea una matrice di punti 3D
    Vb = [Xb(:), Yb(:), Zb(:)];
    Vs = [Xs(:), Ys(:), Zs(:)];


    
    % Applica le rotazioni ai punti del modello
    Vb_rot = Vb * Ry * Rz *Rx;
    Vs_rot = Vs * Ry * Rz *Rx;
    
    % Aggiorna i punti dei landmark se necessario
    landmarks_soft_rot = landmarks_soft * Ry * Rz *Rx;
    landmarks_hard_rot = landmarks_hard * Ry * Rz *Rx;
    
    % Riformatta i punti ruotati nelle matrici Xb, Yb, e Zb
    Xb_rot = reshape(Vb_rot(:,1), size(Xb));
    Yb_rot = reshape(Vb_rot(:,2), size(Yb));
    Zb_rot = reshape(Vb_rot(:,3), size(Zb));
    
    Xs_rot = reshape(Vs_rot(:,1), size(Xs));
    Ys_rot = reshape(Vs_rot(:,2), size(Ys));
    Zs_rot = reshape(Vs_rot(:,3), size(Zs));

       

    surf(Xb_rot, Yb_rot, Zb_rot, 'FaceColor', [ 0.7  0.7  0.7], 'EdgeColor', 'none', 'FaceAlpha',   0.5, 'DisplayName', 'Hard Tissue');
    hold on;
    surf(Xs_rot, Ys_rot, Zs_rot, 'FaceColor', [ 0.9  0.9  0.9], 'EdgeColor', 'none', 'FaceAlpha',   0.5, 'DisplayName', 'Soft Tissue');
    
   
    side_label = 'Sinistro';
    scatter3(landmarks_soft_rot(:,1), landmarks_soft_rot(:,2), landmarks_soft_rot(:,3), 100, 'r.', 'DisplayName', 'Soft Landmarks');
    scatter3(landmarks_hard_rot(:,1), landmarks_hard_rot(:,2), landmarks_hard_rot(:,3), 100, 'g.', 'DisplayName', 'Hard Landmarks');

    % Aggiungi le linee delle distanze tra i landmark
    for i = 1:length(landmark_names)'
        line_x = [landmarks_soft_rot(i, 1), landmarks_hard_rot(i, 1)];
        line_y = [landmarks_soft_rot(i, 2), landmarks_hard_rot(i, 2)];
        line_z = [landmarks_soft_rot(i, 3), landmarks_hard_rot(i, 3)];
        plot3(line_x, line_y, line_z, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Distance %s', landmark_names{i}));
        text(mean(line_x), mean(line_y), mean(line_z), sprintf('%.2f mm', distances_mm(i)), 'FontSize', 10, 'Color', 'r');
    end


    % Visualizzazione lato sinistro delle mesh sovrapposte con le linee 
    % di distanza tra i landmark -> continuazione
    axis equal;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title(sprintf('Mesh Dura e Molle Sovrapposte (Laterale %s)', side_label));
    legend('show');
    camlight;
    view(90,0);
    grid off;
    saveas(f, sprintf('distances_photo/%s/side_view_%s.png', name, lower(side_label)));

end
