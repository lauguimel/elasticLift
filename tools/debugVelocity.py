import numpy as np
import matplotlib.pyplot as plt
angles= np.linspace(0,2*np.pi,20)
x = np.cos(angles)
y = np.sin(angles)

omega=0.2

plt.plot(x,y,'o')
plt.axis('square')
# plt.quiver(x, y, -omega*np.sin(angles),omega*np.cos(angles))
plt.quiver(x, y, -omega*y,omega*x)
# plt.savefig('./debugVelocity.png')
plt.show()
plt.close()