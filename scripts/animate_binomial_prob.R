library(tidyverse)
library(animation)

# clear the animation
ani.record(reset = TRUE)  

# range of outcomes
xmin <- 0
xmax <- 20

#  probabilities
prob_list <- c(
  seq(from = .67, to = .96, by = .01),
  seq(from = .96, to = .04, by = -.01), 
  seq(from = .04, to = .67, by = .01)
)

# draw frames...
for(prob in prob_list) {
  
  cat(".")
  
  # make data to plot
  df <- tibble(
    Value = xmin:xmax,
    Probability = dbinom(Value, size = xmax, prob = prob)
  ) 
  
  # construct the plot
  pic <- df %>% 
    ggplot(aes(x = Value, y = Probability)) + 
    geom_col(width=.5) +
    ggtitle(paste0("Success Probability = ", sprintf("%.2f", prob))) +
    theme_bw() +
    ylim(0, .5)
  
  plot(pic)     # draw the plot
  ani.record()  # record a frame
}

# set animation optiona
oopts <- ani.options(interval = 0.1)

# write GIF from the frames
saveGIF(
  expr = ani.replay(), 
  movie.name = here::here("output", "binomial_prob.gif"),
  img.name = "plot_temp", 
  clean = TRUE
)

# reset animation options
ani.options(oopts)

