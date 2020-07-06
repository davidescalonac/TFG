# TFG
Bachelor thesis code for inhospital mortality prediction of ICU patients from the MIMIC-III dataset.

Patient Cohort
  - adults_first_admission_v2.sql: gets the basic information of the first hospital admission for adult patients [15, 90].
  - last_icustay.sql: gets the icustay_id of the last icustay from the first admission for adult patients.
  
Data preprocessing
  - EDA.ipynb: plots the histogram of all the variables of SOFA, SAPS, SAPS-II and OASIS.
  - data_preparation.ipynb: performs the preprocessing techniques on the data.
  
Model implementation
  - gird_search.ipynb: performs grid search algorithm to find the optimal hyperparameters
  - final_model.ipynb: implementation and evaluation of the project's final model
