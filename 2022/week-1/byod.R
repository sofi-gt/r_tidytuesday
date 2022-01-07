#' ---
#' title: "#TidyTuesday - Plants in Danger"
#' author: "Sofia Garcia Salas"
#' date: "´Sys.Date()´"
#' output:
#'   html_document:
#'     keep_md: true
#' ---

#+ echo=FALSE, message=FALSE, warning=FALSE
library(dplyr)
theme_set(theme_minimal())

#' ## Load data
#+ message=FALSE, warning=FALSE
tt <- tidytuesdayR::tt_load(x = "2020-08-18")
plants <- tt$plants %>% 
  drop_na(year_last_seen)