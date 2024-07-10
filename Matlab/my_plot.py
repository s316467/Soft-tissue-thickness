import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from scipy.stats import skew

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

    men_arrays = [men_1, men_2, men_3]
    women_arrays = [women_1, women_2, women_3]

    men_arrays = [arr for arr in men_arrays if arr.size > 0]
    women_arrays = [arr for arr in women_arrays if arr.size > 0]

    # Ensure all arrays have the same number of rows
    min_len_men = min(arr.shape[0] for arr in men_arrays) if men_arrays else 0
    min_len_women = min(arr.shape[0] for arr in women_arrays) if women_arrays else 0
    min_len = min(min_len_men, min_len_women)

    men_arrays = [arr[:min_len, :] for arr in men_arrays]
    women_arrays = [arr[:min_len, :] for arr in women_arrays]

    if men_arrays:
        mean_overall_men = np.nanmean(np.hstack(men_arrays), axis=1)
    else:
        mean_overall_men = np.array([])

    if women_arrays:
        mean_overall_women = np.nanmean(np.hstack(women_arrays), axis=1)
    else:
        mean_overall_women = np.array([])

    f1 = plt.figure()
    if men_arrays:
        for arr in men_arrays:
            plt.plot(arr, label=f'Men Age Group {men_arrays.index(arr) + 1}')
    plt.xlabel('Landmark')
    plt.ylabel('Distances')
    plt.xticks(np.arange(len(landmark_names)), landmark_names, rotation=45)
    plt.title(f'Men distances, without BMI factor - {title_str}')
    plt.legend()
    plt.savefig(f'MEAN_DISTANCES/Men_distances_{title_str.replace(" ", "_")}.png')
    plt.close()

    f2 = plt.figure()
    if women_arrays:
        for arr in women_arrays:
            plt.plot(arr, label=f'Women Age Group {women_arrays.index(arr) + 1}')
    plt.xlabel('Landmark')
    plt.ylabel('Distances')
    plt.xticks(np.arange(len(landmark_names)), landmark_names, rotation=45)
    plt.title(f'Women distances, without BMI factor - {title_str}')
    plt.legend()
    plt.savefig(f'MEAN_DISTANCES/Women_distances_{title_str.replace(" ", "_")}.png')
    plt.close()

    f3 = plt.figure()
    if men_arrays or women_arrays:
        mean_maps = np.hstack(men_arrays + women_arrays)
        categories = ['Men < 25', 'Men 25-60', 'Men >= 60', 'Women < 25', 'Women 25-60', 'Women >= 60']
        for i, category in enumerate(categories[:len(men_arrays) + len(women_arrays)]):
            plt.bar(i, mean_maps[:, i], label=category)
        plt.xlabel('Category')
        plt.ylabel('Mean soft tissue thickness')
        plt.title(f'Mean maps for each category, without BMI factor - {title_str}')
        plt.xticks(np.arange(len(categories)), categories, rotation=45)
        plt.savefig(f'MEAN_DISTANCES/Mean_Distribution_{title_str.replace(" ", "_")}.png')
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
        std_women = np.nanstd(np.hstack(women_arrays), axis=1)
        not_nan_women = np.isfinite(np.hstack(women_arrays))
        num_women = np.sum(not_nan_women, axis=1)
        skewness_women = skew(np.hstack(women_arrays), axis=1, nan_policy='omit')
    else:
        std_women = np.array([])
        num_women = np.array([])
        skewness_women = np.array([])

    if men_arrays:
        std_men = np.nanstd(np.hstack(men_arrays), axis=1)
        not_nan_men = np.isfinite(np.hstack(men_arrays))
        num_men = np.sum(not_nan_men, axis=1)
        skewness_men = skew(np.hstack(men_arrays), axis=1, nan_policy='omit')
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
        key += f'_{all_ages[i]}_{all_bmi[i]}'
        categories[key].append(all_data_clean[:, i])

    for key in categories:
        categories[key] = np.array(categories[key])
        if categories[key].ndim == 1:
            categories[key] = categories[key].reshape(-1, 1)

    # Ensure all arrays have the same number of rows
    min_len = min(arr.shape[0] for arr in categories.values() if arr.size > 0)
    categories = {key: arr[:min_len, :] for key, arr in categories.items() if arr.size > 0}

    fig, ax = plt.subplots(3, 4, figsize=(20, 15))
    fig.suptitle(f'Men and Women distances, BMI factor - {title_str}')

    for i, (key, data) in enumerate(categories.items()):
        ax_idx = divmod(i, 4)
        ax[ax_idx].plot(data)
        ax[ax_idx].set_title(key)
        ax[ax_idx].set_xticks(np.arange(len(landmark_names)))
        ax[ax_idx].set_xticklabels(landmark_names, rotation=45)
        ax[ax_idx].set_xlabel('Landmark')
        ax[ax_idx].set_ylabel('Distances')

    plt.tight_layout()
    plt.savefig(f'MEAN_DISTANCES/MenAndWomen_BMI_{title_str.replace(" ", "_")}.png')
    plt.close()

    f2 = plt.figure()
    mean_maps = np.hstack([categories[key] for key in categories if categories[key].size > 0])
    keys_sorted = sorted([key for key in categories if categories[key].size > 0])
    for i, key in enumerate(keys_sorted):
        plt.bar(i, mean_maps[:, i], label=key)
    plt.xlabel('Category')
    plt.ylabel('Mean soft tissue thickness')
    plt.title(f'Mean maps for each category, with BMI factor - {title_str}')
    plt.xticks(np.arange(len(keys_sorted)), keys_sorted, rotation=45)
    plt.savefig(f'MEAN_DISTANCES/Mean_Distribution_BMI_{title_str.replace(" ", "_")}.png')
    plt.close()
