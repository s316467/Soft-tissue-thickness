
function [men_data_30_50,...
    men_data_u30,men_data_o50,women_data_30_50, women_data_u30, ...
    women_data_o50,women_mean, men_mean,men_bmi_table,women_bmi_table] = olivetti_mean (files_olivetti, olivetti_patients,men_data_30_50,...
    men_data_u30,men_data_o50,women_data_30_50, women_data_u30, ...
    women_data_o50,women_mean, men_mean);



% Mapping

olivetti_patient_id_mapping = containers.Map (...
    { 'landmark_distances_mm_1_olivetti', 'landmark_distances_mm_2_olivetti', 'landmark_distances_mm_6_olivetti',...
    'soggetto_007_landmark', 'soggetto_008_landmark', 'soggetto_009_landmark', 'soggetto10', 'soggetto12', ...
    'landmark_distances_others_mm_soggetto13','landmark_distances_others_mm_soggetto14','landmark_distances_others_mm_soggetto15','soggetto16'}, ...
    { 'S1','S2','S6','S7','S8','S9','S10','S12','S13','S14','S15','S16' });
 % Process Olivetti patient data files
    men_bmi_table = table();
    women_bmi_table = table();
for i = 1:length(files_olivetti)


    file_path = fullfile('olivetti/', files_olivetti(i).name);
    % Read CSV file
    patient_landmark = readtable(file_path);
    name_id = strsplit(files_olivetti(i).name, '.');
    name_id = name_id{1};
    patient_id = olivetti_patient_id_mapping(name_id);
    patient = olivetti_patients(strcmp(olivetti_patients{:, 'Pazienti'}, patient_id) == 1, :);
    
    if (patient.("età")<25)
        age = 'Under 25';
        index =1;
    end
    if (patient.("età") >=25 & patient.("età") <60)
        age = '25-60';
        index =11;
    end
    if (patient.("età") >=60)
        age= 'Over 60';
        index=21;
    end
    if(patient.("età")<24)
        age_bmi = 'Under 23';
    elseif(patient.("età")>=24 & patient.("età")<=28)
        age_bmi = '24-28';
    else
        age_bmi = 'Over 29';
    end
    if(patient.("indice di massa corporea (BMI) [Kg/m2]") <18.5)
        bmi='Underweight';
    elseif(patient.("indice di massa corporea (BMI) [Kg/m2]") >=18.5 & patient.("indice di massa corporea (BMI) [Kg/m2]")<24.9)
        bmi='Normal weight';
    elseif(patient.("indice di massa corporea (BMI) [Kg/m2]") >=24.9 & patient.("indice di massa corporea (BMI) [Kg/m2]") <29.9)
        bmi='Overweight';
    else
        bmi= 'Obese';
    end


    patient_row = table(string(patient_id), patient.sesso, string(age_bmi), string(bmi), patient_landmark.Distance_mm', 'VariableNames', {'PatientID', 'Sex', 'AgeCategory',  'BMI', 'Soft Tissue Thickness'});

    if (strcmp(patient.sesso, 'M'))
        if(strcmp(age, '25-60'))
            men_data_30_50(:, i) = patient_landmark.Distance_mm;
        end
        if (strcmp(age,'Under 25'))
            men_data_u30(:, i) = patient_landmark.Distance_mm;
        end
        if (strcmp(age,'Over 60'))
            men_data_o50(:, i) = patient_landmark.Distance_mm;
        end
        men_bmi_table = [men_bmi_table; patient_row];
   
        
        
        men_mean.("Num Patients")(index:index+9) = men_mean.("Num Patients")(index:index+9) + 1;
    end
    if (strcmp(patient.sesso, 'F'))
         if(strcmp(age, '25-60'))
            women_data_30_50(:, i) = patient_landmark.Distance_mm;
        end
        if (strcmp(age,'Under 25'))
            women_data_u30(:, i) = patient_landmark.Distance_mm;
        end
        if (strcmp(age,'Over 60'))
            women_data_o50(:, i) = patient_landmark.Distance_mm;
        end
        
        women_bmi_table = [women_bmi_table; patient_row];
        women_mean.("Num Patients")(index:index+9) = women_mean.("Num Patients")(index:index+9) + 1;
    end
end


end