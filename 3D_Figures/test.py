<<<<<<< HEAD
import control as ct
import matplotlib.pyplot as plt
import numpy as np

# 1. Define the transfer functions
# G1(s) = 1 / (s + 1)
num1 = [1]
den1 = [1, 1]
sys1 = ct.tf(num1, den1)

# G2(s) = 20 / (s (s + 1) (s + 2)) = 20 / (s^3 + 3 s^2 + 2 s)
num2 = [20]
den2 = [1, 3, 2, 0]  # coefficients for s^3 + 3 s^2 + 2 s + 0
sys2 = ct.tf(num2, den2)

# 2. Define a frequency range (from low to high frequency, log spaced)
omega = np.logspace(-2, 2, 1000)  # Frequencies from 0.01 to 100 rad/s

# 3. Calculate the frequency responses
# frequency_response returns magnitude and phase (in radians)
mag1, phase1, omega = ct.frequency_response(sys1, omega)
mag2, phase2, omega = ct.frequency_response(sys2, omega)

# Ensure arrays are 1-D for plotting
mag1 = np.squeeze(mag1)
phase1 = np.squeeze(phase1)
mag2 = np.squeeze(mag2)
phase2 = np.squeeze(phase2)

# 4. Create the polar plot and plot both responses
fig, ax = plt.subplots(figsize=(6, 6), subplot_kw={'projection': 'polar'})

# Plot the phase (theta) vs magnitude (r) for both systems
ax.plot(phase1, mag1, color='blue', label='G1(s)=1/(s+1)')
ax.plot(phase2, mag2, color='red', label='G2(s)=20/(s(s+1)(s+2))')

# Optional: Customize the plot
ax.set_title("Polar Plot: G1(s)=1/(s+1) and G2(s)=20/(s(s+1)(s+2))")
ax.grid(True)
ax.legend(loc='upper right')

# Display the plot
plt.show()
=======
import control as ct
import matplotlib.pyplot as plt
import numpy as np

# 1. Define the transfer functions
# G1(s) = 1 / (s + 1)
num1 = [1]
den1 = [1, 1]
sys1 = ct.tf(num1, den1)

# G2(s) = 20 / (s (s + 1) (s + 2)) = 20 / (s^3 + 3 s^2 + 2 s)
num2 = [20]
den2 = [1, 3, 2, 0]  # coefficients for s^3 + 3 s^2 + 2 s + 0
sys2 = ct.tf(num2, den2)

# 2. Define a frequency range (from low to high frequency, log spaced)
omega = np.logspace(-2, 2, 1000)  # Frequencies from 0.01 to 100 rad/s

# 3. Calculate the frequency responses
# frequency_response returns magnitude and phase (in radians)
mag1, phase1, omega = ct.frequency_response(sys1, omega)
mag2, phase2, omega = ct.frequency_response(sys2, omega)

# Ensure arrays are 1-D for plotting
mag1 = np.squeeze(mag1)
phase1 = np.squeeze(phase1)
mag2 = np.squeeze(mag2)
phase2 = np.squeeze(phase2)

# 4. Create the polar plot and plot both responses
fig, ax = plt.subplots(figsize=(6, 6), subplot_kw={'projection': 'polar'})

# Plot the phase (theta) vs magnitude (r) for both systems
ax.plot(phase1, mag1, color='blue', label='G1(s)=1/(s+1)')
ax.plot(phase2, mag2, color='red', label='G2(s)=20/(s(s+1)(s+2))')

# Optional: Customize the plot
ax.set_title("Polar Plot: G1(s)=1/(s+1) and G2(s)=20/(s(s+1)(s+2))")
ax.grid(True)
ax.legend(loc='upper right')

# Display the plot
plt.show()
>>>>>>> d3d4ea904ee47029e560e8790c309a9e88b504e2
