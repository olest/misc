# http://www.r-bloggers.com/bar-charts-with-percentage-labels-but-counts-on-the-y-axis/

library(ggplot2)
library(scales)

perbar=function(xx){
q=ggplot(data=data.frame(xx),aes(x=xx))+
geom_bar(aes(y = (..count..)),fill="orange")+
geom_text(aes(y = (..count..),label =   ifelse((..count..)==0,"",scales::percent((..count..)/sum(..count..)))), stat="bin",colour="darkgreen") 

q
}
