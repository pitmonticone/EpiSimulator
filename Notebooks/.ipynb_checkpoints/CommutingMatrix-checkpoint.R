library(tidyverse)
library(igraph)

ISTATCommutingData <- read_table("GitHub/DigitalEpidemiologyProject/Data/TXT/ISTATCommutingData.txt",
                                 col_names = FALSE)

read_table("GitHub/DigitalEpidemiologyProject/Data/TXT/ISTATCommutingData.txt",
                  col_names = FALSE) %>%
  filter(X1=="S") %>%
  mutate(from = as.numeric(X3),
         to = as.numeric(X8),
         n = as.numeric(X15)) %>%
  filter(to != "000000")  %>%
  select(from, to, n) %>% 
  group_by(from, to) %>%
  summarise(tot_n = sum(n)) %>% 
  write.csv("GitHub/DigitalEpidemiologyProject/Data/CSV/ProvincialWeightedEdgeList.csv", row.names = FALSE)
