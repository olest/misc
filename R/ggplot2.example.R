library("ggplot2")

# scatterplot
qplot(displ,hwy,data=mpg)
# with colors
qplot(displ,hwy,data=mpg,color=drv)
# histogram
qplot(hwy,data=mpg,fil=drv)
# facets
qplot(displ,hwy,data=mpg,facets=.~drv)
