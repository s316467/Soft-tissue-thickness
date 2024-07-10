import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

class ANCOVA:
    
    @staticmethod
    def analysis_ANCOVA(file_name, all_data, all_genders, all_ages, landmark_names, title_str):
        with open(file_name, 'w') as fileID:
            p = np.zeros((all_data.shape[0], 3))
            significant_landmark = np.zeros((all_data.shape[0], 3))
            F_Gender = np.zeros((all_data.shape[0], 1))
            F_Age = np.zeros((all_data.shape[0], 1))
            F_Interaction = np.zeros((all_data.shape[0], 1))
            choosen_landmarks = [None, None, None]

            if not os.path.exists('ANCOVA_Analysis'):
                os.makedirs('ANCOVA_Analysis')

            title_new = f'ANCOVA analysis with age and gender analysis-{title_str}'
            
            for i in range(all_data.shape[0]):
                X = pd.DataFrame({'Landmark': all_data[i, :], 'Gender': all_genders, 'Age': all_ages})
                model = LinearRegression().fit(X[['Gender', 'Age']], X['Landmark'])
                p[i, :] = model.pvalues[1:]
                F_Gender[i] = model.fvalues[1]
                F_Age[i] = model.fvalues[2]
                F_Interaction[i] = model.fvalues[3]

            for i in range(len(landmark_names)):
                significant_landmark[i, :] = (p[i, :3] < 0.05) & (F_Gender[i] > 1 | F_Age[i] > 1 | F_Interaction[i] > 1)

            significant_gender_indices = np.where(significant_landmark[:, 0] == 1)[0]
            significant_age_indices = np.where(significant_landmark[:, 1] == 1)[0]
            significant_interaction_indices = np.where(significant_landmark[:, 2] == 1)[0]

            fileID.write(f'ANCOVA results {title_str}\n')

            if len(significant_gender_indices) > 0:
                choosen_landmarks[0] = significant_gender_indices
                fileID.write('\nIt allows me to say that for the gender analysis, the most significant landmark are:\n')
                for i in significant_gender_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the gender analysis \n there are no significant landmark for classification by Gender\n')

            if len(significant_age_indices) > 0:
                choosen_landmarks[1] = significant_age_indices
                fileID.write('\nIt allows me to say that for the age analysis, the most significant landmark are:\n\n')
                for i in significant_age_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the age analysis\n there are no significant landmark for classification by Age\n\n')

            if len(significant_interaction_indices) > 0:
                choosen_landmarks[2] = significant_interaction_indices
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and gender, \n the most significant landmark are:\n\n')
                for i in significant_interaction_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and gender \n there are no significant landmark for classification by Age and Gender\n\n')

            plt.figure()
            plt.bar(np.arange(p.shape[0]), p)
            plt.xticks(np.arange(len(landmark_names)), landmark_names, rotation=45)
            plt.xlabel('Landmark')
            plt.ylabel('p-value')
            plt.title(title_new)
            plt.axhline(y=0.05, color='r', linestyle='--')
            plt.legend(['Gender', 'Age', 'Interaction'], loc='upper right')
            plt.savefig(f'ANCOVA_Analysis/ANCOVA_{title_str.replace(" ", "_")}.png')
            plt.close()

        return choosen_landmarks

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
        choosen_landmarks = [None] * 7
        title_new = f'ANCOVA analysis with BMI factor-{title_str}'

        with open(name_file, 'w') as fileID:
            fileID.write(f'ANCOVA analysis with BMI factor {title_str}\n')
            for i in range(all_data.shape[0]):
                X = pd.DataFrame({'Landmark': all_data[i, :], 'Gender': all_genders, 'Age': all_ages, 'BMI': all_bmi})
                model = LinearRegression().fit(X[['Gender', 'Age', 'BMI']], X['Landmark'])
                p[i, :] = model.pvalues[1:]
                F_Gender[i] = model.fvalues[1]
                F_Age[i] = model.fvalues[2]
                F_BMI[i] = model.fvalues[3]
                F_Interaction_GA[i] = model.fvalues[4]
                F_Interaction_GB[i] = model.fvalues[5]
                F_Interaction_AB[i] = model.fvalues[6]
                F_Interaction_GAB[i] = model.fvalues[7]

            for i in range(len(landmark_names)):
                significant_landmark[i, :] = (p[i, :7] < 0.05) & (F_Gender[i] > 1 | F_Age[i] > 1 | F_BMI[i] > 1 | F_Interaction_GA[i] > 1 | F_Interaction_GB[i] > 1 | F_Interaction_AB[i] > 1 | F_Interaction_GAB[i] > 1)

            significant_gender_indices = np.where(significant_landmark[:, 0] == 1)[0]
            significant_age_indices = np.where(significant_landmark[:, 1] == 1)[0]
            significant_bmi_indices = np.where(significant_landmark[:, 2] == 1)[0]
            significant_interactionGA_indices = np.where(significant_landmark[:, 3] == 1)[0]
            significant_interactionGB_indices = np.where(significant_landmark[:, 4] == 1)[0]
            significant_interactionAB_indices = np.where(significant_landmark[:, 5] == 1)[0]
            significant_interactionGAB_indices = np.where(significant_landmark[:, 6] == 1)[0]

            if len(significant_gender_indices) > 0:
                choosen_landmarks[0] = significant_gender_indices
                fileID.write('\nIt allows me to say that for the gender analysis, the most significant landmark are:\n')
                for i in significant_gender_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the gender analysis \n there are no significant landmark for classification by Gender\n')

            if len(significant_age_indices) > 0:
                choosen_landmarks[1] = significant_age_indices
                fileID.write('\nIt allows me to say that for the age analysis, the most significant landmark are:\n')
                for i in significant_age_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the age analysis\n there are no significant landmark for classification by Age\n\n')

            if len(significant_bmi_indices) > 0:
                choosen_landmarks[2] = significant_bmi_indices
                fileID.write('\nIt allows me to say that for the BMI analysis, the most significant landmark are:\n')
                for i in significant_bmi_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the BMI analysis\n there are no significant landmark for classification by BMI \n\n')

            if len(significant_interactionGA_indices) > 0:
                choosen_landmarks[3] = significant_interactionGA_indices
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and gender, \n the most significant landmark are:\n\n')
                for i in significant_interactionGA_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and gender \n there are no significant landmark for classification by Age and Gender\n\n')

            if len(significant_interactionGB_indices) > 0:
                choosen_landmarks[4] = significant_interactionGB_indices
                fileID.write('\nIt allows me to say that for the analysis of the interaction of gender and BMI, \n the most significant landmark are:\n\n')
                for i in significant_interactionGB_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the analysis of the interaction of gender and BMI \n there are no significant landmark for classification by Gender and BMI\n\n')

            if len(significant_interactionAB_indices) > 0:
                choosen_landmarks[5] = significant_interactionAB_indices
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and BMI, \n the most significant landmark are:\n\n')
                for i in significant_interactionAB_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the analysis of the interaction of age and BMI \n there are no significant landmark for classification by Age and BMI\n\n')

            if len(significant_interactionGAB_indices) > 0:
                choosen_landmarks[6] = significant_interactionGAB_indices
                fileID.write('\nIt allows me to say that for the analysis of the interaction of gender, age and BMI, \n the most significant landmark are:\n\n')
                for i in significant_interactionGAB_indices:
                    fileID.write(f'{landmark_names[i]}\n')
            else:
                fileID.write('\nIt allows me to say that for the analysis of the interaction of gender, age and BMI \n there are no significant landmark for classification by Gender, Age and BMI\n\n')

            plt.figure()
            plt.bar(np.arange(p.shape[0]), p)
            plt.xticks(np.arange(len(landmark_names)), landmark_names, rotation=45)
            plt.xlabel('Landmark')
            plt.ylabel('p-value')
            plt.title(title_new)
            plt.axhline(y=0.05, color='r', linestyle='--')
            plt.legend(['Gender', 'Age', 'BMI', 'Interaction GA', 'Interaction GB', 'Interaction AB', 'Interaction GAB'], loc='upper right')
            plt.savefig(f'ANCOVA_Analysis/ANCOVA_BMI_{title_str.replace(" ", "_")}.png')
            plt.close()

        return choosen_landmarks
