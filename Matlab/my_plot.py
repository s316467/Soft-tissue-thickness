import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from scipy.stats import skew
import re
import math
def plot_distances(all_data_clean, all_genders, all_ages, landmark_names, title_str):
    men_1, men_2, men_3 = [], [], []
    women_1, women_2, women_3 = [], [], []
    all_ages = all_ages.astype(int)
    
    all_genders = all_genders.astype(int)
    
    if not os.path.exists('MEAN_DISTANCES'):
        os.makedirs('MEAN_DISTANCES')
    for i in range(all_data_clean.shape[1]):
        
        if all_genders[i] == 1:
            
            if all_ages[i] == 1:
                
                men_1.append(all_data_clean[:, i])
                
            elif all_ages[i] == 2:
                men_2.append(all_data_clean[:, i])
            elif all_ages[i] == 3:
                
                men_3.append(all_data_clean[:, i])
        elif all_genders[i] == 2:
            if all_ages[i] == 1:
                women_1.append(all_data_clean[:, i])
                
            elif all_ages[i] == 2:
                women_2.append(all_data_clean[:, i])
            elif all_ages[i] == 3:
                women_3.append(all_data_clean[:, i])

    men_1, men_2, men_3 = np.array(men_1), np.array(men_2), np.array(men_3)
    
    women_1, women_2, women_3 = np.array(women_1), np.array(women_2), np.array(women_3)
    

    if men_1.ndim == 1:
        men_1 = men_1.reshape(-1, 1)
    if men_2.ndim == 1:
        men_2 = men_2.reshape(-1, 1)
    if men_3.ndim == 1:
        men_3 = men_3.reshape(-1, 1)
    if women_1.ndim == 1:
        women_1 = women_1.reshape(-1, 1)
    if women_2.ndim == 1:
        women_2 = women_2.reshape(-1, 1)
    if women_3.ndim == 1:
        women_3 = women_3.reshape(-1, 1)

    
 
    # Trasponi ciascun array
    men_1_T = men_1.T
    men_2_T = men_2.T
    men_3_T = men_3.T


    men_arrays = np.hstack((men_1_T, men_2_T, men_3_T))
    
    women_1_T = women_1.T
    women_2_T = women_2.T
    women_3_T = women_3.T
    
    women_arrays = np.hstack((women_1_T, women_2_T, women_3_T))


    men_arrays = [arr for arr in men_arrays if arr.size > 0]
    women_arrays = [arr for arr in women_arrays if arr.size > 0]


    # Ensure all arrays have the same number of rows
    # min_len_men = min(arr.shape[0] for arr in men_arrays) if men_arrays else 0
    # min_len_women = min(arr.shape[0] for arr in women_arrays) if women_arrays else 0
    # min_len = min(min_len_men, min_len_women)

    # men_arrays = [arr[:min_len, :] for arr in men_arrays]
    # women_arrays = [arr[:min_len, :] for arr in women_arrays]

    
    if men_arrays:
        mean_overall_men = np.nanmean(men_arrays, axis=1)
    else:
        mean_overall_men = np.array([])

    if women_arrays:
        mean_overall_women = np.nanmean(women_arrays, axis=1)
    else:
        mean_overall_women = np.array([])

    men_1 = np.nanmean(men_1, axis=0)
    men_2 = np.nanmean(men_2, axis=0)
    men_3 = np.nanmean(men_3, axis=0)
    women_1 = np.nanmean(women_1, axis=0)
    women_2 = np.nanmean(women_2, axis=0)
    women_3 = np.nanmean(women_3, axis=0)
    
    f1 = plt.figure()
    new_title = 'Men distances, without BMI factor' + '-' + title_str
    plt.plot(range(1, 11), men_1.T, label='Under 25')
    plt.title(new_title)
    plt.plot(range(1, 11), men_2.T, label='25-60')
    plt.plot(range(1, 11), men_3.T, label='Over 60')
    plt.xlabel('Landmark')
    plt.ylabel('Distances')
    plt.xticks(range(1, len(landmark_names) + 1), landmark_names, rotation='vertical')  # Aggiunto rotation per migliorare la leggibilità
    plt.legend()
    plt.close()

    f2 = plt.figure()
    plt.plot(range(1,11), women_1.T, label='Under 25')
    plt.plot(range(1,11),women_2.T, label='25-60')
    plt.plot(range(1,11), women_3.T, label='Over 60')
    plt.xlabel('Landmark')
    plt.ylabel('Distances')
    plt.xticks(np.arange(len(landmark_names)), landmark_names, rotation=45)
    plt.title(f'Women distances, without BMI factor - {title_str}')
    plt.legend()
    plt.savefig(f'MEAN_DISTANCES/Women_distances_{title_str.replace(" ", "_")}.png')
    plt.close()

    if men_arrays or women_arrays:
        
        mean_maps = np.array([men_1, men_2, men_3, women_1, women_2, women_3]).T
        
        
        
        
        categories = ['Men < 25', 'Men 25-60', 'Men >= 60', 'Women < 25', 'Women 25-60', 'Women >= 60']
        colors = ['r', 'g', 'b', 'c', 'm', 'y']  # Assicurati di avere abbastanza colori per le categorie

        
        num_categories = len(categories)
        num_landmarks = len(landmark_names)

        bar_width = 0.1  # Larghezza delle barre
        space_between_groups = 0.2  # Spazio tra i gruppi di barre

        # Creazione del grafico
        f3=plt.figure(figsize=(12, 8))

        # Calcola la posizione centrale per ogni categoria
        category_positions = np.arange(num_categories) * (num_landmarks * bar_width + space_between_groups)

        for i, category in enumerate(categories):
            # Calcola la posizione di ogni barra all'interno del gruppo della categoria
            bar_positions = category_positions[i] + np.arange(num_landmarks) * bar_width
            
            for j in range(num_landmarks):
                # Plotta una barra per ogni landmark nella categoria corrente
                plt.bar(bar_positions[j], mean_maps[j, i], bar_width, edgecolor="black", color=colors[i], label=f'{category} - {landmark_names[j]}' if i == 0 and j == 0 else "")

        # Aggiusta le etichette dell'asse x per mostrare le categorie al centro di ogni gruppo
        plt.xticks(category_positions + (num_landmarks * bar_width / 2) - (bar_width / 2), categories)

        plt.xlabel('Category')
        plt.ylabel('Mean soft tissue thickness')
        plt.title(f'Mean maps for each category, without BMI factor - {title_str}')

        plt.tight_layout()
        plt.savefig(f'MEAN_DISTANCES/Mean_Distribution_{title_str.replace(" ", "_")}.png')
        # plt.show()
        plt.close()

    f4 = plt.figure()
    if mean_overall_men.size > 0:
        plt.plot(mean_overall_men, label='Men')
    if mean_overall_women.size > 0:
        plt.plot(mean_overall_women, label='Women')
    plt.xlabel('Landmark')
    plt.ylabel('Distances')
    plt.xticks(np.arange(len(landmark_names)), landmark_names, rotation=45)
    plt.title(f'Men distances and Women distances - {title_str}')
    plt.legend()
    
    plt.savefig(f'MEAN_DISTANCES/MenAndWomen_{title_str.replace(" ", "_")}.png')
    plt.close()

    

    if women_arrays:
        
        std_women = np.nanstd(women_arrays, axis=1)
        
        not_nan_women = np.isfinite(women_arrays)
        num_women = np.sum(not_nan_women, axis=1)
        skewness_women = skew(women_arrays, axis=1, nan_policy='omit')
    else:
        std_women = np.array([])
        num_women = np.array([])
        skewness_women = np.array([])

    if men_arrays:
        std_men = np.nanstd((men_arrays), axis=1)
        not_nan_men = np.isfinite((men_arrays))
        num_men = np.sum(not_nan_men, axis=1)
        skewness_men = skew((men_arrays), axis=1, nan_policy='omit')
    else:
        std_men = np.array([])
        num_men = np.array([])
        skewness_men = np.array([])

    table_mean = pd.DataFrame({
        'Landmarks': landmark_names,
        'Men mean': mean_overall_men,
        'Men std': std_men,
        'Skewness men': skewness_men,
        'N men': num_men,
        'Women mean': mean_overall_women,
        'Women std': std_women,
        'Skewness women': skewness_women,
        'N women': num_women
    })

    table_mean.to_csv(f'MenAndWoman_{title_str.replace(" ", "_")}.csv', index=False)

def plot_distances_bmi(all_data_clean, all_genders, all_ages, all_bmi, landmark_names, title_str):
    if not os.path.exists('MEAN_DISTANCES'):
        os.makedirs('MEAN_DISTANCES')

    categories = {
        'men_1_1': [], 'men_1_2': [], 'men_1_3': [], 'men_1_4': [],
        'men_2_1': [], 'men_2_2': [], 'men_2_3': [], 'men_2_4': [],
        'men_3_1': [], 'men_3_2': [], 'men_3_3': [], 'men_3_4': [],
        'women_1_1': [], 'women_1_2': [], 'women_1_3': [], 'women_1_4': [],
        'women_2_1': [], 'women_2_2': [], 'women_2_3': [], 'women_2_4': [],
        'women_3_1': [], 'women_3_2': [], 'women_3_3': [], 'women_3_4': []
    }

    all_ages = all_ages.astype(int)
    all_genders = all_genders.astype(int)
    all_bmi = all_bmi.astype(int)

    for i in range(all_data_clean.shape[1]):
        key = 'men' if all_genders[i] == 1 else 'women'
        key = f'{key}_{all_ages[i]}_{all_bmi[i]}'
        categories[key].append(all_data_clean[:, i])
        

    for key in categories:
        categories[key] = np.array(categories[key])
        if categories[key].ndim == 1:
            categories[key] = categories[key].reshape(-1, 1)


    # Ensure all arrays have the same number of rows
    # min_len = min(arr.shape[0] for arr in categories.values() if arr.size > 0)
    # categories = {key: arr[:min_len, :] for key, arr in categories.items() if arr.size > 0}

    # fig, ax = plt.subplots(3, 4, figsize=(20, 15))
    # fig.suptitle(f'Men and Women distances, BMI factor - {title_str}')


    # for i, (key, data) in enumerate(categories.items()):
    #     ax_idx = divmod(i, 4)
    #     print(data.shape)
    #     ax[ax_idx].plot(data)
    #     ax[ax_idx].set_title(key)
    #     ax[ax_idx].set_xticks(np.arange(len(landmark_names)))
    #     ax[ax_idx].set_xticklabels(landmark_names, rotation=45)
    #     ax[ax_idx].set_xlabel('Landmark')
    #     ax[ax_idx].set_ylabel('Distances')

    for key in categories:
        categories[key] = np.array(categories[key])

    data_men = []
    data_women = []


    for key, data in categories.items():
        
        if key.startswith('men'):
            
            data_men.append(data.transpose())

        elif key.startswith('women'):
            data_women.append(data.transpose())

   
    max_rows = max(data.shape[0] for data in data_men if data.size > 0)

        # Riempi gli array più piccoli con NaN per farli corrispondere alla dimensione massima
    data_men_padded = [np.pad(data, ((0, max_rows - data.shape[0]), (0, 0)), 'constant', constant_values=np.nan) if data.size > 0 else np.full((max_rows, data.shape[1]), np.nan) for data in data_men]
    max_rows = max(data.shape[0] for data in data_women if data.size > 0)
    data_women_padded= [np.pad(data, ((0, max_rows - data.shape[0]), (0, 0)), 'constant', constant_values=np.nan) if data.size > 0 else np.full((max_rows, data.shape[1]), np.nan) for data in data_women]

    # Concatena tutti i dati per 'men' e 'women' in due array NumPy separati
    all_data_men = np.concatenate(data_men_padded, axis=1) if data_men_padded else np.array([])
    all_data_women = np.concatenate(data_women_padded, axis=1) if data_women_padded else np.array([])
            


    # Preparazione degli array per contenere i risultati della skewness
    skewness_men = np.zeros(all_data_men.shape[0])
    skewness_women = np.zeros(all_data_women.shape[0])

    # Calcolo della skewness per ogni riga (landmark) nei dati degli uomini
    for i in range(all_data_men.shape[0]):
        skewness_men[i] = skew(all_data_men[i, :])

    # Calcolo della skewness per ogni riga (landmark) nei dati delle donne
    for i in range(all_data_women.shape[0]):
        skewness_women[i] = skew(all_data_women[i, :])

    # Calcolare la media, escludendo i valori NaN
    mean_overall_men = np.nanmean(all_data_men, axis=1)
    mean_overall_women = np.nanmean(all_data_women, axis=1)
    std_men = np.nanstd(all_data_men, axis=1,ddof=1)
    std_women = np.nanstd(all_data_women, axis=1,ddof=1)
    num_men = all_data_men.shape[1] 
    num_women = all_data_women.shape[1]


    
    # Creazione del grafico a linee
    plt.figure(figsize=(10, 6))
    plt.plot(landmark_names, mean_overall_men, label='Uomini', marker='o', linestyle='-', color='blue')
    plt.plot(landmark_names, mean_overall_women, label='Donne', marker='o', linestyle='-', color='red')

    # Aggiunta di titolo e etichette agli assi
    plt.xlabel('Landmarks')
    plt.ylabel('Mean soft tissue thickness (mm)')
    plt.title(f'Mean soft tissue thickness for men and women - with BMI factor - {title_str} ')
    plt.xticks(rotation=45)  # Assicurati che ogni landmark sia etichettato

    # Aggiunta della legenda
    plt.legend()

    # Visualizzazione del grafico
    plt.tight_layout()
    
    plt.savefig(f'MEAN_DISTANCES/MenAndWomen_BMI_{title_str.replace(" ", "_")}.png')
    plt.close()


    # Calcola la media per ogni chiave nel dizionario, escludendo NaN
    for key in categories.keys():
        # Usa len(array) > 0 per verificare se l'array non è vuoto
        if len(categories[key]) > 0:
            categories[key] = np.nanmean(categories[key], axis=0)
        else:
            # Gestisci il caso di array vuoti come preferisci, qui impostiamo a NaN
            categories[key] = np.nan



    # plt.tight_layout()
    # plt.savefig(f'MEAN_DISTANCES/MenAndWomen_BMI_{title_str.replace(" ", "_")}.png')
    # plt.show()


    # Crea una lista di tutti i valori in categories per passarli a np.column_stack
    values_list = [categories[key] for key in categories.keys()]

    # Trova la dimensione massima degli array lungo l'asse 0
    max_size = max([value.shape[0] if hasattr(value, 'shape') else 1 for value in values_list])

    # Estendi gli array con NaN per farli corrispondere alla dimensione massima, se necessario
    adjusted_values_list = []
    for value in values_list:
        if np.isscalar(value) or len(value) == 0:  # Gestisce scalari o array vuoti
            # Crea un array di NaN della dimensione massima
            adjusted_value = np.full((max_size,), np.nan)
        elif len(value) < max_size:
            # Estendi l'array esistente con NaN per raggiungere la dimensione massima
            adjusted_value = np.pad(value, (0, max_size - len(value)), constant_values=np.nan)
        else:
            adjusted_value = value
        adjusted_values_list.append(adjusted_value)

    # Concatena gli array adattati come colonne in mean_maps
    mean_maps = np.column_stack(adjusted_values_list)
    



    # for i, key in enumerate(keys_sorted):
    #     plt.bar(i, mean_maps[:, i], label=key)
    # plt.xlabel('Category')
    # plt.ylabel('Mean soft tissue thickness')
    # plt.title(f'Mean maps for each category, with BMI factor - {title_str}')
    # plt.xticks(np.arange(len(keys_sorted)), keys_sorted, rotation=45)
    # plt.savefig(f'MEAN_DISTANCES/Mean_Distribution_BMI_{title_str.replace(" ", "_")}.png')
    # plt.show()

        # Identifica le colonne (categorie) senza NaN

    valid_columns = ~np.isnan(mean_maps).all(axis=0)


    # Filtra mean_maps per escludere colonne con NaN
    filtered_mean_maps = mean_maps[:, valid_columns]


    # Filtra categories_keys per escludere le categorie con NaN
  
    mapping_dict = {
    'men_1_1': 'Men < 24, Underweight',
    'men_1_2': 'Men < 24, Normal weight',
    'men_1_3': 'Men < 24, Overweight',
    'men_1_4': 'Men < 24, Obese',
    'men_2_1': 'Men 24-29, Underweight',
    'men_2_2': 'Men 24-29, Normal weight',
    'men_2_3': 'Men 24-29, Overweight',
    'men_2_4': 'Men 24-29, Obese',
    'men_3_1': 'Men >= 29, Underweight',
    'men_3_2': 'Men >= 29, Normal weight',
    'men_3_3': 'Men >= 29, Overweight',
    'men_3_4': 'Men >= 29, Obese',
    'women_1_1': 'Woman < 24, Underweight',
    'women_1_2': 'Woman < 24, Normal weight',
    'women_1_3': 'Woman < 24, Overweight',
    'women_1_4': 'Woman < 24, Obese',
    'women_2_1': 'Woman 24-29, Underweight',
    'women_2_2': 'Woman 24-29, Normal weight',
    'women_2_3': 'Woman 24-29, Overweight',
    'women_2_4': 'Woman 24-29, Obese',
    'women_3_1': 'Woman >= 29, Underweight',
    'women_3_2': 'Woman >= 29, Normal weight',
    'women_3_3': 'Woman >= 29, Overweight',
    'women_3_4': 'Woman >= 29, Obese',

}

    filtered_categories_keys = np.array(list(categories.keys()))[valid_columns]
    mapped_filtered_keys = [mapping_dict[key] for key in filtered_categories_keys]

    # Aggiorna num_categories e num_values basandoti sulle dimensioni di filtered_mean_maps
    num_categories = filtered_mean_maps.shape[1]
    num_values = filtered_mean_maps.shape[0]

    # Distanza tra i gruppi di barre, larghezza di ogni barra, ecc., rimangono invariati
    group_width = 0.8
    bar_width = group_width / num_values
    group_positions = np.arange(num_categories)

    # Crea il grafico con i dati filtrati
    fig, ax = plt.subplots(figsize=(23, 18))



    for i in range(num_values):
        bar_positions = group_positions - (group_width - bar_width) / 2 + i * bar_width
        ax.bar(bar_positions, filtered_mean_maps[i, :], width=bar_width,edgecolor="black", label=f'Value {i+1}')

    ax.set_xticks(group_positions)

    ax.set_xticklabels(mapped_filtered_keys, rotation=45, ha='right')
    ax.set_xlabel('Categories')
    ax.set_ylabel('Mean soft tissue thickness')

    ax.set_title(f'Mean Maps per Category with BMI factor - {title_str}')
    plt.savefig(f'MEAN_DISTANCES/Mean_Distribution_BMI_{title_str.replace(" ", "_")}.png')


    plt.close()



    fig, ax = plt.subplots()
    for category, values in categories.items():

        if category.startswith("men") and not np.isnan(values).all():
            # Calcola il numero di landmarks per la categoria corrente
            num_landmarks = len(values)
            # Crea una lista di numeri da 1 a num_landmarks per l'asse delle ascisse
            landmarks = list(range(1, num_landmarks + 1))
            # Disegna la linea per la categoria corrente
            ax.plot(landmarks, values, label=mapping_dict[category])
        
    ax.set_xlabel('Landmarks')
    ax.set_ylabel('Valori')
    ax.set_title(f'Mean value for {"men".title()} with BMI factor - {title_str}')
    plt.savefig(f'MEAN_DISTANCES/Men_distances_BMI_{title_str.replace(" ", "_")}.png')
    ax.legend()
    plt.close()


    fig, ax = plt.subplots()
    for category, values in categories.items():
        if category.startswith("women") and not np.isnan(values).all():
            # Calcola il numero di landmarks per la categoria corrente
            num_landmarks = len(values)
            # Crea una lista di numeri da 1 a num_landmarks per l'asse delle ascisse
            landmarks = list(range(1, num_landmarks + 1))
            # Disegna la linea per la categoria corrente
            ax.plot(landmarks, values, label=mapping_dict[category])
        
    ax.set_xlabel('Landmarks')
    ax.set_ylabel('Valori')
    ax.set_title(f'Mean value for {"women".title()} with BMI factor - {title_str}')
    plt.savefig(f'MEAN_DISTANCES/Women_distances_BMI_{title_str.replace(" ", "_")}.png')
    ax.legend()
    plt.close()


    # f2 = plt.figure()
    # plt.plot(range(1,11), women_1.T, label='Under 25')
    # plt.plot(range(1,11),women_2.T, label='25-60')
    # plt.plot(range(1,11), women_3.T, label='Over 60')
    # plt.xlabel('Landmark')
    # plt.ylabel('Distances')
    # plt.xticks(np.arange(len(landmark_names)), landmark_names, rotation=45)
    # plt.title(f'Women distances, without BMI factor - {title_str}')
    # plt.legend()
    # plt.savefig(f'MEAN_DISTANCES/Women_distances_{title_str.replace(" ", "_")}.png')
    # plt.close()
    
    table_mean = pd.DataFrame({
    'Landmarks': landmark_names,
    'Men mean': mean_overall_men,
    'Men std': std_men,
    'Skewness men': skewness_men,
    'N men': num_men,
    'Women mean': mean_overall_women,
    'Women std': std_women,
    'Skewness women': skewness_women,
    'N women': num_women
    })

    table_mean.to_csv(f'MenAndWoman_BMI_{title_str.replace(" ", "_")}.csv', index=False)