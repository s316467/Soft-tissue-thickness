
function [men_data_30_50,...
    men_data_u30,men_data_o50,women_data_30_50, women_data_u30, ...
    women_data_o50,women_mean, men_mean] = olivetti_mean(files_olivetti, olivetti_patients,men_data_30_50,...
    men_data_u30,men_data_o50,women_data_30_50, women_data_u30, ...
    women_data_o50,women_mean, men_mean)



% Mapping

olivetti_patient_id_mapping = containers.Map (...
    { 'landmark_distances_mm_1_olivetti', 'landmark_distances_mm_2_olivetti', 'landmark_distances_mm_6_olivetti',...
    'soggetto_007_landmark', 'soggetto_008_landmark', 'soggetto_009_landmark'}, ...
    { 'S1','S2','S6','S7','S8','S9' });
 % Process Olivetti patient data files
for i = 1:length(files_olivetti)


    file_path = fullfile('olivetti/', files_olivetti(i).name);
    % Read CSV file
    patient_landmark = readtable(file_path);
    name_id = strsplit(files_olivetti(i).name, '.');
    name_id = name_id{1};
    patient_id = olivetti_patient_id_mapping(name_id);
    patient = olivetti_patients(strcmp(olivetti_patients{:, 'Pazienti'}, patient_id) == 1, :);
    if (patient.("età")<30)
        age = 'Under 30';
        index =1;
    end
    if (patient.("età") >=30 & patient.("età") <50)
        age = '30-50';
        index =11;
    end
    if (patient.("età") >=50)
        age= 'Over 50';
        index=21;
    end
    if (strcmp(patient.sesso, 'M'))
         if(strcmp(age, '30-50'))
            men_data_30_50(:, i) = patient_landmark.Distance_mm;
        end
        if (strcmp(age,'Under 30'))
            men_data_u30(:, i) = patient_landmark.Distance_mm;
        end
        if (strcmp(age,'Over 50'))
            men_data_o50(:, i) = patient_landmark.Distance_mm;
        end

        men_mean.("Num Patients")(index:index+9) = men_mean.("Num Patients")(index:index+9) + 1;
    end
    if (strcmp(patient.sesso, 'F'))
         if(strcmp(age, '30-50'))
            women_data_30_50(:, i) = patient_landmark.Distance_mm;
        end
        if (strcmp(age,'Under 30'))
            women_data_u30(:, i) = patient_landmark.Distance_mm;
        end
        if (strcmp(age,'Over 50'))
            women_data_o50(:, i) = patient_landmark.Distance_mm;
        end

        women_mean.("Num Patients")(index:index+9) = women_mean.("Num Patients")(index:index+9) + 1;
    end
end


end