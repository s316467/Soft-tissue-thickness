import pandas as pd
import os

def olivetti_mean(files_olivetti, olivetti_patients, women_table, men_table):
    olivetti_patient_id_mapping = {
        'landmark_distances_mm_1_olivetti': 'S1', 'landmark_distances_mm_2_olivetti': 'S2', 'soggetto4_distances': 'S4',
        'soggetto5_distances': 'S5', 'landmark_distances_mm_6_olivetti': 'S6', 'soggetto_007_landmark': 'S7',
        'soggetto_008_landmark': 'S8', 'soggetto_009_landmark': 'S9', 'soggetto10': 'S10', 'soggetto12': 'S12',
        'Soggetto13': 'S13', 'Soggetto14': 'S14', 'Soggetto15': 'S15', 'soggetto16': 'S16'
    }

    men_bmi_table = pd.DataFrame()
    women_bmi_table = pd.DataFrame()

    for file_path in files_olivetti:
        patient_landmark = pd.read_csv(file_path)
        name_id = os.path.basename(file_path).split('.')[0]  # Estrai solo il nome del file senza percorso
        if name_id not in olivetti_patient_id_mapping:
            print(f"Warning: '{name_id}' not found in olivetti_patient_id_mapping. Skipping this file.")
            continue
        
        patient_id = olivetti_patient_id_mapping[name_id]
        patient = olivetti_patients.loc[olivetti_patients['Pazienti'] == patient_id]

        if 'Distance_mm' not in patient_landmark.columns:
            print(f"Warning: 'Distance_mm' not found in {file_path}. Skipping this file.")
            continue

        if patient['età'].values[0] < 25:
            age = 'Under 25'
        elif 25 <= patient['età'].values[0] < 60:
            age = '25-60'
        else:
            age = 'Over 60'

        if patient['età'].values[0] < 24:
            age_bmi = 'Under 24'
        elif 24 <= patient['età'].values[0] < 29:
            age_bmi = '24-29'
        else:
            age_bmi = 'Over 29'

        if patient['indice di massa corporea (BMI) [Kg/m2]'].values[0] < 18.5:
            bmi = 'Underweight'
        elif 18.5 <= patient['indice di massa corporea (BMI) [Kg/m2]'].values[0] < 24.9:
            bmi = 'Normal weight'
        elif 24.9 <= patient['indice di massa corporea (BMI) [Kg/m2]'].values[0] < 29.9:
            bmi = 'Overweight'
        else:
            bmi = 'Obese'

        patient_row = pd.DataFrame({
            'PatientID': [patient_id],
            'Sex': [patient['sesso'].values[0]],
            'AgeCategory': [age_bmi],
            'BMI': [bmi],
            'Soft Tissue Thickness': [patient_landmark['Distance_mm'].values]
        })

        hospital_patient = pd.DataFrame({
            'PatientID': [patient_id],
            'Sex': [patient['sesso'].values[0]],
            'AgeCategory': [age],
            'Soft Tissue Thickness': [patient_landmark['Distance_mm'].values]
        })

        if patient['sesso'].values[0] == 'M':
            men_bmi_table = pd.concat([men_bmi_table, patient_row], ignore_index=True)
            men_table = pd.concat([men_table, hospital_patient], ignore_index=True)
        else:
            women_bmi_table = pd.concat([women_bmi_table, patient_row], ignore_index=True)
            women_table = pd.concat([women_table, hospital_patient], ignore_index=True)

    return men_bmi_table, women_bmi_table, women_table, men_table
