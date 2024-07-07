
close all;
clear all;


[all_ages_bmi, all_genders_bmi, all_bmi, all_data_bmi_clean, all_data_clean, all_ages, all_genders, landmark_names, all_data_bmi, all_data] = data_preparation();



%%%%% before cleaning 
ANCOVA_landmark_before = ANCOVA.analysis_ANCOVA('ANCOVA_results_before.txt',all_data,all_genders,all_ages,landmark_names, 'before cleaning');
ANCOVA_landmark_bmi_before = ANCOVA.analysis_ANCOVA_bmi('ANCOVA_bmi_results_before.txt',all_data_bmi, all_genders_bmi, all_ages_bmi, all_bmi, landmark_names, 'before cleaning');


%%% ANOVA analysis after cleaning
ANCOVA_landmark_after = ANCOVA.analysis_ANCOVA('ANCOVA_results_after.txt',all_data_clean,all_genders,all_ages,landmark_names, 'after cleaning');
ANCOVA_landmark_bmi_after = ANCOVA.analysis_ANCOVA_bmi('ANCOVA_bmi_results_after.txt',all_data_bmi_clean, all_genders_bmi, all_ages_bmi, all_bmi, landmark_names, 'after cleaning');

close all;

[idx_rf_ab,idx_rf_gb, idx_rf_bmi, idx_rf_gab,idx_dt_bmi,idx_dt_gb, idx_dt_ab,idx_dt_gab, model_bmi, model_gb, model_ab, model_gab]=RF_DT.analysis_RF_DT_BMI(landmark_names, all_data_bmi_clean, double(all_genders_bmi), double(all_ages_bmi), all_bmi);


if (strcmp(model_ab, 'Decision Tree'))
    ab_landmark=idx_dt_ab;
else
    ab_landmark=idx_rf_ab;
end
if(strcmp(model_gb,'Decision Tree'))
    gb_landmark=idx_dt_gb;
else
    gb_landmark=idx_rf_gb;
end
if(strcmp(model_gab,'Decision Tree'))
    gab_landmark=idx_dt_gab;
else
    gab_landmark=idx_rf_gab;
end
if(strcmp(model_bmi,'Decision Tree'))
    bmi_landmark=idx_dt_bmi;
else
    bmi_landmark=idx_rf_bmi;
end


fileID_BMI = fopen('Results_RF_DT_with_BMI.txt', 'a');
fileID = fopen('Results_RF_DF.txt','a');


fprintf(fileID,'\n\n\nFinal Consideration\n\n');
fprintf(fileID_BMI,'\n\n\nFinal Consideration\n\n');

if(strcmp(model_bmi, 'No model'))
    fprintf(fileID_BMI,'\nThere are not enough information to determine which landmarks are important for your bmi analysis.\n');
else
    fprintf(fileID_BMI,'\n%s is the best model for your bmi analysis and it shows that\nthe top landmarks are:\n', model_bmi);
    for i=1:size(bmi_landmark,2)
        fprintf(fileID_BMI,'%s\n',landmark_names{bmi_landmark(i)});
    end
end

if(strcmp(model_gb, 'No model'))
    fprintf(fileID_BMI,'There are not enough information to determine which landmarks are important for your gender and bmi analysis.');
else
    fprintf(fileID_BMI,'\n%s is the best model for your gender and bmi analysis and it shows that\nthe top landmarks are:\n', model_gb);
    for i=1:size(gb_landmark,2)
        fprintf(fileID_BMI,'%s\n',landmark_names{gb_landmark(i)});
    end

end

if(strcmp(model_ab, 'No model'))
    fprintf(fileID_BMI,'There are not enough information to determine which landmarks are important for your age and bmi analysis.');
else

    fprintf(fileID_BMI,'\n%s is the best model for your age and bmi analysis and it shows that\nthe top landmarks are: \n', model_ab);
    for i=1:size(ab_landmark,2)
        fprintf(fileID_BMI,'%s \n',landmark_names{ab_landmark(i)});
    end
end

if(strcmp(model_gab, 'No model'))
    fprintf(fileID_BMI,'There are not enough information to determine which landmarks are important for your gender,age and bmi analysis.');
else

    fprintf(fileID_BMI,'\n%s is the best model for your gender,age and bmi analysis and it shows that\nthe top landmarks are: \n', model_gab);
    for i=1:size(gab_landmark,2)
        fprintf(fileID_BMI,'%s \n',landmark_namesg{ab_landmark(i)});
    end

end

% Random Forest and Decision Tree analysis for data without BMI
% classification

[rf_age,rf_sex,rf,dt_age,dt_sex,dt,model_age,model_sex,model_ga] =RF_DT.analysis_RF_DT(landmark_names, all_data_clean, all_genders, all_ages);


if (strcmp(model_age, 'Decision Tree'))
    age_landmark=dt_age;
else
    age_landmark=rf_age;
end
if(strcmp(model_sex,'Decision Tree'))
    sex_landmark=dt_sex;
else
    sex_landmark=rf_sex;
end
if(strcmp(model_ga,'Decision Tree'))
    ga_landmark=dt;
else
    ga_landmark=rf;
end


fprintf(fileID,'\n%s is the best model for your age analysis and it shows that \nthe top landmarks are: \n', model_age);
for i=1:size(age_landmark,2)
    fprintf(fileID,'%s\n',landmark_names{age_landmark(i)});
end
fprintf(fileID,'\n%s is the best model for your gender analysis and it shows that\nthe top landmarks are:\n', model_sex);
for i=1:size(sex_landmark,2)
    fprintf(fileID,'%s\n',landmark_names{sex_landmark(i)});
end
fprintf(fileID,'\n%s is the best model for your combined analysis and it shows that\nthe top landmarks are: \n', model_ga);
for i=1:size(ga_landmark,2)
    fprintf(fileID,'%s \n',landmark_names{ga_landmark(i)});
end



fclose(fileID);
fclose(fileID_BMI);

close all;