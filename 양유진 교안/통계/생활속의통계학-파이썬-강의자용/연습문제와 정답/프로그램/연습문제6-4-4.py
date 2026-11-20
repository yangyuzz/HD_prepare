import pandas as pd
df = pd.DataFrame(pd.read_excel("..\데이터\영어성적 상관관계.xlsx"))

# 데이터프레임 컬럼명 변경
df.columns = ['grade_2nd', 'grade_3rd']
print(df.describe(), '\n')

import matplotlib.pyplot as plt
plt.scatter(df.grade_2nd, df.grade_3rd)    # 산점도
plt.xlabel("2dn grade")       # x축 레이블 
plt.ylabel("3rd grade")       # y축 레이블 
plt.grid()                       # 격자출력 
plt.show()                         

import scipy.stats as stats
# 피어슨 상관계수 검정
corr = stats.pearsonr(df.grade_2nd, df.grade_3rd)
print(corr)
