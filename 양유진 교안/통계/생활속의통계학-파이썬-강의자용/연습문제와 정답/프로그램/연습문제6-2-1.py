import numpy as np 
import pandas as pd
from scipy import stats

data = pd.read_excel("..\데이터\파이썬 프로그래밍 성적.xlsx")
print(data.describe(), '\n')

from matplotlib import pyplot as plt
# 수평의 상자도형 (False의 F는 대문자로)
data.boxplot(column=["midterm", "final"], vert=False)
plt.show()

result=stats.ttest_rel(data.midterm, data.final, alternative='less')
print(result)
