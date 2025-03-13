library(ggplot2)

theme_point <-
  theme_bw() +
  theme(panel.background = element_rect(colour = "black", size=1),
        trip.background = element_rect(fill="lightgrey"),
        strip.text = element_text(size=16, colour="black"),
        axis.title.x = element_text(size = 14),  # Increase x-axis label size
        axis.title.y = element_text(size = 14),
        axis.text.x = element_text(size = 12),        # X-axis tick mark size
        axis.text.y = element_text(size = 12),# Increase y-axis label size
        legend.title = element_text(size = 14),   # Increase legend title size
        legend.text = element_text(size = 12)) 

theme_website <-  theme(
  # Set panel and plot background to dark gray
  panel.background = element_rect(fill = "#222222", color = NA), 
  plot.background = element_rect(fill = "#222222", color = NA), 
  # Add light grid lines
  panel.grid.major = element_line(color = "#495057"), 
  panel.grid.minor = element_line(color = "#495057"), 
  # Style axis lines and ticks
  axis.line = element_line(color = "white"),
  axis.ticks = element_line(color = "white"),
  # Style axis text and titles
  axis.text = element_text(color = "white"),
  axis.title = element_text(color = "white"), 
  legend.background = element_rect(fill = "#222222", color = NA), # Match plot background
  legend.key = element_rect(fill = "#222222", color = NA),       # Match legend key background
  legend.text = element_text(color = "white"),                  # White legend text
  legend.title = element_text(color = "white"))
  