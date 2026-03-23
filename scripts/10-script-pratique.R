library(tidyverse)
library(tidytext)
library(stopwords)

# NOTE: Voici le code utilisé dans la séance 9 (9-script.R)

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

tokens


# Q: PRATIQUE séance 10
# Q: 1. Quelle est la structure interne de chaque partie du texte? Chaque partie est-elle divisée en chapitres? Pouvez-vous calculer l'entropie *interne* de chaque partie en la subdivisant en chapitres?

# Q: 2. Utilisez la fonction ntile(row_number(), X) pour diviser chaque partie en 10 sous-parties.
# Travailler avec la variable déjà tokenisée.

# Q: 3. Calculez l'entropie de chaque sous partie pour toutes les trois parties.
# Enlevez les stopwords

# Q: 4. Calculez l'entropie moyenne et les écarts-types pour chaque partie. Quelle est la partie dont
# la diversité lexicale est la plus basse? Et quelle partie a la diversité la plus variable
# à travers ses sous-parties?

# Q: 5. Développez une figure ggplot2 pour les résultats
