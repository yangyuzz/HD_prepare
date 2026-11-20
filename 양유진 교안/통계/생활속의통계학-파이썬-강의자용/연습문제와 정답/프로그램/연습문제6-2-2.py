import numpy as np 
import pandas as pd
from scipy import stats

data = pd.read_excel("..\데이터\배터리 지속시간.xlsx")
print(data.describe())

from matplotlib import pyplot as plt
# 수평의 상자도형 (False의 F는 대문자로)
data.boxplot(column=["china", "korea"], vert=False)
plt.show()

d1 = pd.read_excel("..\데이터\배터리 지속시간_china.xlsx")
d2 = pd.read_excel("..\데이터\배터리 지속시간_korea.xlsx")
result=stats.ttest_ind(d1.china, d2.korea, equal_var='False', alternative='two-sided')
print(result)
