#### Numeric

n_items <- 30
item_time <- 25
consent_time <- 120

new_survey_time <- (n_items * item_time) + consent_time

#### Character

new_survey_type <- "free response"

#### Logical

assigned_gender <- "female"
identified_gender <- "non-binary"
transgender <- assigned_gender == identified_gender

# an example that returns TRUE...
status <- "married" 
has_spouse <- (status == "married") | (status == "de facto")

# an example that returns FALSE...
status <- "widowed" 
has_spouse <- (status == "married") | (status == "de facto")
