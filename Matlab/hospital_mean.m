%hospital_mean.m

function [men_table, women_table] = hospital_mean(patients,files_patients,folder_path, ...
     hospital_id,  men_table, women_table)


hmr_patient_id_mapping = containers.Map(...
    {'hmr_001_landmark', 'hmr_002_landmark', 'hmr_003_landmark', 'hmr_004_landmark', ...
     'hmr_005_landmark', 'hmr_006_landmark', 'hmr_007_landmark', 'hmr_008_landmark', ...
     'hmr_019_landmark', 'hmr_027_landmark', 'HN-HRM-041'}, ...
    {'HN-HMR-001', 'HN-HMR-002', 'HN-HMR-003', 'HN-HMR-004', ...
     'HN-HMR-005', 'HN-HMR-006', 'HN-HMR-007', 'HN-HMR-008', ...
     'HN-HMR-019', 'HN-HMR-027','HN-HMR-041'});

chum_patient_id_mapping = containers.Map(...
    {'landmark_distances_mm_1', 'landmark_distances_mm_3', 'landmark_distances_mm_4', ...
    'landmark_distances_mm_5','landmark_distances_mm_6','landmark_distances_mm_7' ...
    'landmark_distances_mm_8','landmark_distances_mm_11','landmark_distances_mm_13','landmark_distances_mm_14', ...
    'HN-CHUM-061','HN-CHUM-063', 'HN-CHUM-064'}, ...
    {'HN-CHUM-001', 'HN-CHUM-003', 'HN-CHUM-004',... 
     'HN-CHUM-005', 'HN-CHUM-006','HN-CHUM-007','HN-CHUM-008','HN-CHUM-011', ...
     'HN-CHUM-013','HN-CHUM-014','HN-CHUM-061', ...
     'HN-CHUM-063', 'HN-CHUM-064'} );

chus_patient_id_mapping = containers.Map( ...
    {'HNCHUS001_distances', 'HNCHUS002_distances', 'HNCHUS003_distances', ...
    'HNCHUS004_distances', 'HNCHUS005_distances'}, ...
    {'HN-CHUS-001', 'HN-CHUS-002', 'HN-CHUS-003', 'HN-CHUS-004', 'HN-CHUS-005'});
hgj_patient_id_mapping = containers.Map(...
    {'HN-HGJ-005', 'HN-HGJ-006', 'HN-HGJ-008', ...
    'HN-HGJ-009','HN-HGJ-012','HN-HGJ-091'}, ...
    {'HN-HGJ-005', 'HN-HGJ-006', 'HN-HGJ-008',... 
     'HN-HGJ-009', 'HN-HGJ-012', 'HN-HGJ-091' } );


% Read CSV file


    for i = 1:length(files_patients)
                file_path = fullfile(folder_path, files_patients(i).name);
                patient_landmark = readtable(file_path);
                name_id = strsplit(files_patients(i).name, '.');
                name_id = name_id{1};

                if (hospital_id == 1) 
                      patient_id = chum_patient_id_mapping(name_id);
                      
                end
                if (hospital_id == 2)
                    patient_id = hmr_patient_id_mapping(name_id);

                end
               
                if (hospital_id == 3) 
                      patient_id = hgj_patient_id_mapping(name_id);
                end
                if (hospital_id == 4) 
                      patient_id = chus_patient_id_mapping(name_id);
                end
                patient = patients(strcmp(patients{:, 'Patient #'}, patient_id), :);
               
                
                % Determine age category
                if (patient.Age < 25)
                    age = 'Under 25';
                    
                elseif (patient.Age >= 25 && patient.Age < 60)
                    age = '25-60';
                elseif (patient.Age >= 60)
                    age = 'Over 60';
                end
                hospital_patient = table(string(patient_id), patient.Sex, string(age), patient_landmark.Distance_mm', 'VariableNames', {'PatientID', 'Sex', 'AgeCategory', 'Soft Tissue Thickness'});

                
                % Update mean and standard deviation for men
                if (strcmp(patient.Sex, 'M'))
                   
                    men_table = [men_table; hospital_patient];

            
                end
            
                % Update mean and standard deviation for women
                if (strcmp(patient.Sex, 'F'))
            
                    
                    women_table = [women_table; hospital_patient];
                    
                end
    end
end

