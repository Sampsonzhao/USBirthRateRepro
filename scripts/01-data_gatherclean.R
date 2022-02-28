### Preamble ###
# purpose: clean data from downloaded data from openICPSR
# Author: Sampson Zhao
# Contact: sampson.zhao@mail.utoronto.ca
# Date: 2022-02-27
# Pre-requisites: 
# - None

#### Workspace setup ####
library(tidyverse)
library(here)
library(reshape2)
library(lubridate)

# Because this data was retrieved from openICPSR and some of the data is 
# restricted access from the original source, the data set files were downloaded
# and stored in /input/data/ instead of retrieved.

total_pop <- read_csv(file = here::here('inputs/data/fig_1.csv'))

split_age <- read_csv(file = here::here('inputs/data/figs_2a_2b.csv'))

cost <- read_csv(file = here::here('inputs/data/APU0000701111.csv'))

race_decrease <- read_csv(file = here::here('inputs/data/table_1.csv'))

split_race <-
  split_age|>
  select(year,
         brate_blacknh,
         brate_whitenh,
         brate_hisp) |>
  slice(-1:-9)

split_age <-
  split_age |>
  select(-brate_blacknh,
         -brate_whitenh,
         -brate_hisp)

split_age <-
  melt(split_age, id.vars = 'year')

split_race <-
  melt(split_race, id.vars = 'year')

cost$year <- floor_date(cost$observation_date, "year")

cost$APU0000701111 <- as.numeric(cost$APU0000701111)

average_cost<-
  cost|>
  group_by(year)|>
  summarize(mean = mean(APU0000701111, na.rm=TRUE))

total_pop <- write_csv(total_pop, file = here::here('inputs/data/total_pop.csv'))
split_race <- write_csv(split_race, file = here::here('inputs/data/split_race.csv'))
split_age <- write_csv(split_age, file = here::here('inputs/data/split_age.csv'))
average_cost <- write_csv(average_cost, file = here::here('inputs/data/average_cost.csv'))


#split_age |>
#ggplot(mapping = aes(x = year, y= value, colour= variable)) +
# geom_line(size = 1)+
# labs(title = 'Birth Rate By Age Ranges from 1980 to 2020', x = 'Year', y = 'Birth Rate per 1000 people') +
# guides(colour = guide_legend(title = "Age Range")) +
# scale_colour_discrete(labels = c("15-19",'20-24','25-29','30-34','35-39','40-44'))+
# geom_vline(xintercept=2007, linetype=4, colour="black")
