library(tidyverse)
library(purrr)
library(repurrrsive)

# ------------------------------------------------------------------------------
# Explore lists ----------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 1. How many elements are in `got_chars`? 

# shows entire list
str(got_chars)

# 30 sub lists / characters
length(got_chars)

# 18 elements in each character
str(got_chars[[1]])

# shows first element in each list
str(got_chars, list.len = 1) 

# shows first two elements in each list
str(got_chars, list.len = 2)

# shows first level of all characters
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

# ------------------------------------------------------------------------------
# 3. Drop into map() to do for all.

