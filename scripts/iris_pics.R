
library(tidyverse)
tidy_weights <- here::here("output","iris_weights.csv") %>%
  read_csv()


# 
# pic1 <- tidy_sse %>%
#   ggplot(aes(x = block, y = sse, group = item, colour = item)) +
#   facet_wrap(~species) + 
#   geom_point()
# 
# plot(pic1)

# 
# pic2 <- tidy_sse %>%
#   #  filter()
#   ggplot(aes(x = item, y = sse, 
#              group = item, colour = block)) +
#   facet_wrap(~species, scales = "free_x") + 
#   geom_point(show.legend = FALSE)
# plot(pic2)
# 
# 
# pic3 <- tidy_sse %>%
#   filter(block == 1) %>%
#   ggplot(aes(x = sse, colour = species, fill = species)) +
#   geom_dotplot(binwidth = .05, stackgroups = TRUE, binpositions = "all") + 
#   xlim(0,1) + ylim(0,10)
# plot(pic3)

pic4 <- tidy_weights %>% 
  ggplot(aes(x = epoch, y = strength, colour = feature)) +
  facet_wrap(~species) +
  geom_line()
plot(pic4)

