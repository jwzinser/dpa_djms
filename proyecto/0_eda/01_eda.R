library(tidyverse)
library(stringr)
library(lubridate)
library(forcats)

theme_set(theme_minimal())

# Leer datos

df.list <- readxl::read_excel("proyecto/listverse01_10.xlsx") %>% 
  dplyr::select(-page) %>% 
  unique() %>% 
  mutate(row.id = rownames(.)) %>% 
  gather(var.lab, var.val, -row.id) %>% 
  mutate(var.val.2 = gsub("u'|'|,", "", var.val) ) %>% 
  group_by(var.lab, var.val.2) %>% 
  dplyr::select(-var.val) %>% 
  spread(var.lab, var.val.2)

head(df.list %>% arrange(title) %>% data.frame())

df.list %>% dim
df.list$author %>% n_distinct() # 43 autores
df.list$date %>% n_distinct() # 46 días


df.list %>% 
  group_by(`title category`) %>% 
  tally %>% 
  ggplot(aes( x= fct_reorder(`title category`, n, mean), y = n)) + 
  geom_bar(stat = 'identity') + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0))


df.list %>% 
  group_by(`title category`, author) %>% 
  tally %>% 
  ggplot(aes(x = `title category`, y= author, fill = n)) + 
  geom_tile() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0))+ 
  ylab("frecuencia") + 
  xlab("title category")

df.list %>% 
  group_by(`title category`, author) %>% 
  tally %>% 
  group_by(`title category`) %>% 
  summarise(total = mean(n)) %>% 
  arrange(desc(total)) %>% 
  ggplot(aes(x = fct_reorder(`title category`, total, mean), y = total)) + 
  geom_bar(stat = 'identity') + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0))+ 
  ylab("promedio de artículos\npor autor") + 
  xlab("title category")
