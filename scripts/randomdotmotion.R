library(tidyverse)

# create an X11 window
X11(type = "Xlib")

# parameters for the experiment
npoints <- 40
ntrials <- 4


# use base graphics to draw the correlation
drawplot <- function() {
  
  # random points & sample correlation
  x <<- x + rnorm(npoints)/10
  y <<- y + rnorm(npoints)/10 + .01
  
  # draw the plot
  plot.new()
  plot.window(xlim=c(-4,4), ylim=c(-4,4))
  lines(x, y, pch=19, type="p")
  
}

# function to return the user keyboard response
response <- function(key) {
  
  # z = up/down 
  if(key == "z") {
    return("vertical")
  }
  
  # / = left/right 
  if(key == "/") {
    return("horizontal")
  }
  
  # anything else is invalid
  return(NA)
}


# set up data storage
d <- tibble(
  trial = numeric(ntrials),
  resp = character(ntrials),
  rt = numeric(ntrials))

# loop over trials
for(i in 1:ntrials) {
  
  x <- rnorm(npoints)
  y <- rnorm(npoints)
  
  # start timing
  start <- Sys.time()
  
  # wait for (then record) response
  d$resp[i] <- getGraphicsEvent(
    prompt = "z = VERTICAL, / = HORIZONTAL",
    consolePrompt = "",
    onIdle = drawplot,
    onKeybd = response
  )
  
  # record the response time
  d$rt[i] <- as.numeric(Sys.time() - start)
  
}

# close the X11 window
dev.off()

# print the data to console
print(d)
