library(vegan)
library(tidyverse)
library(ggrepel)
library(broom)
library(plotly)

#this.dir <- dirname(getActiveDocumentContext()$path)
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

OTU <- get(load("OTU.RData"))

dist <- OTU %>%
  column_to_rownames("sample")%>%
  avgdist(sample = 20000)

nmds_meta <- OTU %>% 
  select(sample)

set.seed(1)
nmds <- metaMDS(dist) %>%
  scores() %>%
  as_tibble(rownames="sample")

nmds_meta_num <- nmds %>%
  separate(sample, into = c("sample", "replicate"), sep = "_(?=[^_]+$)", remove = FALSE)



subsample <- OTU %>%
  pivot_longer(-sample)%>%
  group_by(name)%>%
  uncount(value)%>%
  slice_sample(n = 20000)%>%
  count(sample, name)%>%
  pivot_wider(names_from = "name", values_from = "n", values_fill = 0)%>%
  pivot_longer(-sample)

nmds_shared <- inner_join(subsample, nmds)

cor_x <- nmds_shared %>%
  nest(data = -name)%>%
  mutate(cor_x = purrr::map(data, ~cor.test(.x$value, .x$NMDS1, method = "spearman", exact = F) %>%   tidy()))%>%
  unnest(cor_x)%>%
  select(name, estimate, p.value)

cor_y <- nmds_shared %>%
  nest(data = -name)%>%
  mutate(cor_y = purrr::map(data, ~cor.test(.x$value, .x$NMDS2, method = "spearman", exact = F) %>%   tidy()))%>%
  unnest(cor_y)%>%
  select(name, estimate, p.value)

correlation <- inner_join(cor_x, cor_y, by = "name")

correlation %>%
  filter(p.value.x < 0.0000000000001 | p.value.y < 0.0000000000001)
high_corr <- correlation
high_corr <- correlation %>%
  filter(estimate.x > 0.78 | estimate.x < -0.92 | abs(estimate.y) > 0.85 )


### the plot 

centroid <- nmds_meta_num %>%
  group_by(sample) %>%
  summarize(NMDS1=mean(NMDS1), NMDS2=mean(NMDS2))

### figure 

fig <- plot_ly(nmds_meta_num, x = ~NMDS1, y = ~NMDS2, color = ~nmds_meta_num$sample, colors = c('#636EFA','#EF553B'), type = 'scatter', mode = 'markers')%>%
  layout(
    legend=list(title=list(text='color')),
    plot_bgcolor='#e5ecf6',
    xaxis = list(
      title = "0",
      zerolinecolor = "#ffff",
      zerolinewidth = 2,
      gridcolor='#ffff'),
    yaxis = list(
      title = "1",
      zerolinecolor = "#ffff",
      zerolinewidth = 2,
      gridcolor='#ffff'))
fig

library(plotly)

# Sample data
x <- c("A", "B", "C", "D", "E")
y1 <- c(10, 15, 7, 20, 12)  # Data for scatter plot
y2 <- c(5, 8, 13, 6, 10)    # Data for bar chart

# Create the plot
p <- plot_ly() %>%
  # Scatter plot (initially visible)
  add_trace(x = x, y = y1, type = 'scatter', mode = 'markers', name = 'Scatter', visible = TRUE) %>%
  # Bar chart (initially hidden)
  add_trace(x = x, y = y2, type = 'bar', name = 'Bar Chart', visible = FALSE) %>%
  layout(
    updatemenus = list(
      list(
        type = "buttons",
        direction = "right",
        buttons = list(
          list(method = "update", args = list(list(visible = c(TRUE, FALSE))), label = "Scatter Plot"),
          list(method = "update", args = list(list(visible = c(FALSE, TRUE))), label = "Bar Chart")
        ),
        x = 0.1, y = 1.2  # Position of the buttons
      )
    )
  )

p
