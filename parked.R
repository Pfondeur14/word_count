file_list <- list.files(path = "./lyrics", full.names = TRUE)

menu = c()
for (file in file_list){
  each_file <- sub("./lyrics/", "", file)
  menu <- c(menu, each_file)
}

options_menu <- paste0(1:length(menu), ". ", menu)
cat(options_menu, sep = "\n")

select <- as.integer(readline("Enter a menu number: "))
path <- paste0("./lyrics/", menu[select])

library(tidyverse)
data <- read_file(path) #"./lyrics/swift.txt"

# Eliminate stylistic inconsistencies between words that are otherwise
#the same—such as capitalization or the presence of punctuation.
data <- data |>
  str_split_1("\\s+") |>
  str_to_lower() |>
  str_replace_all("[[:punct:]]", "")


# Convert the vector of words into a data frame
data <- tibble(word = data)

# Transform df to include a count column for each unique word and filter
#out words that don' appear more than once.
data_df <- data |>
  group_by(word) |>
  summarize(count = n()) |>
  arrange(desc(count)) |>
  filter(count > 1)

# With a data frame of words and their frequency, use the ggplot function
#to plot the lyrics
p <- ggplot(data_df, aes(x = reorder(word, count, FUN = desc), y = count)) +
  geom_col(
    aes(fill = word),
    show.legend = FALSE
  ) +
  scale_fill_viridis_d() +
  labs(
    x = "Words",
    y = "Count",
  ) +
  guides(x = guide_axis(angle = 90))

#file_png <- sub(".txt", ".png", menu[select])

ggsave(
  "lyrics.png",
  plot = p,
  width = 2700,
  height = 1800,
  units ="px"
)