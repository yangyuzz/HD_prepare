import numpy as np 
import pandas as pd
from scipy import stats

data = pd.read_excel("..\데이터\휴게실 만족도.xlsx")
print(data.describe())

from matplotlib import pyplot as plt
# 수평의 상자도형 (False의 F는 대문자로)
data.boxplot(column=["male", "female"], vert=False)
plt.show()

#이분산 가정 
result=stats.ttest_ind(data.male, data.female, equal_var='False', alternative='two-sided')
print(result)
