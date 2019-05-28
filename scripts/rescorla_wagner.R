### The Rescorla-Wagner learning rule implemented as an R function

update_RW <- function(value, alpha=.3, beta=.3, lambda=1) {
  value_compound <- sum(value)                    # value of the compound 
  prediction_error <- lambda - value_compound     # prediction error
  value_change <- alpha * beta * prediction_error # change in strength
  value <- value + value_change                   # update value
  return(value)
}

### Example 1: conditioning

n_trials <- 20                # 20 trials
strength <- numeric(n_trials) # vector off zeros

# present CS-US pairings and update
for(trial in 2:n_trials) {
  strength[trial] <- update_RW( strength[trial-1] )
}
print(strength)

# plot command
plot(
  strength, 
  xlab = "Trial Number",
  ylab = "Association",
  type = "b", 
  pch = 19
)


### Example 2: conditioning followed by extinction

n_trials <- 50    # 50 trials
strength <- numeric(n_trials) # vector of zeros
lambda <- .3      # max association for shock

for(trial in 2:n_trials) {
  
  # remove the shock after trial 25
  if(trial > 25) lambda <- 0
  
  # update associative strength on each trial
  strength[trial] <- update_RW(
    value = strength[trial-1],
    lambda = lambda
  )
}
print(strength)

# plot command
plot(strength, 
     xlab="Trial Number",
     ylab="Association",
     type="b",pch=19)



### Example 3: Blocking

n_trials <- 50

# vectors of zeros
strength_A <- numeric(n_trials)
strength_B <- numeric(n_trials)

# initially only A is present
alpha <- c(.3, 0)

for(trial in 2:n_trials) {
  
  # after trial 15, both stimuli are present
  if(trial > 15) alpha <- c(.3, .3)
  
  # current associative strengths
  v_old <- c(strength_A[trial-1], strength_B[trial-1])
  
  # update both
  v_new <- update_RW(
    value = v_old,
    alpha = alpha
  )
  
  # record the updated strengths
  strength_A[trial] <- v_new[1]
  strength_B[trial] <- v_new[2]
}


# more elaborate plotting commands!
plot(strength_A, 
     xlab="Trial Number",
     ylab="Association",
     type="b", pch=19, col="blue")

lines(
  x = 15:50,
  y = strength_B[15:50], 
  pch=19, 
  col="red",
  type="b"
)

abline(v = 15, lty = 3)

