import numpy as np
import os
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import StratifiedKFold
import matplotlib.pyplot as plt
import pandas as pd

class RF_DT:

    @staticmethod
    def analysis_RF_DT(landmark_names, all_data, all_genders, all_ages):
        num_landmarks = len(landmark_names)
        if not os.path.exists('RF_DT_ANALYSIS'):
            os.makedirs('RF_DT_ANALYSIS')

        k = 10
        skf_genders = StratifiedKFold(n_splits=k)
        skf_ages = StratifiedKFold(n_splits=k)
        skf_combined = StratifiedKFold(n_splits=k)

        accuracy_sex_rf_fold = np.zeros(k)
        accuracy_sex_dt_fold = np.zeros(k)
        accuracy_age_rf_fold = np.zeros(k)
        accuracy_age_dt_fold = np.zeros(k)
        accuracy_dt_fold = np.zeros(k)
        accuracy_rf_fold = np.zeros(k)

        importance_rf_sex_fold = []
        importance_rf_age_fold = []
        importance_dt_sex_fold = []
        importance_dt_age_fold = []
        importance_dt_fold = []
        importance_rf_fold = []

        for i in range(len(landmark_names)):
            row = all_data[i, :]
            nan_idx = np.isnan(row)
            mean_value = np.nanmean(row)
            row[nan_idx] = mean_value
            all_data[i, :] = row

        combined_labels = np.char.add(np.char.add(all_genders.astype(str), '_'), all_ages.astype(str))

        for fold, (train_idx, test_idx) in enumerate(skf_genders.split(all_data.T, all_genders)):
            X_train_genders = all_data[:, train_idx]
            X_test_genders = all_data[:, test_idx]
            y_train_genders = all_genders[train_idx]
            y_test_genders = all_genders[test_idx]

            rf_model_sex = RandomForestClassifier(n_estimators=100)
            rf_model_sex.fit(X_train_genders.T, y_train_genders)
            y_pred_rf_sex = rf_model_sex.predict(X_test_genders.T)
            accuracy_sex_rf_fold[fold] = np.mean(y_pred_rf_sex == y_test_genders)
            importance_rf_sex_fold.append(rf_model_sex.feature_importances_)

            dt_model_sex = DecisionTreeClassifier()
            dt_model_sex.fit(X_train_genders.T, y_train_genders)
            y_pred_dt_sex = dt_model_sex.predict(X_test_genders.T)
            accuracy_sex_dt_fold[fold] = np.mean(y_pred_dt_sex == y_test_genders)
            importance_dt_sex_fold.append(dt_model_sex.feature_importances_)

        for fold, (train_idx, test_idx) in enumerate(skf_ages.split(all_data.T, all_ages)):
            X_train_ages = all_data[:, train_idx]
            X_test_ages = all_data[:, test_idx]
            y_train_ages = all_ages[train_idx]
            y_test_ages = all_ages[test_idx]

            rf_model_age = RandomForestClassifier(n_estimators=100)
            rf_model_age.fit(X_train_ages.T, y_train_ages)
            y_pred_rf_age = rf_model_age.predict(X_test_ages.T)
            accuracy_age_rf_fold[fold] = np.mean(y_pred_rf_age == y_test_ages)
            importance_rf_age_fold.append(rf_model_age.feature_importances_)

            dt_model_age = DecisionTreeClassifier()
            dt_model_age.fit(X_train_ages.T, y_train_ages)
            y_pred_dt_age = dt_model_age.predict(X_test_ages.T)
            accuracy_age_dt_fold[fold] = np.mean(y_pred_dt_age == y_test_ages)
            importance_dt_age_fold.append(dt_model_age.feature_importances_)

        for fold, (train_idx, test_idx) in enumerate(skf_combined.split(all_data.T, combined_labels)):
            X_train_combined = all_data[:, train_idx]
            X_test_combined = all_data[:, test_idx]
            y_train_combined = combined_labels[train_idx]
            y_test_combined = combined_labels[test_idx]

            rf_model_combined = RandomForestClassifier(n_estimators=100)
            rf_model_combined.fit(X_train_combined.T, y_train_combined)
            y_pred_rf_combined = rf_model_combined.predict(X_test_combined.T)
            accuracy_rf_fold[fold] = np.mean(y_pred_rf_combined == y_test_combined)
            importance_rf_fold.append(rf_model_combined.feature_importances_)

            dt_model_combined = DecisionTreeClassifier()
            dt_model_combined.fit(X_train_combined.T, y_train_combined)
            y_pred_dt_combined = dt_model_combined.predict(X_test_combined.T)
            accuracy_dt_fold[fold] = np.mean(y_pred_dt_combined == y_test_combined)
            importance_dt_fold.append(dt_model_combined.feature_importances_)

        mean_accuracy_rf_sex = np.mean(accuracy_sex_rf_fold)
        mean_accuracy_rf_age = np.mean(accuracy_age_rf_fold)
        mean_accuracy_dt_sex = np.mean(accuracy_sex_dt_fold)
        mean_accuracy_dt_age = np.mean(accuracy_age_dt_fold)
        mean_accuracy_rf = np.mean(accuracy_rf_fold)
        mean_accuracy_dt = np.mean(accuracy_dt_fold)

        importance_rf_sex = np.mean(importance_rf_sex_fold, axis=0)
        importance_rf_age = np.mean(importance_rf_age_fold, axis=0)
        importance_dt_sex = np.mean(importance_dt_sex_fold, axis=0)
        importance_dt_age = np.mean(importance_dt_age_fold, axis=0)
        importance_rf = np.mean(importance_rf_fold, axis=0)
        importance_dt = np.mean(importance_dt_fold, axis=0)

        idx_rf_sex = np.argsort(-importance_rf_sex)[:3]
        idx_rf_age = np.argsort(-importance_rf_age)[:3]
        idx_dt_sex = np.argsort(-importance_dt_sex)[:3]
        idx_dt_age = np.argsort(-importance_dt_age)[:3]
        idx_rf = np.argsort(-importance_rf)[:3]
        idx_dt = np.argsort(-importance_dt)[:3]

        with open('Results_RF_DF.txt', 'w') as fileID:
            fileID.write('RESULTS\n\n')
            fileID.write(f'\n\nAccuracy for gender analysis with Random Forest: {mean_accuracy_rf_sex * 100:.2f}%\n')
            fileID.write(f'Accuracy for age analysis with Random Forest: {mean_accuracy_rf_age * 100:.2f}%\n')
            fileID.write(f'Accuracy for gender analysis with Decision Tree: {mean_accuracy_dt_sex * 100:.2f}%\n')
            fileID.write(f'Accuracy for age analysis with Decision Tree: {mean_accuracy_dt_age * 100:.2f}%\n')
            fileID.write(f'\nAccuracy with Decision Tree with combined labels: {mean_accuracy_dt * 100:.2f}%\n')
            fileID.write(f'\nAccuracy with Random Forest with combined labels: {mean_accuracy_rf * 100:.2f}%\n\n')

        choosing_model = 'Decision Tree' if mean_accuracy_dt_age > mean_accuracy_rf_age else 'Random Forest'
        top_age = idx_dt_age if choosing_model == 'Decision Tree' else idx_rf_age

        choosing_model = 'Decision Tree' if mean_accuracy_dt_sex > mean_accuracy_rf_sex else 'Random Forest'
        top_gender = idx_dt_sex if choosing_model == 'Decision Tree' else idx_rf_sex

        choosing_model = 'Decision Tree' if mean_accuracy_dt > mean_accuracy_rf else 'Random Forest'
        top_combined = idx_dt if choosing_model == 'Decision Tree' else idx_rf

        f1, axarr = plt.subplots(1, 2, figsize=(14, 7))
        axarr[0].bar(np.arange(num_landmarks), importance_rf_sex, color='blue')
        axarr[0].bar(idx_rf_sex, importance_rf_sex[idx_rf_sex], color='red')
        axarr[0].set_xticks(np.arange(num_landmarks))
        axarr[0].set_xticklabels(landmark_names, rotation=45)
        axarr[0].set_title(f'Importance for Gender for Random Forest\naccuracy={mean_accuracy_rf_sex*100:.2f}%')

        axarr[1].bar(np.arange(num_landmarks), importance_dt_sex, color='blue')
        axarr[1].bar(idx_dt_sex, importance_dt_sex[idx_dt_sex], color='red')
        axarr[1].set_xticks(np.arange(num_landmarks))
        axarr[1].set_xticklabels(landmark_names, rotation=45)
        axarr[1].set_title(f'Importance for Gender for Decision Tree\naccuracy={mean_accuracy_dt_sex*100:.2f}%')
        plt.savefig('RF_DT_ANALYSIS/gender_RF_DT.png')
        plt.close()

        f2, axarr = plt.subplots(1, 2, figsize=(14, 7))
        axarr[0].bar(np.arange(num_landmarks), importance_rf_age, color='blue')
        axarr[0].bar(idx_rf_age, importance_rf_age[idx_rf_age], color='red')
        axarr[0].set_xticks(np.arange(num_landmarks))
        axarr[0].set_xticklabels(landmark_names, rotation=45)
        axarr[0].set_title(f'Importance for Age for Random Forest\naccuracy={mean_accuracy_rf_age*100:.2f}%')

        axarr[1].bar(np.arange(num_landmarks), importance_dt_age, color='blue')
        axarr[1].bar(idx_dt_age, importance_dt_age[idx_dt_age], color='red')
        axarr[1].set_xticks(np.arange(num_landmarks))
        axarr[1].set_xticklabels(landmark_names, rotation=45)
        axarr[1].set_title(f'Importance for Age for Decision Tree\naccuracy={mean_accuracy_dt_age*100:.2f}%')
        plt.savefig('RF_DT_ANALYSIS/age_RF_DT.png')
        plt.close()

        f3, axarr = plt.subplots(1, 2, figsize=(14, 7))
        axarr[0].bar(np.arange(num_landmarks), importance_rf, color='blue')
        axarr[0].bar(idx_rf, importance_rf[idx_rf], color='red')
        axarr[0].set_xticks(np.arange(num_landmarks))
        axarr[0].set_xticklabels(landmark_names, rotation=45)
        axarr[0].set_title(f'Importance for Combined Labels for Random Forest\naccuracy={mean_accuracy_rf*100:.2f}%')

        axarr[1].bar(np.arange(num_landmarks), importance_dt, color='blue')
        axarr[1].bar(idx_dt, importance_dt[idx_dt], color='red')
        axarr[1].set_xticks(np.arange(num_landmarks))
        axarr[1].set_xticklabels(landmark_names, rotation=45)
        axarr[1].set_title(f'Importance for Combined Labels for Decision Tree\naccuracy={mean_accuracy_dt*100:.2f}%')
        plt.savefig('RF_DT_ANALYSIS/age_gender_RF_DT.png')
        plt.close()

        if mean_accuracy_rf_age > mean_accuracy_dt_age:
            model_age = 'Random Forest'
        else:
            model_age = 'Decision Tree'

        if mean_accuracy_rf_sex > mean_accuracy_dt_sex:
            model_sex = 'Random Forest'
        else:
            model_sex = 'Decision Tree'

        if mean_accuracy_rf > mean_accuracy_dt:
            model_ga = 'Random Forest'
        else:
            model_ga = 'Decision Tree'

        return idx_rf_age, idx_rf_sex, idx_rf, idx_dt_age, idx_dt_sex, idx_dt, model_age, model_sex, model_ga
