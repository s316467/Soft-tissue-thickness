% Define corresponding points for soft and hard tissues using the new names

% For soft tissue landmarks
glabella_soft = glabella.Position;
nasion_soft = nasion.Position;
sellion_soft = sellion.Position;
endocanthiondx_soft = endocanthion_dx.Position;
endocanthionsx_soft = endocanthion_sx.Position;
exocanthiondx_soft = exocanthion_dx.Position;
exocanthionsx_soft = exocanthion_sx.Position;
orbitaledx_soft = orbitale_dx.Position;
orbitalesx_soft = orbitale_sx.Position;
superiusdx_soft = superius_dx.Position;
superiussx_soft = superius_sx.Position;
zygiondx_soft = zygion_dx.Position;
zygionsx_soft = zygion_sx.Position;
alarcurvaturedx_soft = alar_curvature_dx.Position;
alarcurvaturesx_soft = alar_curvature_sx.Position;

% For hard tissue landmarks
glabella_hard = g.Position;
nasion_hard = n.Position;
sellion_hard = se.Position;
endocanthiondx_hard = endx.Position;
endocanthionsx_hard = ensx.Position;
exocanthiondx_hard = exdx.Position;
exocanthionsx_hard = exsx.Position;
orbitaledx_hard = ordx.Position;
orbitalesx_hard = orsx.Position;
superiusdx_hard = osdx.Position;
superiussx_hard = ossx.Position;
zygiondx_hard = zydx.Position;
zygionsx_hard = zysx.Position;
alarcurvaturedx_hard = alardx.Position;
alarcurvaturesx_hard = alarsx.Position;

% Print sizes of soft tissue landmarks
fprintf('Sizes of soft tissue landmarks:\n');
fprintf('glabella_soft: %s\n', mat2str(size(glabella_soft)));
fprintf('nasion_soft: %s\n', mat2str(size(nasion_soft)));
fprintf('sellion_soft: %s\n', mat2str(size(sellion_soft)));
fprintf('endocanthiondx_soft: %s\n', mat2str(size(endocanthiondx_soft)));
fprintf('endocanthionsx_soft: %s\n', mat2str(size(endocanthionsx_soft)));
fprintf('exocanthiondx_soft: %s\n', mat2str(size(exocanthiondx_soft)));
fprintf('exocanthionsx_soft: %s\n', mat2str(size(exocanthionsx_soft)));
fprintf('orbitaledx_soft: %s\n', mat2str(size(orbitaledx_soft)));
fprintf('orbitalesx_soft: %s\n', mat2str(size(orbitalesx_soft)));
fprintf('superiusdx_soft: %s\n', mat2str(size(superiusdx_soft)));
fprintf('superiussx_soft: %s\n', mat2str(size(superiussx_soft)));
fprintf('zygiondx_soft: %s\n', mat2str(size(zygiondx_soft)));
fprintf('zygionsx_soft: %s\n', mat2str(size(zygionsx_soft)));
fprintf('alarcurvaturedx_soft: %s\n', mat2str(size(alarcurvaturedx_soft)));
fprintf('alarcurvaturesx_soft: %s\n', mat2str(size(alarcurvaturesx_soft)));

% Print sizes of hard tissue landmarks
fprintf('Sizes of hard tissue landmarks:\n');
fprintf('glabella_hard: %s\n', mat2str(size(glabella_hard)));
fprintf('nasion_hard: %s\n', mat2str(size(nasion_hard)));
fprintf('sellion_hard: %s\n', mat2str(size(sellion_hard)));
fprintf('endocanthiondx_hard: %s\n', mat2str(size(endocanthiondx_hard)));
fprintf('endocanthionsx_hard: %s\n', mat2str(size(endocanthionsx_hard)));
fprintf('exocanthiondx_hard: %s\n', mat2str(size(exocanthiondx_hard)));
fprintf('exocanthionsx_hard: %s\n', mat2str(size(exocanthionsx_hard)));
fprintf('orbitaledx_hard: %s\n', mat2str(size(orbitaledx_hard)));
fprintf('orbitalesx_hard: %s\n', mat2str(size(orbitalesx_hard)));
fprintf('superiusdx_hard: %s\n', mat2str(size(superiusdx_hard)));
fprintf('superiussx_hard: %s\n', mat2str(size(superiussx_hard)));
fprintf('zygiondx_hard: %s\n', mat2str(size(zygiondx_hard)));
fprintf('zygionsx_hard: %s\n', mat2str(size(zygionsx_hard)));
fprintf('alarcurvaturedx_hard: %s\n', mat2str(size(alarcurvaturedx_hard)));
fprintf('alarcurvaturesx_hard: %s\n', mat2str(size(alarcurvaturesx_hard)));

% Print the actual values of the landmarks
fprintf('Values of soft tissue landmarks:\n');
disp('glabella_soft:'), disp(glabella_soft)
disp('nasion_soft:'), disp(nasion_soft)
disp('sellion_soft:'), disp(sellion_soft)
disp('endocanthiondx_soft:'), disp(endocanthiondx_soft)
disp('endocanthionsx_soft:'), disp(endocanthionsx_soft)
disp('exocanthiondx_soft:'), disp(exocanthiondx_soft)
disp('exocanthionsx_soft:'), disp(exocanthionsx_soft)
disp('orbitaledx_soft:'), disp(orbitaledx_soft)
disp('orbitalesx_soft:'), disp(orbitalesx_soft)
disp('superiusdx_soft:'), disp(superiusdx_soft)
disp('superiussx_soft:'), disp(superiussx_soft)
disp('zygiondx_soft:'), disp(zygiondx_soft)
disp('zygionsx_soft:'), disp(zygionsx_soft)
disp('alarcurvaturedx_soft:'), disp(alarcurvaturedx_soft)
disp('alarcurvaturesx_soft:'), disp(alarcurvaturesx_soft)

fprintf('Values of hard tissue landmarks:\n');
disp('glabella_hard:'), disp(glabella_hard)
disp('nasion_hard:'), disp(nasion_hard)
disp('sellion_hard:'), disp(sellion_hard)
disp('endocanthiondx_hard:'), disp(endocanthiondx_hard)
disp('endocanthionsx_hard:'), disp(endocanthionsx_hard)
disp('exocanthiondx_hard:'), disp(exocanthiondx_hard)
disp('exocanthionsx_hard:'), disp(exocanthionsx_hard)
disp('orbitaledx_hard:'), disp(orbitaledx_hard)
disp('orbitalesx_hard:'), disp(orbitalesx_hard)
disp('superiusdx_hard:'), disp(superiusdx_hard)
disp('superiussx_hard:'), disp(superiussx_hard)
disp('zygiondx_hard:'), disp(zygiondx_hard)
disp('zygionsx_hard:'), disp(zygionsx_hard)
disp('alarcurvaturedx_hard:'), disp(alarcurvaturedx_hard)
disp('alarcurvaturesx_hard:'), disp(alarcurvaturesx_hard)

% Create arrays of landmarks for easy processing
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

% Ensure both landmarks arrays have the same size
if ~isequal(size(landmarks_soft), size(landmarks_hard))
    error('The dimensions of landmarks_soft and landmarks_hard do not match');
end

% Calculate the Euclidean distances between corresponding landmarks
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

% Save the distances to a .mat file
save('landmark_distances_mm_1_olivetti.mat', 'distances_mm');

% Save the distances to a .csv file
T = table(landmark_names', distances_mm, 'VariableNames', {'Landmark', 'Distance_mm'});
writetable(T, 'landmark_distances_mm_1_olivetti.csv');

fprintf('Distances have been saved to landmark_distances_mm_1_olivetti.mat and landmark_distances_mm_1_olivetti.csv\n');
