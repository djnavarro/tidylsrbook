
# packages
library(magrittr)
library(readr)
library(dplyr)
library(ggplot2)
library(purrr)
library(tibble)
library(readr)
library(tidyr)
library(stringr)

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
n_epochs <- 5000 # number of training epochs
n_sims <- 100 # number of simulations
learning_rate <- .01 # learning rate

# create an array that keeps track of the weight matrix across
# every epoch
all_weight <- array(
  data = 0, dim = c(n_input, n_output, n_epochs + 1),
  dimnames = list(input_names, output_names, paste0("epoch_", 0:n_epochs))
)

# create a matrix that keeps track of the sum squared prediction
# error at the end of every trial, across every epoch
sse <- matrix(0, n_cases, n_epochs)

# 
for(its in 1:n_sims){ 
  
  cat(" ", its, " ")
  
  
  # create a weight matrix with all weights set to 0
  # plus a tiny amount of random noise to break symmetry
  weight <- matrix(
    data = rnorm(n_weights) *.01,
    nrow = n_input,
    ncol = n_output,
    dimnames = list(input_names, output_names)
  )
  
  # store
  all_weight[,,1] <- all_weight[,,1] + weight
  
  
  for(epoch in 1:n_epochs){
    
    if(epoch %% 100 == 0) cat(".")
    
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
      sse[stimulus_id, epoch] <- sse[stimulus_id, epoch] + sum(prediction_error^2)
      
      # matrix algebra form
      gradient <- input %*% (prediction_error * output * (1-output))
      weight <- weight + learning_rate * gradient
      
    }
    
    # store the weights for later
    all_weight[,,epoch+1] <- all_weight[,,epoch+1] + weight
    
  }
}

# normalise
all_weight <- all_weight / n_sims
sse <- sse / n_sims

# create a tidy version of the SSE 
colnames(sse) <- paste0("epoch_",1:n_epochs)
tidy_sse <- sse %>% 
  as.tibble() %>%
  mutate(
    item = 1:n_cases,
    species = iris$Species
  ) %>%
  gather(key = "epoch", value = "sse", 1:n_epochs) %>%
  mutate(
    block = epoch %>% str_remove("epoch_") %>% as.numeric()
  )

# tidy weights
tidy_weights <- all_weight %>% apply(MARGIN = 3, FUN = function(weight) {
  weight %>% as.tibble() %>%
    mutate(feature = input_names) %>%
    gather(key = "species", value = "strength", 
           species_setosa, species_versicolor, species_virginica)
}) %>% reduce2(
  .y = 1:n_epochs, 
  .f = function(old,new,epoch) {
    new$epoch <- epoch
    bind_rows(old,new)
  })

tidy_weights$species <- tidy_weights$species %>% 
  str_remove("species_")
tidy_weights$epoch[is.na(tidy_weights$epoch)] <- 0

# save data
#write_csv(tidy_sse, here::here("output","iris_sse.csv"))
#write_csv(tidy_weights, here::here("output","iris_weights.csv"))


