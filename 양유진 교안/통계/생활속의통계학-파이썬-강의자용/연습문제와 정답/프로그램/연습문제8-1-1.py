import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as stats
from matplotlib.widgets import Slider

fig, ax  = plt.subplots()
fig.subplots_adjust(bottom=0.25)

mu = -3
sigma = 1
x = np.linspace(-8, 8, 100)
ax.plot(x, stats.norm.pdf(x, mu, sigma))

# slider 생성 
mu_value = plt.axes([0.25, 0.1, 0.65, 0.03], facecolor='black')
slider_value = Slider(mu_value, 'mu', -3, 3, valinit=-3, valstep=1)

def update(val):
    ax.axes.clear()
    ax.plot(x, stats.norm.pdf(x, val, sigma))   #val 값에 따라 정규분포 그림 
    
slider_value.on_changed(update)
plt.show()

plt.show()
