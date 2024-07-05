% Define corresponding points for soft and hard tissues using the new names

% For soft tissue landmarks
glabella_soft = glabella.Position;
nasion_soft = nasion.Position;
orbitaledx_soft = orbitale_dx.Position;
orbitalesx_soft = orbitale_sx.Position;
superiusdx_soft = superius_dx.Position;
superiussx_soft = superius_sx.Position;
zygiondx_soft = zygion_dx.Position;
zygionsx_soft = zygion_sx.Position;
midphiltrum_soft = midphiltrum.Position;
rhinion_soft = rhinion.Position;

% For hard tissue landmarks
glabella_hard = g.Position;
nasion_hard = n.Position;
orbitaledx_hard = ordx.Position;
orbitalesx_hard = orsx.Position;
superiusdx_hard = osdx.Position;
superiussx_hard = ossx.Position;
zygiondx_hard = zydx.Position;
zygionsx_hard = zysx.Position;
midphiltrum_hard = mp.Position;
rhinion_hard = rh.Position;

% Print sizes of soft tissue landmarks
fprintf('Sizes of soft tissue landmarks:\n');
fprintf('glabella_soft: %s\n', mat2str(size(glabella_soft)));
fprintf('orbitaledx_soft: %s\n', mat2str(size(orbitaledx_soft)));
fprintf('orbitalesx_soft: %s\n', mat2str(size(orbitalesx_soft)));
fprintf('superiusdx_soft: %s\n', mat2str(size(superiusdx_soft)));
fprintf('superiussx_soft: %s\n', mat2str(size(superiussx_soft)));
fprintf('zygiondx_soft: %s\n', mat2str(size(zygiondx_soft)));
fprintf('zygionsx_soft: %s\n', mat2str(size(zygionsx_soft)));
fprintf('midphiltrum_soft: %s\n', mat2str(size(midphiltrum_soft)));
fprintf('rhinion_soft: %s\n', mat2str(size(rhinion_soft)));

% Print sizes of hard tissue landmarks
fprintf('Sizes of hard tissue landmarks:\n');
fprintf('glabella_hard: %s\n', mat2str(size(glabella_hard)));
fprintf('orbitaledx_hard: %s\n', mat2str(size(orbitaledx_hard)));
fprintf('orbitalesx_hard: %s\n', mat2str(size(orbitalesx_hard)));
fprintf('superiusdx_hard: %s\n', mat2str(size(superiusdx_hard)));
fprintf('superiussx_hard: %s\n', mat2str(size(superiussx_hard)));
fprintf('zygiondx_hard: %s\n', mat2str(size(zygiondx_hard)));
fprintf('zygionsx_hard: %s\n', mat2str(size(zygionsx_hard)));
fprintf('midphiltrum_hard: %s\n', mat2str(size(midphiltrum_hard)));
fprintf('rhinion_hard: %s\n', mat2str(size(rhinion_hard)));

% Print the actual values of the landmarks
fprintf('Values of soft tissue landmarks:\n');
disp('glabella_soft:'), disp(glabella_soft)
disp('nasion_soft:'), disp(nasion_soft)
disp('orbitaledx_soft:'), disp(orbitaledx_soft)
disp('orbitalesx_soft:'), disp(orbitalesx_soft)
disp('superiusdx_soft:'), disp(superiusdx_soft)
disp('superiussx_soft:'), disp(superiussx_soft)
disp('zygiondx_soft:'), disp(zygiondx_soft)
disp('zygionsx_soft:'), disp(zygionsx_soft)
disp('midphiltrum_soft:'), disp(midphiltrum_soft)
disp('rhinion_soft:'), disp(rhinion_soft)

fprintf('Values of hard tissue landmarks:\n');
disp('glabella_hard:'), disp(glabella_hard)
disp('nasion_hard:'), disp(nasion_hard)
disp('orbitaledx_hard:'), disp(orbitaledx_hard)
disp('orbitalesx_hard:'), disp(orbitalesx_hard)
disp('superiusdx_hard:'), disp(superiusdx_hard)
disp('superiussx_hard:'), disp(superiussx_hard)
disp('zygiondx_hard:'), disp(zygiondx_hard)
disp('zygionsx_hard:'), disp(zygionsx_hard)
disp('midphiltrum_hard:'), disp(midphiltrum_hard)
disp('rhinion_hard:'), disp(rhinion_hard)

% Create arrays of landmarks for easy processing
landmarks_soft = [glabella_soft; nasion_soft; orbitaledx_soft; orbitalesx_soft; ...
                  superiusdx_soft; superiussx_soft; ...
                  zygiondx_soft; zygionsx_soft; ...
                  midphiltrum_soft; rhinion_soft];

landmarks_hard = [glabella_hard; nasion_hard; orbitaledx_hard; orbitalesx_hard; ...
                  superiusdx_hard; superiussx_hard; ...
                  zygiondx_hard; zygionsx_hard; ...
                  midphiltrum_hard; rhinion_hard];

% Ensure both landmarks arrays have the same size
if ~isequal(size(landmarks_soft), size(landmarks_hard))
    error('The dimensions of landmarks_soft and landmarks_hard do not match');
end

% Calculate the Euclidean distances between corresponding landmarks
distances_mm = sqrt(sum((landmarks_soft - landmarks_hard).^2, 2));

% Display the distances in millimeters
landmark_names = {'Glabella', 'Nasion', ...
                  'Orbital Right', 'Orbital Left', ...
                  'Superius Right', 'Superius Left', ...
                  'Zygion Right', 'Zygion Left', ...
                  'Rhinion', 'Midphiltrum'};

for i = 1:length(distances_mm)
    fprintf('Distance for landmark %s: %f mm\n', landmark_names{i}, distances_mm(i));
end

% Save the distances to a .mat file
save('landmark_distances_mm_1.mat', 'distances_mm');

% Save the distances to a .csv file
T = table(landmark_names, distances_mm, 'VariableNames', {'Landmark', 'Distance_mm'});
writetable(T, 'landmark_distances_mm_1.csv');

fprintf('Distances have been saved to landmark_distances_mm_1.mat and landmark_distances_mm_1.csv\n');
