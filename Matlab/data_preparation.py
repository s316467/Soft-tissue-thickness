import pandas as pd
import numpy as np
import os
from hospital_mean import hospital_mean
from olivetti_mean import olivetti_mean
import my_plot

def read_csv_files(folder_path):
    all_files = []
    for file_name in os.listdir(folder_path):
        if file_name.endswith('.csv'):
            file_path = os.path.join(folder_path, file_name)
            all_files.append(file_path)
    return all_files

def data_preparation():
    patients = pd.read_csv('information/INFOclinical_HN_Version2_30may2018_Metadata.csv')
    olivetti_patients = pd.read_excel('information/elenco_soggetti_operazioni_olivetti.xlsx')
    folder_path = ['chum/', 'hmr/', 'hgj/', 'chus/']

    all_files_patients = []

    for folder in folder_path:
        files_patients = read_csv_files(folder)
        all_files_patients.extend(files_patients)

    files_olivetti = read_csv_files('olivetti/')

    print("Files olivetti:", files_olivetti)

    landmark_names = ['Glabella', 'Nasion', 'Orbital Right', 'Orbital Left', 'Superius Right', 'Superius Left', 'Zygion Right', 'Zygion Left', 'Rhinion', 'Midphiltrum']

    men_table = pd.DataFrame()
    women_table = pd.DataFrame()

    for hospital_id, folder in enumerate(folder_path):
        files_patients = read_csv_files(folder)
        men_table, women_table = hospital_mean(patients, files_patients, folder, hospital_id, men_table, women_table)

    men_bmi_table, women_bmi_table, women_table, men_table = olivetti_mean(files_olivetti, olivetti_patients, women_table, men_table)

    genders_bmi_women = women_bmi_table['Sex'].to_numpy()
    ages_bmi_women = women_bmi_table['AgeCategory'].to_numpy()
    bmi_women = women_bmi_table['BMI'].to_numpy()
    bmi_landmarks_women = np.vstack(women_bmi_table["Soft Tissue Thickness"].apply(np.array))

    genders_bmi_men = men_bmi_table['Sex'].to_numpy()
    ages_bmi_men = men_bmi_table['AgeCategory'].to_numpy()
    bmi_men = men_bmi_table['BMI'].to_numpy()
    bmi_landmarks_men = np.vstack(men_bmi_table["Soft Tissue Thickness"].apply(np.array))

    print(f"bmi_landmarks_women shape: {bmi_landmarks_women.shape}")
    print(f"bmi_landmarks_men shape: {bmi_landmarks_men.shape}")

    all_data_bmi = np.concatenate((bmi_landmarks_men, bmi_landmarks_women), axis=1)
    all_genders_bmi = np.concatenate((genders_bmi_men, genders_bmi_women))
    all_ages_bmi = np.concatenate((ages_bmi_men, ages_bmi_women))
    all_bmi = np.concatenate((bmi_men, bmi_women))

    print(f"Length of all_genders_bmi: {len(all_genders_bmi)}")
    print(f"Length of all_ages_bmi: {len(all_ages_bmi)}")
    print(f"Length of all_bmi: {len(all_bmi)}")
    print(f"Shape of all_data_bmi: {all_data_bmi.shape}")

    if len(all_genders_bmi) != all_data_bmi.shape[1]:
        print("Mismatch detected between all_genders_bmi and all_data_bmi. Adjusting arrays.")
        min_len = min(len(all_genders_bmi), all_data_bmi.shape[1])
        all_genders_bmi = all_genders_bmi[:min_len]
        all_ages_bmi = all_ages_bmi[:min_len]
        all_bmi = all_bmi[:min_len]
        all_data_bmi = all_data_bmi[:, :min_len]

    genders_women = women_table['Sex'].to_numpy()
    genders_men = men_table['Sex'].to_numpy()
    ages_women = women_table['AgeCategory'].to_numpy()
    ages_men = men_table['AgeCategory'].to_numpy()
    landmark_women = np.vstack(women_table["Soft Tissue Thickness"].apply(np.array))
    landmark_men = np.vstack(men_table["Soft Tissue Thickness"].apply(np.array))

    print(f"landmark_women shape: {landmark_women.shape}")
    print(f"landmark_men shape: {landmark_men.shape}")

    if len(landmark_women.shape) == 1:
        landmark_women = landmark_women.reshape(1, -1)
    if len(landmark_men.shape) == 1:
        landmark_men = landmark_men.reshape(1, -1)

    min_len = min(len(genders_men), len(genders_women), len(ages_men), len(ages_women))
    landmark_men = landmark_men[:min_len]
    genders_men = genders_men[:min_len]
    ages_men = ages_men[:min_len]

    landmark_women = landmark_women[:min_len]
    genders_women = genders_women[:min_len]
    ages_women = ages_women[:min_len]

    all_data = np.concatenate((landmark_men, landmark_women), axis=1)
    all_genders = np.concatenate((genders_men, genders_women))
    all_ages = np.concatenate((ages_men, ages_women))

    gender_mapping = {'M': 1, 'F': 2}
    all_genders_bmi = np.array([gender_mapping[x] for x in all_genders_bmi])
    all_genders_bmi = pd.Categorical(all_genders_bmi, categories=[1, 2], ordered=True)

    age_mapping = {'Under 24': 1, '24-29': 2, 'Over 29': 3}
    all_ages_bmi = np.array([age_mapping[x] for x in all_ages_bmi])
    all_ages_bmi = pd.Categorical(all_ages_bmi, categories=[1, 2, 3], ordered=True)

    bmi_mapping = {'Underweight': 1, 'Normal weight': 2, 'Overweight': 3, 'Obese': 4}
    all_bmi = np.array([bmi_mapping[x] for x in all_bmi])

    gender_mapping = {'M': 1, 'F': 2}
    all_genders = np.array([gender_mapping[x] for x in all_genders])

    age_mapping = {'Under 25': 1, '25-60': 2, 'Over 60': 3}
    all_ages = np.array([age_mapping[x] for x in all_ages])
    all_ages = pd.Categorical(all_ages, categories=[1, 2, 3], ordered=True)

    num_patients_bmi = all_data_bmi.shape[1]
    print(f"Number of BMI patients: {num_patients_bmi}")
    rand_indices_bmi = np.random.permutation(num_patients_bmi)
    print(f"Random indices for BMI patients: {rand_indices_bmi}")

    all_data_bmi = all_data_bmi[:, rand_indices_bmi]
    all_ages_bmi = all_ages_bmi[rand_indices_bmi]
    all_genders_bmi = all_genders_bmi[rand_indices_bmi]
    all_bmi = all_bmi[rand_indices_bmi]

    num_patients = all_data.shape[1]
    print(f"Number of patients: {num_patients}")
    rand_indices = np.random.permutation(num_patients)
    print(f"Random indices for patients: {rand_indices}")

    all_data = all_data[:, rand_indices]
    all_ages = all_ages[rand_indices]
    all_genders = all_genders[rand_indices]

    all_data_bmi_clean = []
    for row in all_data_bmi:
        outliers = np.isnan(row.astype(float))
        row[outliers] = np.nan
        all_data_bmi_clean.append(row)
    all_data_bmi_clean = np.array(all_data_bmi_clean)

    all_data_clean = []
    for row in all_data:
        outliers = np.isnan(row.astype(float))
        row[outliers] = np.nan
        all_data_clean.append(row)
    all_data_clean = np.array(all_data_clean)

    my_plot.plot_distances(all_data, all_genders, all_ages, landmark_names, 'before cleaning')
    my_plot.plot_distances(all_data_clean, all_genders, all_ages, landmark_names, 'after cleaning')
    my_plot.plot_distances_bmi(all_data_bmi, all_genders_bmi, all_ages_bmi, all_bmi, landmark_names, 'before cleaning')
    my_plot.plot_distances_bmi(all_data_bmi_clean, all_genders_bmi, all_ages_bmi, all_bmi, landmark_names, 'after cleaning')

    return all_ages_bmi, all_genders_bmi, all_bmi, all_data_bmi_clean, all_data_clean, all_ages, all_genders, landmark_names, all_data_bmi, all_data

if __name__ == "__main__":
    all_ages_bmi, all_genders_bmi, all_bmi, all_data_bmi_clean, all_data_clean, all_ages, all_genders, landmark_names, all_data_bmi, all_data = data_preparation()
