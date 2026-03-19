# LNG-2108 : Linguistique de corpfs
# Séance 9 — Préparation de données textuelles
# Script accompagnant les diapos

library(tidyverse)
library(tidytext)
library(stopwords)

entropie <- function(freq) {
  p <- freq / sum(freq)
  p <- p[p > 0]
  -sum(p * log2(p))
}

# Q: Pratique finale avec monte_cristo.RData

load("donnees/monte_cristo.RData")

# Q: Nettoyez le texte
# Q: Extrayez tous les mots en -tion
# Q: Calculez l'entropie de la distribution des mots
# Q: Extrayez les bigrammes les plus fréquentes
# Q: Calculez P(w2|w1) pour un bigramme fréquent

# A: Nettoyez le texte
mc_net <- mc |>
  str_subset(".+") |>
  str_to_lower() |>
  str_trim() |>
  str_replace_all("\\s+", " ") |>
  str_remove_all("\\d+|_")

mc_tibble <- tibble(
  texte = mc_net
)

mc_tibble

# A: Extrayez tous les mots en -tion
# Il est plus facile de travailler avec mc_net ici:
tion <- mc_net |>
  str_extract_all("\\b\\w+tion\\b") |>
  unlist()

# A: Calculez l'entropie de la distribution des mots
mc_tok <- mc_tibble |>
  unnest_tokens(mot, texte)

freq <- mc_tok |>
  count(mot, sort = TRUE)

entropie(freq$n)
# HACK: Voici l'entropie MAXIMALE pour le texte :
log2(nrow(freq))

entropie(freq$n) / log2(nrow(freq))

# A: Extrayez les bigrammes les plus fréquentes
bigrammes <- tibble(
  texte = mc_net
) |>
  unnest_tokens(bg, texte, token = "ngrams", n = 2) |>
  filter(!is.na(bg)) |>
  count(bg, sort = TRUE) |>
  separate(bg, c("m1", "m2"), sep = " ") |>
  group_by(m1) |>
  mutate(prob = n / sum(n)) |>
  arrange(desc(n))

bigrammes

# A: Calculez P(w2|w1) pour un bigramme fréquent
bigrammes |>
  filter(
    m1 == "monte",
    m2 == "cristo"
  )

# NOTE: Introduction à ggplot2

# cumsum() sur un vecteur logique : chaque TRUE incrémente le compteur
lignes <- c(TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE)
cumsum(lignes)
# [1] 1 1 1 1 2 2 2


# Q: Chargez proust.RData et préparez les données.
load("donnees/proust.Rdata")
pr_df <- tibble(texte = proust) |>
  mutate(
    pt_header = str_detect(texte, "^(PREMIÈRE|DEUXIÈME|TROISIÈME)"),
    partie = cumsum(pt_header)
  ) |>
  filter(!pt_header, str_length(texte) > 0) |> # enlever les pt_header FALSE + les lignes vides
  mutate(texte = str_replace_all(texte, "’|'", " "))

pr_df

# Q: Tokeniser avec unnest_tokens()
# A: Tokenisation
tokens <- pr_df |>
  unnest_tokens(mot, texte) |>
  select(-pt_header)

# A: Statistique de base
n_tokens <- nrow(tokens)
n_types <- tokens |> # Option 1
  summarize(types = n_distinct(mot)) |>
  pull(types)
n_types <- n_distinct(tokens$mot) # Option 2

ttr <- tokens |>
  summarize(
    n_tok = n(),
    n_type = n_distinct(mot),
    ttr = n_type / n_tok,
    .by = partie
  ) |>
  arrange(desc(ttr))
# # A tibble: 3 × 4
#   partie n_tok n_type   ttr
#    <int> <int>  <int> <dbl>
# 1      3 19119   3857 0.202
# 2      1 79014   9882 0.125
# 3      2 83350   8936 0.107


# NOTE: On continue la semaine prochaine
