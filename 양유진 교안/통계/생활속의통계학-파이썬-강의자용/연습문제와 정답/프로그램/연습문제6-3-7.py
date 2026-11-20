import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from statsmodels.formula.api import ols
from statsmodels.stats.anova import anova_lm

# load data file
df = pd.read_excel("..\데이터\자동차 연비.xlsx")
df.columns = ['gas', 'additives', 'km']
sns.boxplot(x='gas', y='km', hue='additives', data=df)
plt.show()

#교호작용 그래프
from statsmodels.graphics.factorplots import interaction_plot
fig = interaction_plot(df.gas, df.additives, df.km)
plt.show()

model = ols('km ~ C(gas) + C(additives) + C(gas):C(additives)', data=df).fit()
print(anova_lm(model), '\n')

# Tukey's test
from statsmodels.stats.multicomp import pairwise_tukeyhsd
tukey = pairwise_tukeyhsd(endog=df['km'], groups=df['gas'], alpha=0.05)
print(tukey)
print()

tukey = pairwise_tukeyhsd(endog=df['km'], groups=df['additives'], alpha=0.05)
print(tukey)
