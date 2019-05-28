# load the packages we'll need
library(tidyverse)
library(lubridate)

# where is the data?
data_file <- "https://compcogscisydney.org/psyr/data/users.csv"

# read the data from the file
web <- data_file %>%
  read_csv() %>%
  mutate(Date = mdy(Date)) 

# construct the picture
pic <- web %>%
  ggplot(aes(x = Date, y = Users)) +
  geom_line() 

# draw the plot
pic %>% plot()
