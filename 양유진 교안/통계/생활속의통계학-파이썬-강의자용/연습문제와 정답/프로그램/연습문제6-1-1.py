import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats

data = pd.DataFrame(pd.read_excel("..\데이터\s기업 점심비용.xlsx"))
mu = 6300

# data에 대한 기솔통계량 출력 
print(data.describe())


plt.hist(data, label='Lunch Price', bins=7) #막대수를 7개
plt.legend()                              #범례를 그래프에 배치함  
plt.show()                               #히스토그램을 화면에 출력 


#만약 양측검정의 경우 (H1 : )
result = stats.ttest_1samp(data.lunch, mu, alternative='two-sided')
print(result)

'''
#[예제 1]과 같은 단측검정의 경우  (H1 : )
result = stats.ttest_1samp(data.coeffee, mu, alternative='greater')
print(result)
'''
