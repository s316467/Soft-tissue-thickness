
close all;
clear all;


[all_ages_bmi, all_genders_bmi, all_bmi, all_data_bmi_clean, all_data_clean, all_ages, all_genders, landmark_names] = data_preparation();


%%% ANOVA analysis
ANOVA_landmark = analysis_ANOVA(all_data_clean,all_genders,all_ages,landmark_names);
ANOVA_landmark_bmi = analysis_ANOVA_bmi(all_data_bmi_clean, all_genders_bmi, all_ages_bmi, all_bmi, landmark_names);

% In an initial ANOVA analysis, 
% it helps me identify the landmarks that significantly differ between gender groups, age groups,
% or a combination of both.


[idx_rf_ab,idx_rf_gb, idx_rf_bmi, idx_rf_gab,idx_dt_bmi,idx_dt_gb, idx_dt_ab,idx_dt_gab, model_bmi, model_gb, model_ab, model_gab]=analysis_RF_DT_BMI(landmark_names, all_data_bmi_clean, double(all_genders_bmi), double(all_ages_bmi), all_bmi);


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



if(strcmp(model_bmi, 'No model'))
    fprintf('There are not enough information to determine which landmarks are important for your bmi analysis.');
else
    fprintf('\n%s is the best model for your bmi analysis and it shows that\nthe top landmarks are:\n', model_bmi);
    for i=1:size(bmi_landmark,2)
        fprintf('%s\n',landmark_names{bmi_landmark(i)});
    end
end

if(strcmp(model_gb, 'No model'))
    fprintf('There are not enough information to determine which landmarks are important for your gender and bmi analysis.');
else
    fprintf('\n%s is the best model for your gender and bmi analysis and it shows that\nthe top landmarks are:\n', model_gb);
    for i=1:size(gb_landmark,2)
        fprintf('%s\n',landmark_names{gb_landmark(i)});
    end

end

if(strcmp(model_ab, 'No model'))
    fprintf('There are not enough information to determine which landmarks are important for your age and bmi analysis.');
else
    
    fprintf('\n%s is the best model for your age and bmi analysis and it shows that\nthe top- landmarks are: \n', model_ab);
    for i=1:size(ab_landmark,2)
        fprintf('%s \n',landmark_names{ab_landmark(i)});
    end
end

if(strcmp(model_gab, 'No model'))
    fprintf('There are not enough information to determine which landmarks are important for your gender,age and bmi analysis.');
else
   
    fprintf('\n%s is the best model for your gender,age and bmi analysis and it shows that\nthe top- landmarks are: \n', model_gab);
    for i=1:size(gab_landmark,2)
        fprintf('%s \n',landmark_namesg{ab_landmark(i)});
    end

end

% Random Forest and Decision Tree analysis for data without BMI
% classification

[rf_age,rf_sex,rf,dt_age,dt_sex,dt,model_age,model_sex,model_ga] =analysis_RF_DT(landmark_names, all_data_clean, all_genders, all_ages);


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


fprintf('\n%s is the best model for your age analysis and it shows that \nthe top landmarks are: \n', model_age);
for i=1:size(age_landmark,2)
    fprintf('%s\n',landmark_names{age_landmark(i)});
end
fprintf('\n%s is the best model for your gender analysis and it shows that\nthe top landmarks are:\n', model_sex);
for i=1:size(sex_landmark,2)
    fprintf('%s\n',landmark_names{sex_landmark(i)});
end
fprintf('\n%s is the best model for your combined analysis and it shows that\nthe top- landmarks are: \n', model_ga);
for i=1:size(ga_landmark,2)
    fprintf('%s \n',landmark_names{ga_landmark(i)});
end


