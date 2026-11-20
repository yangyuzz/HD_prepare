import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt
from scipy.stats import f_oneway

# load data file
df = pd.read_excel("..\데이터\오메가3 함량.xlsx")
sns.boxplot(x='type', y='mg', data=df, showmeans=True)
plt.show()

#describe statistics by group
group_describe = df.groupby(by='type').describe()
print(group_describe, '\n')

# one-way ANOVA
g1 = df[df['type']=='h1']['mg']
g2 = df[df['type']=='h2']['mg']
g3 = df[df['type']=='h3']['mg']
print(f_oneway(g1, g2, g3), '\n')

# Tukey's HSD test
from statsmodels.stats.multicomp import pairwise_tukeyhsd
tukey = pairwise_tukeyhsd(endog=df['mg'], groups=df['type'], alpha=0.05)
print(tukey)
