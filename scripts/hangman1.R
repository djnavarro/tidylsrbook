library(stringr)
library(magrittr)

reg <- function(x){ 
  if(str_length(x)==0) {
    r <- fixed(" ")
  } else {
    r <- regex(paste0("[",x,"]"))
  }
  return(r)
}

show_hangman <- function(guesses, word, errors) {
  
  # what letters are they missing
  missing <- letters %>% str_flatten() %>% str_remove_all(reg(guesses))
  
  # what has the participant revealed
  stimulus <- word %>% str_replace_all(reg(missing),".")
  
  # how many errors?
  n_guess <- guesses %>% str_length()
  n_hit <- guesses %>% str_count(reg(word))
  n_err <- n_guess - n_hit
  
  # print the results:
  cat("\n\n")
  cat("what you know:\n\n")
  cat(stimulus,"\n\n")
  cat("your guesses:  ", guesses, "\n")
  cat("errors so far: ", n_err, "\n")
  cat("chances left:  ", errors-n_err, "\n\n")
  
}

prompt_user <- function(){
  guess <- readline("what letter would you like to guess next? ")
  return(guess)
}

clear_screen <- function(){
  cat("\f") # form feed character
}

game_state <- function(guesses, word, errors) {
  
  # first check to see if they've found all the letters...
  n_missing <- word %>% str_remove_all(reg(guesses)) %>% str_length()
  if(n_missing == 0) {
    return("win") 
  }
  
  # next check to see if they've run out of lives...
  n_guess <- guesses %>% str_length()
  n_hit <- guesses %>% str_count(reg(word))
  n_err <- n_guess - n_hit
  if(n_err >= errors) {
    return("lose")
  }
  
  # otherwise continue playing
  return("continuing")
}


hangman <- function(word, errors) {
  
  # initially no guesses
  guesses <- ""
  result <- "continuing"
  
  while(result == "continuing") {
    
    # clear screen, display state, wait for user
    clear_screen()
    show_hangman(guesses, word, errors)
    g <- prompt_user()
    
    # record the user behaviour
    guesses <- guesses %>% str_c(g)
    
    # check to see if we're still playing
    result <- game_state(guesses, word, errors)
  }
  
  # record everything
  dat <- c(word = word, guesses = guesses, errors = errors, result = result)
  
  # show the user where the game ended up
  clear_screen()
  show_hangman(guesses, word, errors)

  return(dat)
}

# play a game
d <- hangman("computational", 5)
print(d)
