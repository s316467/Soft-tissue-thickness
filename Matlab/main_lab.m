% Importiamo gli STL creati in MeshLab: usiamo la funzione stlread.
% Assumo che i nomi dei file STL siano 'bone.stl' e 'soft.stl'
bone = stlread('./Progetto/bone1_olivetti.stl');
soft = stlread('./Progetto/soft1_olivetti.stl');
% bone = stlread('bone.stl');
% soft = stlread('soft.stl');

% V = elenco delle coordinate dei vertici. F = elenco dei vertici connessi
% (ogni riga corrisponde a un triangolo).
Vb = bone.Points;
Fb = bone.ConnectivityList;
Vs = soft.Points;
Fs = soft.ConnectivityList;

% Apriamo gli STL in una figura per vedere come sono orientati: per farlo
% usiamo la funzione patch.
figure('color', [1 1 1])
view(3)
% h1 = patch('Vertices', Vb, 'Faces', Fb, 'EdgeColor', 'none', 'FaceColor', [0.8 0.8 0.8], 'FaceLighting', 'gouraud');
light
grid on
axis on
axis equal
xlabel('X'), ylabel('Y'), zlabel('Z'), hold on
patch('Vertices', Vs, 'Faces', Fs, 'EdgeColor', 'none', 'FaceColor', [0.8 0.8 0.8], 'FaceLighting', 'gouraud')

% Il modello deve essere orientato a "faccia in su": se non lo è bisogna
% ruotarlo. Definire l'angolo di rotazione t.
t = 90; % Angolo di rotazione in gradi.
Rx = [1 0 0; 0 cosd(t) -sind(t); 0 sind(t) cosd(t)]; % Matrice di rotazione attorno all'asse X.

% Applichiamo la matrice di rotazione alle matrici delle coordinate.
Vbrot = (Rx * Vb')';
Vsrot = (Rx * Vs')';

% Per visualizzare il modello in forma z=f(x,y) richiamiamo la funzione
% demonstration_fun, la quale crea una superficie a griglia quadrata a partire dalla
% mesh triangolare. Demonstration_fun chiede in input la matrice dei
% vertici e quella delle facce dei triangoli.
[Xb, Yb, Zb] = demonstration_fun(Vbrot, Fb);
[Xs, Ys, Zs] = demonstration_fun(Vsrot, Fs);

% Visualizziamo la superficie: utilizziamo la funzione surf.
figure;
surf(Xb, Yb, Zb), hold on
surf(Xs, Ys, Zs), hold off
title('Bone and Soft Tissue Models Resampled on a Grid');

% Si potrebbe anche visualizzare ciascuna superficie in figure separate
figure; surf(Xb, Yb, Zb);
title('Bone Model Resampled on a Grid');
figure; surf(Xs, Ys, Zs);
title('Soft Tissue Model Resampled on a Grid');

% Salviamo i dati della mesh in un file .mat per utilizzo successivo
save('paziente1_olivetti.mat', 'Vbrot', 'Fb', 'Vsrot', 'Fs', 'Xb', 'Yb', 'Zb', 'Xs', 'Ys', 'Zs');
