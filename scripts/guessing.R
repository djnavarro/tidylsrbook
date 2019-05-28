# An interactive game at the console

# A sneaky trick: RStudio recognises the "form feed" character
# as a cue to clear all the text in the console. If we send it
# to the console using "cat" it functions as a way of clearing
# the screen. Define a "clearscreen" function...
clearscreen <- function(){
  cat("\f") # form feed character: "\014"
}

# clear the screen
clearscreen()

# initialise the data as an empty data frame 
dataset <- data.frame(
  trial = numeric(0),
  upper = numeric(0),
  lower = numeric(0),
  query = numeric(0),
  response = character(0)
)

# initialise the state of the experiment
low <- 1   # lowest possible number
up <- 100  # highest possible number
rng <- up-low # possible uncertainty?
trial <- 1

# keep guessing until the answer is known
while( rng > 1 ) {
  
  # sample a query item
  que <- sample(low:up,1)
  
  # ask the question until the user responds with "y" or "n"
  cat("\n\n\n\n\n")
  resp <- ""
  while( !(resp %in% c("y","n"))) {
    prompt <- paste0("Is it higher than ", que, "? [y/n]  ")
    resp <- readline(prompt)
    resp <- tolower(resp)
  }
  
  # record the data
  dataset <- rbind(
    dataset, 
    data.frame(
      trial=trial,
      upper=up,
      lower=low,
      query=que,
      response=resp
    )
  )
  
  # use the user response to update the bounds
  if(resp == "y") {
    low <- que
  } else{ 
    up <- que
  }
  
  # update the rest of the state accordingly
  rng <- up-low
  trial <- trial + 1
  
  # clear the screen in readiness for the next trial
  clearscreen()
  
}

# end the experiment
cat("Done!\n\n")
print(dataset)