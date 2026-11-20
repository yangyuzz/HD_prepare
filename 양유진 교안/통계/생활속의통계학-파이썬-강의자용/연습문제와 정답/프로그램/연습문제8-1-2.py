import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as stats
from matplotlib.widgets import Slider

fig, ax  = plt.subplots()
fig.subplots_adjust(bottom=0.25)

mu = 0
sigma = 1
x = np.linspace(-15, 15, 100)
ax.plot(x, stats.norm.pdf(x, mu, sigma))

# slider 생성 
sigma_value = plt.axes([0.25, 0.1, 0.65, 0.03], facecolor='black')
slider_value = Slider(sigma_value, 'sigma', 1, 5, valinit=1, valstep=1)

def update(val):
    ax.axes.clear()
    ax.plot(x, stats.norm.pdf(x, mu, val))   #val 값에 따라 정규분포 그림 
    
slider_value.on_changed(update)
plt.show()

