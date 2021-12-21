# I don't think this first part is necessary, but including just in case
# try running the other parts first and if you're having issues you
# may run this also
install.packages("extrafont")
library(extrafont)
font_import()
loadfonts(device="win")  
fonts()                      

# Set the font family we'll use to Calibri
windowsFonts(A = windowsFont("Calibri"))

# Update font family in base graphics
x = seq(1,10,1)
y = 1.5*x
plot(x, y,
     family="A",
     main = "title",
     font=2)

# Update font family in ggplot
library(ggplot2)
data(mtcars)
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point() +     
  ggtitle("Fuel Efficiency of 32 Cars") +
  xlab("Weight (x1000 lb)") + ylab("Miles per Gallon") +
  theme_bw() +
  theme(text=element_text(family="A", size=12))


# Theme updates
library("extrafont") # for Calibri font

theme_bw() +
  theme(
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(color = 'black'),
    text = element_text(family="Calibri"))

# Plots with facets
theme_bw() +
  theme(
    legend.position = "none",
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(color = 'black'),
    text = element_text(family="Calibri"),
    strip.background = element_blank())