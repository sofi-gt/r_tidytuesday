#' ---
#' title: "#TidyTuesday - Bee Colonies"
#' author: "Sofia Garcia Salas"
#' date: "`r Sys.Date()`"
#' output:
#'   html_document:
#'     keep_md: true
#' ---

#+ echo=FALSE, message=FALSE, warning=FALSE
library(tidytuesdayR)
library(dplyr)
library(tidyr)
library(ggplot2)
library(geomtextpath)
theme_set(theme_minimal())

#' ## Load data
#+ message=FALSE, warning=FALSE
t_data <- tidytuesdayR::tt_load('2022-01-11')
colony <- t_data$colony
stressor <- t_data$stressor


#' ## View data structure
glimpse(colony)
glimpse(stressor)


#' ## Explore data
#' colonies by year and months

colony %>% 
  count(year, months)
#' the data is grouped by trimester

stressor %>% 
  count(year, months)

stressor %>% 
  count(stressor, sort = TRUE)

stressor %>% 
  count(state, sort = TRUE)
#' There is a United States total. Only some states have individual counts
#' others are counted as Other States
#' If we add the total of the states it should equal United States total 

colony %>% 
  filter(year == 2015) %>% 
  filter(state != "United States") %>% 
  count(state, wt = colony_n, sort = TRUE) #11681750

colony %>% 
  filter(year == 2015) %>% 
  filter(state != "United States") %>% 
  summarise(sum(colony_n))

# United States

us_colonies <- colony %>% 
  filter(state == "United States") %>% 
  group_by(year) %>% 
  summarise(
    #colonies = mean(colony_n, na.rm = TRUE),
    colonies_lost = mean(colony_lost, na.rm = TRUE),
    colonies_added = mean(colony_added, na.rm = TRUE)
  ) %>% 
  pivot_longer(cols = c(
    #colonies, 
    colonies_lost, 
    colonies_added))


us_colonies_2 <- colony %>% 
  filter(state == "United States") %>% 
  separate(col = months, into = c("first_month", "last_month"), sep = "-") %>% 
  mutate(date = lubridate::ym(paste(year, first_month))) %>% 
  select(date, colony_added, colony_lost) %>% 
  pivot_longer(cols = c(
    #colonies, 
    colony_lost, 
    colony_added))


colours_cafe <- c(
  "medium_blue" = "#5c93c4", #make this yellow
  "red" = "#a83e6c") #make this brown


ggplot(us_colonies, aes(x = year, y = value, color = name, label = name)) +
  geom_textline(size = 8, fontface = 2, hjust = 0.3, vjust=0.3, linewidth = 0.8) +
  scale_color_manual(values = c("#5c93c4", "#a83e6c")) +
  labs(
    x = "year",
    y = "colonies",
    title = "Average colonies added / lost per year"
  )+
  theme(
    plot.title = element_text(hjust = 0.5, size = 20),
    legend.position = "none"
)


ggplot(us_colonies_2, aes(x = date, y = value, color = name, label = name)) +
  geom_textpath(size = 6, fontface = 1.5, hjust = 0.3, vjust=0.3) 
  



us_colonies_3 <- colony %>% 
  filter(state == "United States") %>% 
  separate(col = months, into = c("first_month", "last_month"), sep = "-") %>% 
  mutate(date = lubridate::ym(paste(year, first_month))) %>% 
  select(date, colony_added, colony_lost) 


ggplot(us_colonies_3) +
  geom_smooth(aes(x = date, y = colony_added)) +
  geom_textsmooth(aes(x = date, y = colony_added), label = "added")
