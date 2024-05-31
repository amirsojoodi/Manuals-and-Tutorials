---
title: 'Reporting Prediction Errors'
date: 2024-05-30
permalink: /posts/Prediction-Error/
tags:
  - Math
  - Programming
  - Modeling
  - Python
--- 

There are several types of reporting errors in prediction. There is a whole research behind this topic, especially for the purpose of training the ML models. However, I put some of them that I usually use here.

Given that $f \rightarrow forcast$ and $y \rightarrow value$, we can calculate these errros:

1. Raw Error (RE)
   1. **$RE = f - y$**
2. Percentage Error (PE)
   1. **$PE = (f - y) / y$**
3. Symmetric Percentage Error (sPE)
   1. **$sPE = (f - y) / ((f + y) / 2)$**
4. Log Error (LE)
   1. **$LE = log(f) - log(y)$** or
   2. **$LE = log(f/y)$**

And some of the associated performance metrics are:

1. Mean Symmetric Error (MSE)
   1. $1/n \sum_{k=1}^n (f_k - y_k)^2$
2. Mean Absolute Percentage Error (MAPE)
   1. $1/n \sum_{k=1}^n |f_k - y_k| / y_k$
3. Symmetric Mean Absolute Percentage Error (sMAPE)
   1. $1/n \sum_{k=1}^n |f_k - y_k| / y_k$
4. Mean Absolute Log Error (MALE)
   1. $1/n \sum_{k=1}^n |log(f_k/y_k)|$
5. Root Mean Square Log Error (RMSLE)
   1. $\sqrt{1/n \sum_{k=1}^n |log(f_k/y_k)|^2}$
6. Exponential Mean Absolute MALE (EMALE)
   1. $\exp(1/n \sum_{k=1}^n |log(f_k/y_k)|)$
7. Exponential Root Mean Square Log Error (ERMSLE)
   1. $\exp(\sqrt{1/n \sum_{k=1}^n |log(f_k/y_k)|^2})$

### Python version

```python
# Given:
# f -> forecast
# y -> value

# RAW Error (RE)
RE = f - y

# Percentage Error (PE)
PE = (f - y) / y

# Symmetric Percentage Error (sPE)
sPE = (f - y) / ((f + y) / 2)

# Log Error (LE)
LE = log(f) - log(y) 
# or
LE = log(f/y)
# LE = log(1 + PE)
```

And the respective performance metrics of the model/prediction:

```python
# Mean Absolute Percentage Error
MAPE = mean(abs(PE))

# Symmetric Mean Absolute Percentage Error
sMAPE = mean(abs(sPE))

# Mean Absolute Log Error
MALE = mean(abs(LE))

# Root Mean Square Log Error
RMSLE = sqrt(mean(LE ** 2))

# Exponential Mean Absolute MALE
EMALE = exp(MALE)

# Exponential Root Mean Square Log Error
ERMSLE = expo(RMSLE)
```

There are tons of resources out there. If you want to see which one suits your usecase, take a look at [here](https://towardsdatascience.com/mean-absolute-log-error-male-a-better-relative-performance-metric-a8fd17bc5f75).
