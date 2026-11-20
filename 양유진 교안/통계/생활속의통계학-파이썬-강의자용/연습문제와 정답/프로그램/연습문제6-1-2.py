import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats

data = pd.read_csv("..\데이터\스마트폰_이용시간.csv")

mu = 35

# data에 대한 기솔통계량 출력 
print(data.describe())


plt.hist(data, label='Time spent on Smart Phone', bins=7) #막대수를 7개
plt.legend()                              #범례를 그래프에 배치함  
plt.show()                               #히스토그램을 화면에 출력 

# 양측검정의 경우 (H1 : )
result = stats.ttest_1samp(data, mu, alternative='two-sided')
print(result)

'''
#[예제 1]과 같은 단측검정의 경우  (H1 : )
result = stats.ttest_1samp(data, mu, alternative='greater')
print(result)
'''
