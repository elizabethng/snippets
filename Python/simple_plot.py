import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from palmerpenguins import load_penguins

penguins = load_penguins()

penguins.describe()
penguins.head()

plot1 = sns.scatterplot(x = "flipper_length_mm",
                   y = "body_mass_g",
                   hue = "species",
                   data = penguins)
plot1.set_xlabel("Flipper length (mm)")
plot1.set_ylabel("Body mass (g)")

plt.show(plot1)
plt.clf()
