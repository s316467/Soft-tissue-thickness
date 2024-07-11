import numpy as np
import pandas as pd
import os
from data_preparation import data_preparation
from ANCOVA import ANCOVA
from RF_DT import RF_DT

def main():
    # Assicurati che il percorso sia relativo alla directory principale del progetto
    base_path = os.path.dirname(os.path.abspath(__file__))
    print(base_path)
    results_path = os.path.join(base_path, 'results')
    print( results_path)
    if not os.path.exists(results_path):
        os.makedirs(results_path)

    all_ages_bmi, all_genders_bmi, all_bmi, all_data_bmi_clean, all_data_clean, all_ages, all_genders, landmark_names, all_data_bmi, all_data = data_preparation(base_path)

    # ANCOVA analysis
    ANCOVA.analysis_ANCOVA(os.path.join(results_path, 'ANCOVA_results_before.txt'), all_data, all_genders, all_ages, landmark_names, 'before cleaning')
    ANCOVA.analysis_ANCOVA_bmi(os.path.join(results_path, 'ANCOVA_bmi_results_before.txt'), all_data_bmi, all_genders_bmi, all_ages_bmi, all_bmi, landmark_names, 'before cleaning')
    ANCOVA.analysis_ANCOVA(os.path.join(results_path, 'ANCOVA_results_after.txt'), all_data_clean, all_genders, all_ages, landmark_names, 'after cleaning')
    ANCOVA.analysis_ANCOVA_bmi(os.path.join(results_path, 'ANCOVA_bmi_results_after.txt'), all_data_bmi_clean, all_genders_bmi, all_ages_bmi, all_bmi, landmark_names, 'after cleaning')

    # Random Forest and Decision Tree analysis
    idx_rf_ab, idx_rf_gb, idx_rf_bmi, idx_rf_gab, idx_dt_bmi, idx_dt_gb, idx_dt_ab, idx_dt_gab, model_bmi, model_gb, model_ab, model_gab = RF_DT.analysis_RF_DT_BMI(landmark_names, all_data_bmi_clean, all_genders_bmi.astype(float), all_ages_bmi.astype(float), all_bmi)

    # Determine best landmarks for models
    ab_landmark = idx_dt_ab if model_ab == 'Decision Tree' else idx_rf_ab
    gb_landmark = idx_dt_gb if model_gb == 'Decision Tree' else idx_rf_gb
    gab_landmark = idx_dt_gab if model_gab == 'Decision Tree' else idx_rf_gab
    bmi_landmark = idx_dt_bmi if model_bmi == 'Decision Tree' else idx_rf_bmi

    with open('Results_RF_DT_with_BMI.txt', 'a') as fileID_BMI, open('Results_RF_DF.txt', 'a') as fileID:
        fileID.write('\n\n\nFinal Consideration\n\n')
        fileID_BMI.write('\n\n\nFinal Consideration\n\n')

        if model_bmi == 'No model':
            fileID_BMI.write('\nThere are not enough information to determine which landmarks are important for your BMI analysis.\n')
        else:
            fileID_BMI.write(f'\n{model_bmi} is the best model for your BMI analysis and it shows that\nthe top landmarks are:\n')
            for idx in bmi_landmark:
                fileID_BMI.write(f'{landmark_names[idx]}\n')

        if model_gb == 'No model':
            fileID_BMI.write('There are not enough information to determine which landmarks are important for your gender and BMI analysis.')
        else:
            fileID_BMI.write(f'\n{model_gb} is the best model for your gender and BMI analysis and it shows that\nthe top landmarks are:\n')
            for idx in gb_landmark:
                fileID_BMI.write(f'{landmark_names[idx]}\n')

        if model_ab == 'No model':
            fileID_BMI.write('There are not enough information to determine which landmarks are important for your age and BMI analysis.')
        else:
            fileID_BMI.write(f'\n{model_ab} is the best model for your age and BMI analysis and it shows that\nthe top landmarks are: \n')
            for idx in ab_landmark:
                fileID_BMI.write(f'{landmark_names[idx]} \n')

        if model_gab == 'No model':
            fileID_BMI.write('There are not enough information to determine which landmarks are important for your gender, age, and BMI analysis.')
        else:
            fileID_BMI.write(f'\n{model_gab} is the best model for your gender, age, and BMI analysis and it shows that\nthe top landmarks are: \n')
            for idx in gab_landmark:
                fileID_BMI.write(f'{landmark_names[idx]} \n')

    # Random Forest and Decision Tree analysis for data without BMI
    rf_age, rf_sex, rf, dt_age, dt_sex, dt, model_age, model_sex, model_ga = RF_DT.analysis_RF_DT(landmark_names, all_data_clean, all_genders, all_ages)

    age_landmark = dt_age if model_age == 'Decision Tree' else rf_age
    sex_landmark = dt_sex if model_sex == 'Decision Tree' else rf_sex
    ga_landmark = dt if model_ga == 'Decision Tree' else rf

    with open('Results_RF_DF.txt', 'a') as fileID:
        fileID.write(f'\n{model_age} is the best model for your age analysis and it shows that \nthe top landmarks are: \n')
        for idx in age_landmark:
            fileID.write(f'{landmark_names[idx]}\n')
        fileID.write(f'\n{model_sex} is the best model for your gender analysis and it shows that\nthe top landmarks are:\n')
        for idx in sex_landmark:
            fileID.write(f'{landmark_names[idx]}\n')
        fileID.write(f'\n{model_ga} is the best model for your combined analysis and it shows that\nthe top landmarks are: \n')
        for idx in ga_landmark:
            fileID.write(f'{landmark_names[idx]} \n')

if __name__ == "__main__":
    main()
