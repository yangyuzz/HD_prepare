import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt
from scipy.stats import f_oneway

# load data file
df = pd.read_excel("..\데이터\수면 지속시간.xlsx")
sns.boxplot(x='pill', y='duration', data=df, showmeans=True)
plt.show()

group_describe = df.groupby(by='pill').describe()
print(group_describe)

# one-way ANOVA
g1 = df[df['pill']=='m1']['duration']
g2 = df[df['pill']=='m2']['duration']
g3 = df[df['pill']=='m3']['duration']
print(f_oneway(g1, g2, g3), '\n')

# Tukey's HSD test
from statsmodels.stats.multicomp import pairwise_tukeyhsd
tukey = pairwise_tukeyhsd(endog=df['duration'], groups=df['pill'], alpha=0.05)
print(tukey)
