import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt
from scipy.stats import f_oneway

# load data file
df = pd.read_excel("..\데이터\프린터 출력매수.xlsx")
sns.boxplot(x='type', y='page', data=df, showmeans=True)
plt.show()

group_describe = df.groupby(by='type').describe()
print(group_describe)

# one-way ANOVA
g1 = df[df['type']=='p1']['page']
g2 = df[df['type']=='p2']['page']
g3 = df[df['type']=='p3']['page']
g4 = df[df['type']=='p4']['page']
print(f_oneway(g1, g2, g3, g4), '\n')

# Tukey's HSD test
from statsmodels.stats.multicomp import pairwise_tukeyhsd
tukey = pairwise_tukeyhsd(endog=df['page'], groups=df['type'], alpha=0.05)
print(tukey)
