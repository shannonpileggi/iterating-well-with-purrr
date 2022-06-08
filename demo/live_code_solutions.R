library(tidyverse)
library(purrr)
library(repurrrsive)


# ------------------------------------------------------------------------------
# What are the mistakes? -------------------------------------------------------
# ------------------------------------------------------------------------------
africa <- gapminder[gapminder$continent == "Africa", ]
africa_mm <- max(africa$lifeExp) - min(africa$lifeExp)

americas <- gapminder[gapminder$continent == "Americas", ]
americas_mm <- max(americas$lifeExp) - min(americas$lifeExp)

asia <- gapminder[gapminder$continent == "Asia", ]
# mistake - africa for asia
asia_mm <- max(asia$lifeExp) - min(africa$lifeExp)

europe <- gapminder[gapminder$continent == "Europe", ]
europe_mm <- max(europe$lifeExp) - min(europe$lifeExp)

oceania <- gapminder[gapminder$continent == "Oceania", ]
# mistake Europe for Oceania
oceania_mm <- max(europe$lifeExp) - min(oceania$lifeExp)


cbind(
  # names missing americas
  continent = c("Africa", "Asias", "Europe", "Oceania"),
  max_minus_min = c(africa_mm, americas_mm, asia_mm, europe_mm, oceania_mm)
)



# ------------------------------------------------------------------------------
# Examine data -----------------------------------------------------------------
# ------------------------------------------------------------------------------
help(package = "repurrrsive")
got_chars
sw_people

# ------------------------------------------------------------------------------
# Explore lists ----------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 1. How many elements are in `got_chars`? 

View(got_chars)

# shows entire list
str(got_chars)

# 30 sub lists / characters
length(got_chars)

# 18 elements in each character
str(got_chars[1])

# list.len shows maximum number of list elements to display within a level
str(got_chars, list.len = 1) 

# shows first two elements in each list
str(got_chars, list.len = 2)

# max.level specifies maximal level of nesting
str(got_chars, max.level = 1)



# ------------------------------------------------------------------------------
# 2. Who is the 9th person listed in `got_chars`? What information is given for this person?

# "Daenerys Targaryen"
got_chars[[9]]

# ------------------------------------------------------------------------------
# 3. What is the difference between `got_chars[9]` and `got_chars[[9]]`?

# returns a sub-list
got_chars[9]

# returns a contents in the list
got_chars[[9]]


# ------------------------------------------------------------------------------
# Mapping work flow ------------------------------------------------------------
# ------------------------------------------------------------------------------

# How many aliases does each GoT character have?

# ------------------------------------------------------------------------------
# 1. Do it for one element.

# "Daenerys Targaryen"
got_chars[[9]]

# Daenerys' aliases
got_chars[[9]][["aliases"]]

# Number of Daenerys' aliases
length(got_chars[[9]][["aliases"]])


# "Asha Greyjoy"
got_chars[[13]]

# Asha's aliases
got_chars[[13]][["aliases"]]

# Number of Asha's aliases
length(got_chars[[13]][["aliases"]])


# ------------------------------------------------------------------------------
# 2. Find the general recipe.
.x <- got_chars[[13]]
length(.x[["aliases"]])


# ------------------------------------------------------------------------------
# 3. Drop into map() to do for all.
map(got_chars, ~ length(.x[["aliases"]]))



# ------------------------------------------------------------------------------
# How many ___ does each character have? ---------------------------------------
# ------------------------------------------------------------------------------

map(got_chars, ~length(.x[["titles"]]))
map(got_chars, ~length(.x[["allegiances"]]))
map(sw_people, ~length(.x[["vehicles"]]))
map(sw_people, ~length(.x[["starships"]]))



# ------------------------------------------------------------------------------
# Replace map() with the type specific variant
# ------------------------------------------------------------------------------
# What's each character's name?
map_chr(got_chars, ~.x[["name"]])
map_chr(sw_people, ~.x[["name"]])

# What color is each SW character's hair?
map_chr(sw_people, ~ .x[["hair_color"]])

# Is the GoT character alive?
map_lgl(got_chars, ~ .x[["alive"]])

# Is the SW character female?
map_lgl(sw_people, ~ .x[["gender"]] == "female")

# How heavy is each SW character?
map_chr(sw_people, ~ .x[["mass"]])


# ------------------------------------------------------------------------------
# Explore and find a new element to look at
# ------------------------------------------------------------------------------
map_chr(got_chars, "culture")
map_chr(got_chars, 5)
map_chr(sw_people, "vehicles")


# errors examples 
map_chr(sw_people, "vehicles")
map_chr(sw_vehicles, "pilots")

map_chr(got_chars, "titles")
map_chr(got_chars, "allegiances")


# fixes
map(sw_vehicles, "pilots", .default = NA)
map_chr(sw_vehicles, list("pilots", 1), .default = NA)


map(got_chars, "allegiances")
map(got_chars, "allegiances", .default = NA)

# ------------------------------------------------------------------------------
# Named lists
# ------------------------------------------------------------------------------
# retrieve names of GoT characters
got_names <- map_chr(got_chars, "name")
got_names

# create a named list
got_chars_named <- set_names(got_chars, got_names)
str(got_chars_named, max.level = 1)
View(got_chars_named)

# create readable output
map_lgl(got_chars_named, "alive")

map(got_chars_named, "allegiances", .default = NA) |> 
  enframe() |> 
  unnest()


# ------------------------------------------------------------------------------
# Your turn
# ------------------------------------------------------------------------------
# Create a named copy of a GoT or SW list with set_names().
# Find an element with tricky presence/absence or length.
# Extract it many ways.

map(got_chars_named, "books")
which(names(got_chars_named[[1]]) == "books")
map(got_chars_named, 15)
map(got_chars_named, list("books", 1))
map_chr(got_chars_named, list("books", 1), .default = NA)


map(sw_vehicles, "pilots")
map(sw_vehicles, "pilots", .default = NA)
map(sw_vehicles, list("pilots", 1), .default = NA)
map_chr(sw_vehicles, list("pilots", 1), .default = NA)

# 1. Which SW film has the most characters? ------------------------------------
sw_films %>% 
  set_names(map_chr(sw_films, "title")) %>% 
  map("characters") %>% 
  map_int(length)


# 2. Which SW species has the most possible eye colors? ------------------------
sw_species %>% 
  set_names(map(sw_species, "name")) %>% 
  map("eye_colors") %>% 
  map(str_split, ", ") %>% 
  flatten() %>% 
  map_int(length) %>% 
  enframe(name = "species", value = "num_color") %>% 
  arrange(desc(num_color))


# 3. Which GoT character has the most allegiances? Aliases? Titles? ------------
got_chars %>%
  map("name") %>% 
  enframe(name = "position", value = "character") %>% 
  mutate(
    allegiances = map(got_chars, "allegiances", .default = NA_character_),
    num_allegiances = map_int(allegiances, length),
    titles = map(got_chars, "titles", .default = NA_character_),
    num_titles = map_int(titles, length),
    playedBy = map(got_chars, "playedBy", .default = NA_character_),
    num_playedBy = map_int(playedBy, length)
  ) 


# 4. Which GoT character has been played by multiple actors? -------------------
got_chars_named |> 
  map("playedBy") |> 
  map_int(length)


# ------------------------------------------------------------------------------
# doing the inverse
# ------------------------------------------------------------------------------

purrr::map_dfr(repurrrsive::got_chars,`[`, c("name", "gender", "culture"))

purrr::map(repurrrsive::got_chars,`[`, c("name", "gender", "culture"))

got_chars[[1]][["name"]]
got_chars[[1]][["gender"]]
got_chars[[1]][["culture"]]


# ------------------------------------------------------------------------------
# experiment with rowwise
# ------------------------------------------------------------------------------


dat <- got_chars_named |> 
  enframe() 

dat |> 
  rowwise() |> 
  mutate(
    num_allegiances = pluck(value, "allegiances") |> length()
  )

dat |> 
  mutate(
    num_allegiances = map_int(value, ~ length(pluck(.x, "allegiances")) )
  )
