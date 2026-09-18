# Diabetes Risk Analysis

An R programme that analyses patient health data to compare how strongly lifestyle factors versus fixed biological factors predict diabetes risk.

---

## Project Overview

### Context

Diabetes is one of the most prevalent chronic conditions worldwide. Identifying which risk factors matter most can help prioritise prevention efforts. In this project, we analyse a synthetic dataset of patient health records, that cover demographics, biometrics, lifestyle habits, and existing conditions. 

We compare lifestyle factors (exercise, diet, sleep, smoking, alcohol consumption), the ones that can be changed, against biological factors (age, BMI, family history) to determine which group correlates more strongly with a patient's computed diabetes risk score. 

---

## Research Questions

1. **How strongly does each lifestyle and biological factor correlate with the diabetes risk score, individually?**

  We compute the Pearson correlation coefficient $r$ between each variable and `Diabetes_Risk_Score`, (add how to quantify uncertainty?)

2. **Do lifestyle factors, as a group, predict risk as strongly as biological factors, as a group as well?**

  We compare the average correlation across the lifestyle group against the biological group to determine which set of factors dominates. 

---

## Dataset and Input
- Source: Diabetes Risk Prediction Dataset - 
https://www.kaggle.com/datasets/srisyra02/diabetes-risk-prediction-dataset
- File used: `data/diabetes_risk_prediction_dataset.csv`

The dataset is a synthetic patient health record file in CSV format, containing approximately 50,000 rows and 39 columns. 

* **Demographic fields:** age, gender, country
* **Biometric fields:** height, weight, BMI, blood glucose, HbA1c, blood pressure, cholesterol, etc.
* **Lifestyle fields:** exercise_hours_per_week, diet_quality, sleep_hours, stress_level, smoking_status, alcohol_consumption
* **Outcome fields:** diabetes_risk_score, diabetes_risk (category)

---

## Usage

### Prerequisites

* R (version 4.6.1 or later)
* A terminal on macOS, Linux, or Windows

### Cloning the Repository

```bash
git clone https://github.com/ilannvw/Diabetes-Risk
```

### Install Dependencies

Install ...
```bash
install.packages(c("..."))
```

Place the dataset in the folder called `data`
```bash
mkdir -p data
```

### Run Main

```bash
Rscript "Main.r"
```

---

**Course:** Introduction to Programming (MAT2007) | Maastricht University
**Author:** Ilan Noè
**Date:** September, 2026