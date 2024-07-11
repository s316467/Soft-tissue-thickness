import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
import statsmodels.api as sm
from statsmodels.formula.api import ols

class ANCOVA:
    
    @staticmethod
    def analysis_ANCOVA(file_name, all_data, all_genders, all_ages, landmark_names, title_str):
        with open(file_name, 'w') as fileID:
            p = np.zeros((all_data.shape[0], 3))
            significant_landmark = np.zeros((all_data.shape[0], 3))
            F_Gender = np.zeros((all_data.shape[0], 1))
            F_Age = np.zeros((all_data.shape[0], 1))
            F_Interaction = np.zeros((all_data.shape[0], 1))
            chosen_landmarks = [None, None, None]

            if not os.path.exists('ANCOVA_Analysis'):
                os.makedirs('ANCOVA_Analysis')

            title_new = f'ANCOVA analysis with age and gender analysis-{title_str}'
            
            for i in range(all_data.shape[0]):
                df = pd.DataFrame({
                    'Landmark': all_data[i, :],
                    'Gender': all_genders,
                    'Age': all_ages
                })
                model = ols('Landmark ~ C(Gender) + Age + C(Gender):Age', data=df).fit()
                anova_table = sm.stats.anova_lm(model, typ=2)
                p[i, 0] = anova_table['PR(>F)']['C(Gender)']
                p[i, 1] = anova_table['PR(>F)']['Age']
                p[i, 2] = anova_table['PR(>F)']['C(Gender):Age']
                F_Gender[i] = anova_table['F']['C(Gender)']
                F_Age[i] = anova_table['F']['Age']
                F_Interaction[i] = anova_table['F']['C(Gender):Age']

            for i in range(len(landmark_names)):
                significant_landmark[i, 0] = (p[i, 0] < 0.05) and (F_Gender[i] > 1)
                significant_landmark[i, 1] = (p[i, 1] < 0.05) and (F_Age[i] > 1)
                significant_landmark[i, 2] = (p[i, 2] < 0.05) and (F_Interaction[i] > 1)

            significant_gender_indices = np.where(significant_landmark[:, 0] == 1)[0]
            significant_age_indices = np.where(significant_landmark[:, 1] == 1)[0]
            significant_interaction_indices = np.where(significant_landmark[:, 2] == 1)[0]



            fileID.write(f'ANCOVA results {title_str}\n')

            if len(significant_gender_indices) > 0:
                chosen_landmarks[0] = significant_gender_indices
                fileID.write('\nIt allows me to say that for the gender analysis, the most significant landmarks are:\n')
                for i in significant_gender_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the gender analysis\n there are no significant landmarks for classification by Gender\n')

            if len(significant_age_indices) > 0:
                chosen_landmarks[1] = significant_age_indices
                fileID.write('\nIt allows me to say that for the age analysis, the most significant landmarks are:\n\n')
                for i in significant_age_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the age analysis\n there are no significant landmarks for classification by Age\n\n')

            if len(significant_interaction_indices) > 0:
                chosen_landmarks[2] = significant_interaction_indices
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and gender,\n the most significant landmarks are:\n\n')
                for i in significant_interaction_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and gender\n there are no significant landmarks for classification by Age and Gender\n\n')

            plt.figure()
            bar_width = 0.25
            x = np.arange(p.shape[0])

            plt.bar(x, p[:, 0], bar_width, label='Gender')
            plt.bar(x + bar_width, p[:, 1], bar_width, label='Age')
            plt.bar(x + 2 * bar_width, p[:, 2], bar_width, label='Interaction')

            plt.xticks(x + bar_width, landmark_names, rotation=45)
            plt.xlabel('Landmark')
            plt.ylabel('p-value')
            plt.title(title_new)
            plt.axhline(y=0.05, color='r', linestyle='--')
            plt.legend(loc='upper right')
            plt.tight_layout()
            plt.savefig(f'ANCOVA_Analysis/ANCOVA_{title_str.replace(" ", "_")}.png')
            plt.close()


        return chosen_landmarks

    @staticmethod
    def analysis_ANCOVA_bmi(name_file, all_data, all_genders, all_ages, all_bmi, landmark_names, title_str):
        if not os.path.exists('ANCOVA_Analysis'):
            os.makedirs('ANCOVA_Analysis')
        
        p = np.zeros((all_data.shape[0], 7))
        significant_landmark = np.zeros((all_data.shape[0], 7))
        F_Gender = np.zeros((all_data.shape[0], 1))
        F_Age = np.zeros((all_data.shape[0], 1))
        F_BMI = np.zeros((all_data.shape[0], 1))
        F_Interaction_GA = np.zeros((all_data.shape[0], 1))
        F_Interaction_GB = np.zeros((all_data.shape[0], 1))
        F_Interaction_AB = np.zeros((all_data.shape[0], 1))
        F_Interaction_GAB = np.zeros((all_data.shape[0], 1))
        chosen_landmarks = [None] * 7
        title_new = f'ANCOVA analysis with BMI factor-{title_str}'

        with open(name_file, 'w') as fileID:
            fileID.write(f'ANCOVA analysis with BMI factor {title_str}\n')
            for i in range(all_data.shape[0]):
                df = pd.DataFrame({
                    'Landmark': all_data[i, :],
                    'Gender': all_genders,
                    'Age': all_ages,
                    'BMI': all_bmi
                })
                model = ols('Landmark ~ C(Gender) + Age + BMI + C(Gender):Age + C(Gender):BMI + Age:BMI + C(Gender):Age:BMI', data=df).fit()
                anova_table = sm.stats.anova_lm(model, typ=2)
                p[i, 0] = anova_table['PR(>F)']['C(Gender)']
                p[i, 1] = anova_table['PR(>F)']['Age']
                p[i, 2] = anova_table['PR(>F)']['BMI']
                p[i, 3] = anova_table['PR(>F)']['C(Gender):Age']
                p[i, 4] = anova_table['PR(>F)']['C(Gender):BMI']
                p[i, 5] = anova_table['PR(>F)']['Age:BMI']
                p[i, 6] = anova_table['PR(>F)']['C(Gender):Age:BMI']
                F_Gender[i] = anova_table['F']['C(Gender)']
                F_Age[i] = anova_table['F']['Age']
                F_BMI[i] = anova_table['F']['BMI']
                F_Interaction_GA[i] = anova_table['F']['C(Gender):Age']
                F_Interaction_GB[i] = anova_table['F']['C(Gender):BMI']
                F_Interaction_AB[i] = anova_table['F']['Age:BMI']
                F_Interaction_GAB[i] = anova_table['F']['C(Gender):Age:BMI']

            for i in range(len(landmark_names)):
                significant_landmark[i, 0] = (p[i, 0] < 0.05) and (F_Gender[i] > 1)
                significant_landmark[i, 1] = (p[i, 1] < 0.05) and (F_Age[i] > 1)
                significant_landmark[i, 2] = (p[i, 2] < 0.05) and (F_BMI[i] > 1)
                significant_landmark[i, 3] = (p[i, 3] < 0.05) and (F_Interaction_GA[i] > 1)
                significant_landmark[i, 4] = (p[i, 4] < 0.05) and (F_Interaction_GB[i] > 1)
                significant_landmark[i, 5] = (p[i, 5] < 0.05) and (F_Interaction_AB[i] > 1)
                significant_landmark[i, 6] = (p[i, 6] < 0.05) and (F_Interaction_GAB[i] > 1)

            significant_gender_indices = np.where(significant_landmark[:, 0] == 1)[0]
            significant_age_indices = np.where(significant_landmark[:, 1] == 1)[0]
            significant_bmi_indices = np.where(significant_landmark[:, 2] == 1)[0]
            significant_interactionGA_indices = np.where(significant_landmark[:, 3] == 1)[0]
            significant_interactionGB_indices = np.where(significant_landmark[:, 4] == 1)[0]
            significant_interactionAB_indices = np.where(significant_landmark[:, 5] == 1)[0]
            significant_interactionGAB_indices = np.where(significant_landmark[:, 6] == 1)[0]


            if len(significant_gender_indices) > 0:
                chosen_landmarks[0] = significant_gender_indices
                fileID.write('\nIt allows me to say that for the gender analysis, the most significant landmarks are:\n')
                for i in significant_gender_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the gender analysis\n there are no significant landmarks for classification by Gender\n')

            if len(significant_age_indices) > 0:
                chosen_landmarks[1] = significant_age_indices
                fileID.write('\nIt allows me to say that for the age analysis, the most significant landmarks are:\n')
                for i in significant_age_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the age analysis\n there are no significant landmarks for classification by Age\n\n')

            if len(significant_bmi_indices) > 0:
                chosen_landmarks[2] = significant_bmi_indices
                fileID.write('\nIt allows me to say that for the BMI analysis, the most significant landmarks are:\n')
                for i in significant_bmi_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the BMI analysis\n there are no significant landmarks for classification by BMI\n\n')

            if len(significant_interactionGA_indices) > 0:
                chosen_landmarks[3] = significant_interactionGA_indices
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and gender,\n the most significant landmarks are:\n\n')
                for i in significant_interactionGA_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and gender\n there are no significant landmarks for classification by Age and Gender\n\n')

            if len(significant_interactionGB_indices) > 0:
                chosen_landmarks[4] = significant_interactionGB_indices
                fileID.write('\nIt allows me to say that for the analysis of the interaction of gender and BMI,\n the most significant landmarks are:\n\n')
                for i in significant_interactionGB_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the analysis of the interaction of gender and BMI\n there are no significant landmarks for classification by Gender and BMI\n\n')

            if len(significant_interactionAB_indices) > 0:
                chosen_landmarks[5] = significant_interactionAB_indices
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and BMI,\n the most significant landmarks are:\n\n')
                for i in significant_interactionAB_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and BMI\n there are no significant landmarks for classification by Age and BMI\n\n')

            if len(significant_interactionGAB_indices) > 0:
                chosen_landmarks[6] = significant_interactionGAB_indices
                fileID.write('\nIt allows me to say that for the analysis of the interaction of gender, age and BMI,\n the most significant landmarks are:\n\n')
                for i in significant_interactionGAB_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the analysis of the interaction of gender, age and BMI\n there are no significant landmarks for classification by Gender, Age and BMI\n\n')

            plt.figure()
            bar_width = 0.1
            x = np.arange(p.shape[0])

            plt.bar(x, p[:, 0], bar_width, label='Gender')
            plt.bar(x + bar_width, p[:, 1], bar_width, label='Age')
            plt.bar(x + 2 * bar_width, p[:, 2], bar_width, label='BMI')
            plt.bar(x + 3 * bar_width, p[:, 3], bar_width, label='Interaction GA')
            plt.bar(x + 4 * bar_width, p[:, 4], bar_width, label='Interaction GB')
            plt.bar(x + 5 * bar_width, p[:, 5], bar_width, label='Interaction AB')
            plt.bar(x + 6 * bar_width, p[:, 6], bar_width, label='Interaction GAB')

            plt.xticks(x + 3 * bar_width, landmark_names, rotation=45)
            plt.xlabel('Landmark')
            plt.ylabel('p-value')
            plt.title(title_new)
            plt.axhline(y=0.05, color='r', linestyle='--')
            plt.legend(loc='upper right')
            plt.tight_layout()
            plt.savefig(f'ANCOVA_Analysis/ANCOVA_BMI_{title_str.replace(" ", "_")}.png')
            plt.close()


        return chosen_landmarks
