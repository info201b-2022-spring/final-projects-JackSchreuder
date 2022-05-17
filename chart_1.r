# This doc for the first chart
library(ggplot2)

ggplot(vis_by_region, aes(x=Region, y=total_vis)) + geom_bar(stat="identity")
