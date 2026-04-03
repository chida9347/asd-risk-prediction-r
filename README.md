# Early Risk Indicator Prediction for Autism Spectrum Disorder (ASD)

## 📌 Project Overview

This project focuses on predicting **early risk indicators** of Autism Spectrum Disorder (ASD) using behavioral and demographic data.

⚠️ This is a **non-diagnostic system**.
It only estimates risk probability and should not be used for medical decisions.

---

## 🎯 Objective

To build an interpretable predictive system that:

* Uses behavioral screening responses
* Provides probability-based risk estimation
* Maintains ethical and non-diagnostic boundaries

---

## 📊 Dataset

* Source: Kaggle (Toddler Autism Dataset)
* Type: Behavioral + demographic data
* Features include:

  * A1–A10 (behavioral indicators)
  * Age (months)
  * Sex
  * Jaundice history
  * Family history of ASD

---

## 🧠 Models Used

### 1. Basic Model

* Logistic Regression
* Uses only demographic features
* Lower accuracy (~65–70%)
* More realistic

### 2. Advanced Model

* Logistic Regression with A1–A10
* Higher accuracy (~95–99%)
* Depends on behavioral screening inputs

---

## ⚙️ Technologies Used

* R Programming
* Shiny (for interface)
* GLM (Logistic Regression)

---

## 🖥️ Application Features

* User-friendly interface
* Model selection (Basic vs Advanced)
* Behavioral input support (A1–A10)
* Real-time risk prediction
* Ethical disclaimer included

---

## ⚠️ Ethical Considerations

* Autism is not a disease
* This tool is not a diagnostic system
* Predictions are probabilistic only
* Should not replace professional evaluation

---

## 📈 Results

| Model          | Accuracy |
| -------------- | -------- |
| Basic Model    | ~68%     |
| Advanced Model | ~99%     |

---

## 🚀 How to Run

1. Install required packages:

```r
install.packages("shiny")
```

2. Run the R script:

```r
shinyApp(ui = ui, server = server)
```

---

## 📌 Author

* 2nd Year CSE Student
* Project: Predictive Analysis using R

---

## 📎 Note

This project is developed for academic purposes and demonstrates the use of predictive modeling in healthcare analytics.
