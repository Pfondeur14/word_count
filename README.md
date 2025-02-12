<h1>Lyrics Word Frequency Visualization</h1>

<h3>Overview</h3>

This R script processes the lyrics (lyrics are used as an example) from text files located in the ./lyrics directory and visualizes the frequency of words that appear more than once. The program allows you to choose a file from the list, cleans and processes the text data, and generates a bar plot of word frequency. The resulting plot is saved as a PNG file (lyrics.png).
Functionality

<h3>File Selection:</h3>

The script reads all the .txt files from the ./lyrics directory and presents them in a numbered menu.
You select the file from the menu by entering the corresponding number.

<h3>Requirements</h3>

This script requires the following R libraries:

<p>tidyverse (for data manipulation and visualization with ggplot2).</p>
<pre>
  <code>
    library(tidyverse)
  </code>
</pre>

<h3>Script Breakdown</h3>


1. File Selection

This section collects all files in the ./lyrics directory and creates a menu list for the user to choose from.
<pre>
  <code>
    file_list <- list.files(path = "./lyrics", full.names = TRUE)
    menu = c()
    for (file in file_list){
      each_file <- sub("./lyrics/", "", file)
      menu <- c(menu, each_file)
    }
  </code>
</pre>

The file options are printed with numbers for easy selection.
<pre>
  <code>
    options_menu <- paste0(1:length(menu), ". ", menu)
    cat(options_menu, sep = "\n")
  </code>
</pre>

The user is prompted to enter a menu number corresponding to their chosen file.
<pre>
  <code>
    select <- as.integer(readline("Enter a menu number: "))
    path <- paste0("./lyrics/", menu[select])
  </code>
</pre>


2. Data Processing

The selected lyrics file is read into a string variable.
<pre>
  <code>
    data <- read_file(path)
  </code>
</pre>

The lyrics are split into individual words, converted to lowercase, and stripped of punctuation.
<pre>
  <code>
    data <- data |>
    str_split_1("\\s+") |>
    str_to_lower() |>
    str_replace_all("[[:punct:]]", "")
  </code>
</pre>


3. Word Frequency Calculation

The data is converted into a tibble (data frame) of words.
<pre>
  <code>
    data <- tibble(word = data)
  </code>
</pre>

A frequency count is performed for each unique word, and words that appear only once are removed.
<pre>
  <code>
    data_df <- data |>
      group_by(word) |>
      summarize(count = n()) |>
      arrange(desc(count)) |>
      filter(count > 1)
  </code>
</pre>


4. Data Visualization
   
A bar plot is generated with ggplot2, displaying word frequencies on the y-axis and words on the x-axis.
The x-axis labels are rotated for readability.
<pre>
  <code>
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
  </code>
</pre>


The plot is saved as lyrics.png with the specified dimensions (2700x1800 pixels).
5. Saving the Plot
<pre>
  <code>
    ggsave(
      "lyrics.png",
      plot = p,
      width = 2700,
      height = 1800,
      units ="px"
    )
  </code>
</pre>


<h3>Output</h3>

A bar plot is generated using ggplot2, where the x-axis represents the words, and the y-axis represents their frequencies.
The plot is styled with color and custom axis labels.
Saving the Plot:
The plot is saved as lyrics.png in the working directory.

<h3>Usage</h3>

<ul>
  <li>Place your lyrics text files in a directory named ./lyrics within the working directory.</li>
  <li>Run the script to display a list of available lyrics files.</li>
  <li>Select a file by entering the corresponding menu number.</li>
  <li>The script will process the lyrics and generate a word frequency plot, saving it as lyrics.png.</li>
</ul>
