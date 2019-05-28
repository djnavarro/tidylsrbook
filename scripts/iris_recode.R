library(tidyverse)

tibble(
  sepal_length = iris$Sepal.Length,
  sepal_width = iris$Sepal.Width,
  petal_length = iris$Petal.Length,
  petal_width = iris$Petal.Width,
  context = 1, # a.k.a., bias, intercept, etc
  species_setosa = as.numeric(iris$Species == "setosa"),
  species_versicolor = as.numeric(iris$Species == "versicolor"),
  species_virginica = as.numeric(iris$Species == "virginica")
) %>% write_csv(path = here::here("data","iris_recode.csv"))


