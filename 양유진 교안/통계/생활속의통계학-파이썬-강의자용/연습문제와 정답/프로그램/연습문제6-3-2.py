import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt
from scipy.stats import f_oneway

# load data file
df = pd.read_excel("..\데이터\식이요법 체중감량.xlsx")
sns.boxplot(x='group', y='weight', data=df, showmeans=True)
plt.show()

#describe statistics by group
group_describe = df.groupby(by='group').describe()
print(group_describe, '\n')

# one-way ANOVA
g1 = df[df['group']=='A']['weight']
g2 = df[df['group']=='B']['weight']
g3 = df[df['group']=='C']['weight']
print(f_oneway(g1, g2, g3), '\n')

# Tukey's HSD test
from statsmodels.stats.multicomp import pairwise_tukeyhsd
tukey = pairwise_tukeyhsd(endog=df['weight'], groups=df['group'], alpha=0.05)
print(tukey)
