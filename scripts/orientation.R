library(tidyverse)

# create an X11 window
X11(width = 8, height = 8, 
    xpos = 100, ypos = 30)

# clear the plotting area
clear_plot <- function() {
  plot.new()
  plot.window(xlim = c(0,1), ylim = c(0,1))
}

# use base graphics to draw the stimulus
draw_plot <- function(n_up,n_down) {
  
  # total number of arrows
  n <- n_up + n_down

  # set up the plotting area
  plot.new()
  plot.window(xlim = c(0,1), ylim = c(0,1))
  
  # draw the up pointing arrows
  x <- runif(n_up)
  y <- runif(n_up)
  lines(x,y,pch=24, type="p", bg = "black")
  
  # draw the down pointing arrows
  x <- runif(n_down)
  y <- runif(n_down)
  lines(x,y,pch=25, type="p", bg = "black")
}

# function to return the user keyboard response
response <- function(key) {
  
  # 6 = more up arrows 
  if(key == "6") {
    return("up")
  }
  
  # b = more down arrows
  if(key == "b") {
    return("down")
  }
  
  # anything else is invalid
  return(NA)
}

# create a sequence of trials
nu <- sample(rep(seq(20,80,2),2))
nd <- 100 - nu
ntrials <- length(nu)

# set up data storage
d <- tibble(
  trial = 1:ntrials,
  n_up = nu,
  n_down = nd,  
  response = numeric(ntrials),
  rt = numeric(ntrials)
)

# pause for 5 seconds at the beginning
Sys.sleep(5)

# loop over trials
for(i in 1:ntrials) {
  
  # start timing
  start <- Sys.time()
  
  # draw plot
  draw_plot(d$n_up[i], d$n_down[i])
  
  # wait for (then record) response
  d$response[i] <- getGraphicsEvent(
    prompt = "6 = up, b = down",
    consolePrompt = "",
    onKeybd = response
  )
  
  # record the response time
  d$rt[i] <- as.numeric(Sys.time() - start)
  
  # clear the plot
  clear_plot()
  
  # write to console for the audience :-)
  print(d[i,])
  
  # pause for 1 second between trials
  Sys.sleep(1)
  
}

# close the X11 window
dev.off()

# write the data
write_csv(d,path="./data/orientation.csv")
