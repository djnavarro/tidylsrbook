
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
learning_rate <- .01 # learning rate

# create a weight matrix with all weights set to 0
# plus a tiny amount of random noise to break symmetry
weight <- matrix(
  data = rnorm(n_weights) *.02,
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
    
    # feed forward expressed as matrix operation
    output <- (input %*% weight) %>% logit()
    
    # feedback: show the model the true "target" pattern
    target <- irises[stimulus_id, output_names]
    
    # error gradient at the output nodes
    prediction_error <- target - output
    
    # store the sum squared error for later
    sse[stimulus_id, epoch] <- sum(prediction_error^2)
    
    # matrix algebra form
    gradient <- input %*% (prediction_error * output * (1-output))
    weight <- weight + learning_rate * gradient
    
  }
}

# draw a very simple plot
plot(colSums(sse),type="b")



