library(tidytuesdayR)
library(tidyverse)
library(forcats)
library(tidytext)
library(here)
theme_set(theme_minimal())


tt <- tidytuesdayR::tt_load(x = "2020-08-18")


plants <- tt$plants %>% 
  drop_na(year_last_seen)

## View data structure
glimpse(plants)


## Extinct plants by continent
plants %>% 
  count(continent, sort = TRUE)

## Extinct plants by continent in aughts
plants %>% 
  filter(year_last_seen == "2000-2020") %>% 
  count(continent, sort = TRUE)



## Colors
colours_cafe <- c(
  "dark_blue" = "#384b60",
  "medium_blue" = "#5c93c4",
  "light_blue" = "#bedafa",
  "off_white" = "#f8f7f2",
  "red" = "#a83e6c")






year_levels <- c(years = "2000-2020", 
                 years ="1980-1999", 
                 years ="1960-1979", 
                 years = "1940-1959")

plants %>% 
  ggplot(aes(y = fct_rev(fct_infreq(continent)))) +
  geom_bar(aes(fill = stat(count)), show.legend = FALSE)  +
  scale_fill_gradient(
    low = colours_cafe["light_blue"], 
    high = colours_cafe["dark_blue"], 
    na.value = NA
    ) +
  facet_wrap(
    vars(fct_inorder(year_last_seen)), 
    scales = "free_y"
    ) +
  theme(plot.background = element_rect(fill = colours_cafe["off_white"])) +
  labs(
    title = "Number of extinct plants",
    x = NULL,
    y = "Continent"
    )


# https://juliasilge.com/blog/reorder-within/

## try it with geom_col
p <- plants %>% 
  filter(year_last_seen != "Before 1900") %>% 
  count(continent, year_last_seen, sort = TRUE) %>% 
  mutate(year_last_seen = as.factor(year_last_seen),
         continent = reorder_within(continent, n, year_last_seen)) %>% 
  ggplot(aes(x = n,
             y = continent,
             fill = n)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(vars(year_last_seen), scales = "free_y") +
  scale_y_reordered() +
  scale_fill_gradient(
    low = colours_cafe["light_blue"], 
    high = colours_cafe["dark_blue"], 
    na.value = NA) +
  labs(
    title = "Number of extinct plants by continent",
    x = NULL,
    y = "Continent",
    caption = "Data by IUCN | Color by @colours.cafe | Visualization by @sofigarciasalas"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.background = element_rect(fill = colours_cafe["off_white"]),
    strip.background = element_rect(
      fill="#efede1", 
      colour = "#efede1"),
    strip.text = element_text(colour = "black")
  )

ggsave(
  filename = here('img','week34_plants.png'),
  plot = p,
  dpi = 300
  ) 