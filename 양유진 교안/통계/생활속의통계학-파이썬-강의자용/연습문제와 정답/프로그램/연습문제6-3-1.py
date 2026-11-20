import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt
from scipy.stats import f_oneway

# load data file
df = pd.read_excel("..\데이터\건전지 수명.xlsx")
sns.boxplot(x='group', y='life', data=df, showmeans=True)
plt.show()

#describe statistics by group
group_describe = df.groupby(by='group').describe()
print(group_describe, '\n')

# one-way ANOVA
g1 = df[df['group']=='L1']['life']
g2 = df[df['group']=='L2']['life']
g3 = df[df['group']=='L3']['life']
print(f_oneway(g1, g2, g3), '\n')

# Tukey's HSD test
from statsmodels.stats.multicomp import pairwise_tukeyhsd
tukey = pairwise_tukeyhsd(endog=df['life'], groups=df['group'], alpha=0.05)
print(tukey)
