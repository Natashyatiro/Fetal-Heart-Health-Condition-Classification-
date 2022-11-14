# Fetal Heart Health Condition Classification in R
*	Created a tool that classifies fetal heart health conditions (normal, suspicious, pathologic) based on cardiotocography data.
*	Optimized and compared e Logistic Regression for Multicategory Y, CART, and Random Forest in R to reach the best model.
* Random Forest performed best out of three with highest accuracy (99.6%) with both a low specificity and a low fall-out value. Not to mention, Random Forest in this study also outperformed models from previous research.

## Business Problem
Currently, the business problem that hospitals around the world are facing, including the National Heart Centre Singapore (NHCS), is regarding traditional medical diagnosis and monitoring for fetal heart health that are sometimes still inaccurate, costly, and time-consuming. This research will focus on developing and recommend an implementation plan of Machine Learning (ML) in tackling this issue.

## Approach Flowchart
![image](https://user-images.githubusercontent.com/84263856/201740360-dc5c3184-6975-4f75-8450-0a43bc3c81d6.png)

## Dataset Information
The data that is used for this project is fetal cardiotocography data. The data was provided in September 2010 by the Biomedical Engineering Institute and the Faculty of Medicine at the University of Porto, Portugal. These datasets were obtained on a regular basis in 1980 and again between 1995 and 1998, resulting in an ever-growing collection. The dataset contains 2126 fetal cardiotocography (CTG) specimens, which include fetal heartbeat and uterine contractions during pregnancy and labor. Three professional obstetricians classified the CTGs, and a consensus risk of heart disease classification label was issued to each of them. There are 2 types of classification done in the dataset which are the morphologic pattern and the fetal state (Normal, Suspect, Pathologic). The fetal state would be the primary focus of classification in this project.
Based on visualization, that the dataset is imbalanced, and is dominated by normal cases. Therefore, the SMOTE was employed to balance the data.

![image](https://user-images.githubusercontent.com/84263856/201739934-ab0ca0b4-d109-4c0f-a084-2a7ede5cf052.png)
![image](https://user-images.githubusercontent.com/84263856/201739948-efb0ca4d-488f-4ea5-af6a-6adf8d161c63.png)

## Result
Through the training and testing of Logistic Regression, CART and Random Forest, we can see that all three models have extremely great performance in classification accuracy. Random Forest shows a slightly better accuracy performance, which is 99.6%, and has both a low specificity (true negative rate) and a low fall-out (false positive rate). 
![image](https://user-images.githubusercontent.com/84263856/201740534-39767c35-e085-4cb8-a6a4-5a7d0587faf6.png)

Moreover, we can also find that Random Forest model is suitable for production. Given the test data, the model shows its competence in predicting fetal heart health conditions with adequate confidence. The accuracy of the model is so high that we do not have to collect more data, undertake more feature engineering, or experiment with other algorithms. Given the CTG indexes needed, the Random Forest model can provide us with a fast and accurate prediction of potential fetal heart disease.

## Implementation Plan
![image](https://user-images.githubusercontent.com/84263856/201740183-94eb23c9-846b-4bad-a950-f1c88705e119.png)

## Business Implications
![image](https://user-images.githubusercontent.com/84263856/201740223-4e5f7ecb-700c-4972-8606-45433d142739.png)

## Conclusion
For fetal heart health, CTG is useful for obstetricians to detect and monitor fetal heart condition. However, interpretation of the CTG data merely through visual analysis could result in misdiagnosis and financial burden. So, utilizing machine learning in interpreting CTG will have tremendous benefit in solving healthcare and business issues.
In this study, three machine learning models were developed and tested, which are Logistic Regression, CART and Random Forest. According to the results, Logistic Regression, CART and Random Forest based classifier could identify Normal, Suspicious and Pathologic condition, from the nature of CTG data with very high accuracy. Random Forest performed best out of three with highest accuracy (99.6%) with both a low specificity and a low fall-out value. Not to mention, Random Forest in this study also outperformed models from previous research.
