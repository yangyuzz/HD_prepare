import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.widgets import Slider

fig, ax  = plt.subplots()
fig.subplots_adjust(bottom=0.25)

n_sample =np.array([10, 50, 100, 500, 1000, 5000, 10000, 15000])
df=pd.DataFrame(pd.read_excel("..\데이터\고등학생_남자_키와 몸무게.xlsx"))
sf=df.sample(n=n_sample[0], replace=False)

ax.scatter(sf.height, sf.weight)
m, b = np.polyfit(sf.height, sf.weight, 1)
ax.plot(sf.height, m*sf.height+b, color='red', )
ax.set_title('# of samples :'+str(n_sample[0]))
ax.set_xlabel('height')
ax.set_ylabel('weight')


# slider 생성 
sample_val = plt.axes([0.25, 0.1, 0.65, 0.03], facecolor='black')
slider_value = Slider(sample_val, '# of samples', 0, 7, valinit=0, valstep=1)

def update(val):
    sf=df.sample(n=n_sample[val], replace=False)
    ax.axes.clear()
    ax.scatter(sf.height, sf.weight)
    m, b = np.polyfit(sf.height, sf.weight, 1)
    ax.plot(sf.height, m*sf.height+b, color='red',)
    ax.set_title('# of samples :'+str(n_sample[val]))
    ax.set_xlabel('height')
    ax.set_ylabel('weight')
   
slider_value.on_changed(update)
plt.show()





