import numpy as np 
import pandas as pd
from scipy import stats

data = pd.read_excel("..\데이터\주당 근로시간.xlsx")
print(data.describe())

from matplotlib import pyplot as plt
# 수평의 상자도형 (False의 F는 대문자로)
data.boxplot(column=["daejeon", "gwangju"], vert=False)
plt.show()

#등분산 가정 
result=stats.ttest_ind(data.daejeon, data.gwangju,equal_var='False',alternative='two-sided')
print(result)
