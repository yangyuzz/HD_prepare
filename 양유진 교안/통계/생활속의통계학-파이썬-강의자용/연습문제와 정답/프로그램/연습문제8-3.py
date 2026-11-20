import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats
from matplotlib.animation import FuncAnimation
from matplotlib.widgets import Button

mu = 0
sigma = 1
x = np.linspace(-10, 10, 100)

fig, ax  = plt.subplots()
fig.subplots_adjust(bottom=0.15)
ax.plot(x, stats.norm.pdf(x, mu, sigma))
ax.set_title('sigma=1')


#일시정지 버튼 
pauseax = plt.axes([0.8, 0.025, 0.1, 0.04])
button_pause = Button(pauseax, 'Pause', color='gray')
def pause(event):
    animation.pause()
button_pause.on_clicked(pause)

#다시 재생버튼 
playax = plt.axes([0.6, 0.025, 0.1, 0.04])
button_play = Button(playax, 'Resume', color='gray')
def play(event):
    animation.resume()
button_play.on_clicked(play)

# 프레임에서 불러올 함수 
def update(frame):
    ax.axes.clear()
    ax.plot(x, stats.norm.pdf(x, mu, frame))   #val 값에 따라 정규분포 그림
    ax.set_title('sigma='+str(frame))

#애니메이션의 구성 
animation = FuncAnimation(fig, update, frames=np.arange(1, 7, 1), interval=800, repeat=True)
plt.show()
