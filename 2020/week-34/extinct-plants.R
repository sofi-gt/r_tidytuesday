#' ---
#' title: "#TidyTuesday - Plants in Danger"
#' author: "Sofia Garcia Salas"
#' output:
#'   html_document:
#'     keep_md: true
#' ---

#+ echo=FALSE, message=FALSE, warning=FALSE
library(tidytuesdayR)
library(tidyverse)
library(forcats)
library(tidytext)
library(here)
theme_set(theme_minimal())

#' ## Load data
#+ message=FALSE, warning=FALSE
tt <- tidytuesdayR::tt_load(x = "2020-08-18")
plants <- tt$plants %>% 
  drop_na(year_last_seen)

#' ## View data structure
glimpse(plants)


#' ## Explore data
#' Extinct plants by continent
plants %>% 
  count(continent, sort = TRUE)

#' ## Generate plot
#' Colors from @colours_cafe instagram
colours_cafe <- c(
  "dark_blue" = "#384b60",
  "medium_blue" = "#5c93c4",
  "light_blue" = "#bedafa",
  "off_white" = "#f8f7f2",
  "red" = "#a83e6c")

#' ### Plant extinction through the years
#' Used Julia Silge blog post to learn how to order plot within facets
#' https://juliasilge.com/blog/reorder-within/

#+ echo=TRUE
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
    title = "Number of extinct plants by continent through the years",
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


#+ echo=FALSE
p 


#+ echo=FALSE, message=FALSE, warning=FALSE
ggsave(
  filename = here::here('2020', 'week-34', 'plants.png'),
  plot = p,
  dpi = 300
  ) 