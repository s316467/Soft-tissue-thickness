import pandas as pd
import numpy as np
import os

def hospital_mean(patients, files_patients, folder_path, hospital_id, men_table, women_table):
    hmr_patient_id_mapping = {
        'hmr_001_landmark': 'HN-HMR-001', 'hmr_002_landmark': 'HN-HMR-002', 'hmr_003_landmark': 'HN-HMR-003', 'hmr_004_landmark': 'HN-HMR-004',
        'hmr_005_landmark': 'HN-HMR-005', 'hmr_006_landmark': 'HN-HMR-006', 'hmr_007_landmark': 'HN-HMR-007', 'hmr_008_landmark': 'HN-HMR-008',
        'hmr_019_landmark': 'HN-HMR-019', 'hmr_027_landmark': 'HN-HMR-027', 'HN-HRM-041': 'HN-HMR-041'
    }

    chum_patient_id_mapping = {
        'landmark_distances_mm_1': 'HN-CHUM-001', 'landmark_distances_mm_3': 'HN-CHUM-003', 'landmark_distances_mm_4': 'HN-CHUM-004',
        'landmark_distances_mm_5': 'HN-CHUM-005', 'landmark_distances_mm_6': 'HN-CHUM-006', 'landmark_distances_mm_7': 'HN-CHUM-007',
        'landmark_distances_mm_8': 'HN-CHUM-008', 'landmark_distances_mm_11': 'HN-CHUM-011', 'landmark_distances_mm_13': 'HN-CHUM-013',
        'landmark_distances_mm_14': 'HN-CHUM-014', 'HN-CHUM-061': 'HN-CHUM-061', 'HN-CHUM-063': 'HN-CHUM-063', 'HN-CHUM-064': 'HN-CHUM-064'
    }

    chus_patient_id_mapping = {
        'HNCHUS001_distances': 'HN-CHUS-001', 'HNCHUS002_distances': 'HN-CHUS-002', 'HNCHUS003_distances': 'HN-CHUS-003',
        'HNCHUS004_distances': 'HN-CHUS-004', 'HNCHUS005_distances': 'HN-CHUS-005', 'HNCHUS006_distances': 'HN-CHUS-006',
        'HNCHUS007_distances': 'HN-CHUS-007', 'HNCHUS008_distances': 'HN-CHUS-008', 'HNCHUS009_distances': 'HN-CHUS-009',
        'HNCHUS0010_distances': 'HN-CHUS-010', 'HNCHUS0011_distances': 'HN-CHUS-011', 'HNCHUS0012_distances': 'HN-CHUS-012', 'HNCHUS0013_distances': 'HN-CHUS-013'
    }

    hgj_patient_id_mapping = {
        'HN-HGJ-005': 'HN-HGJ-005', 'HN-HGJ-006': 'HN-HGJ-006', 'HN-HGJ-008': 'HN-HGJ-008',
        'HN-HGJ-009': 'HN-HGJ-009', 'HN-HGJ-012': 'HN-HGJ-012', 'HN-HGJ-091': 'HN-HGJ-091'
    }

    patient_id_mapping = {
        0: chum_patient_id_mapping,
        1: hmr_patient_id_mapping,
        2: hgj_patient_id_mapping,
        3: chus_patient_id_mapping
    }

    current_mapping = patient_id_mapping[hospital_id]

    for file_path in files_patients:
        if isinstance(file_path, str):
            patient_landmark = pd.read_csv(file_path)
            name_id = os.path.basename(file_path).split('.')[0]

            if name_id in current_mapping:
                patient_id = current_mapping[name_id]
            else:
                continue

            # Stampa i nomi delle colonne per la verifica
            print(f"Columns in {file_path}: {patient_landmark.columns}")

            if 'Distance_mm' not in patient_landmark.columns:
                print(f"Warning: 'Distance_mm' not found in {file_path}. Skipping this file.")
                continue

            patient = patients.loc[patients['Patient #'] == patient_id]

            if patient.empty:
                continue

            if patient['Age'].values[0] < 25:
                age = 'Under 25'
            elif 25 <= patient['Age'].values[0] < 60:
                age = '25-60'
            else:
                age = 'Over 60'

            hospital_patient = pd.DataFrame({
                'PatientID': [patient_id],
                'Sex': [patient['Sex'].values[0]],
                'AgeCategory': [age],
                'Soft Tissue Thickness': [patient_landmark['Distance_mm'].values]
            })

            if patient['Sex'].values[0] == 'M':
                men_table = pd.concat([men_table, hospital_patient], ignore_index=True)
            else:
                women_table = pd.concat([women_table, hospital_patient], ignore_index=True)

    return men_table, women_table
