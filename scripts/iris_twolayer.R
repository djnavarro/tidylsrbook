
# packages
library(magrittr)
library(readr)
library(dplyr)

# read the irises data as a numeric matrix
iris_file <- here::here("data", "iris_recode.csv")
irises <- iris_file %>% read_csv() %>% as.matrix()

# specify which features are inputs & targets
input_names <- c("sepal_length", "sepal_width", "petal_length", "petal_width", "context")
output_names <- c("species_setosa", "species_versicolor", "species_virginica")

# the logit squashing function
logit <- function(x){
  y <- 1/(1 + exp(-x))
  return(y)
}

# count the number of inputs, target, cases & weights
n_input <- length(input_names)
n_output <- length(output_names)
n_cases <- dim(irises)[1]
n_weights <- n_input * n_output

# parameters
n_epochs <- 100 # number of training epochs
learning_rate <- .1 # learning rate

# create a weight matrix with all weights set to 0
# plus a tiny amount of random noise to break symmetry
weight <- matrix(
  data = rnorm(n_weights) *.01,
  nrow = n_input,
  ncol = n_output,
  dimnames = list(input_names, output_names)
)

# create a matrix that keeps track of the sum squared prediction
# error at the end of every trial, across every epoch
sse <- matrix(NA, n_cases, n_epochs)

for(epoch in 1:n_epochs){
  
  # to prevent weirdness, shuffle the order of trials 
  # at the start of each epoch
  trial_order <- sample(1:n_cases)
  
  for(case in 1:n_cases) {
    
    # which stimulus is this?
    stimulus_id <- trial_order[case]
    
    # send the iris features to the input nodes
    input <- irises[stimulus_id, input_names]
    
    # initialise the output nodes at zero
    output <- rep(0, n_output)
    
    # feed forward to every output node by taking a weighted sum of
    # the inputs and passing it through a logit function
    for(o in 1:n_output) {
      output[o] <- sum(input * weight[,o]) %>% logit() 
    }
    
    # feedback: show the model the true "target" pattern
    target <- irises[stimulus_id, output_names]

    # error gradient at the output nodes: this is Equation 4 from 
    # Rumelhart et al (1986) multiplied by -1. Notice that this is
    # the same prediction error signal in the Rescorla-Wagner model:
    # lambda == target, V == output
    prediction_error <- target - output
    
    # store the sum squared error for later
    sse[stimulus_id, epoch] <- sum(prediction_error^2)
    
    # for each of the weights connecting to an output node...
    for(o in 1:n_output) {
      for(i in 1:n_input) {
      
        # associative learning for this weight scales in a manner that depends on
        # both the input value and output value. this is similar to the way that
        # Rescorla-Wagner has CS scaling (alpha) and US scaling (beta) parameters
        # but the specifics are slightly different (Equation 5 & 6 in the paper)
        scale_io <- input[i] * output[o] * (1-output[o]) 
        
        # adjust the weights proportional to the error and the scaling (Equation 8)
        weight[i,o] <- weight[i,o] + (prediction_error[o] * scale_io * learning_rate)
        
      }
    }
    
  }
}


plot(colSums(sse),type="b")


