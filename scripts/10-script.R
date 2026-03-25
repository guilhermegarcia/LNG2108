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
pr_df <- pr_df |>
  mutate(
    partie = as_factor(partie),
    pt_chap = str_detect(texte, "^[IVXLCD]+\\.{1}$"),
    chapitre = cumsum(pt_chap),
    .by = partie
  )

pr_df |>
  summarize(len = max(chapitre), .by = partie)

# A: Il n'y a que deux chapitres dans la première partie,
# et les parties II et III ne sont pas subdivisées... donc, « non »

# Q: 2. Utilisez la fonction ntile(row_number(), X) pour diviser chaque partie en 10 sous-parties.
# Travailler avec la variable déjà tokenisée.
# A:
tokens <- tokens |>
  mutate(
    sous_partie = ntile(row_number(), 10) |> as_factor(),
    .by = partie
  )

tokens

# Q: 3. Calculez l'entropie de chaque sous partie pour toutes les trois parties.
# Enlevez les stopwords

sw <- stopwords("fr", source = "stopwords-iso")

entropie <- function(freq) {
  p <- freq / sum(freq)
  p <- p[p > 0]
  -sum(p * log2(p))
}

entropies <- tokens |>
  filter(!mot %in% sw) |>
  count(partie, sous_partie, mot) |>
  summarize(
    H = entropie(n),
    .by = c(partie, sous_partie)
  ) |>
  mutate(
    partie = as_factor(partie)
  )

# Q: 4. Calculez l'entropie moyenne et les écarts-types pour chaque partie. Quelle est la partie dont
# la diversité lexicale est la plus basse? Et quelle partie a la diversité la plus variable
# à travers ses sous-parties?
entropies |>
  summarize(
    M = mean(H),
    ET = sd(H),
    .by = partie
  )
# # A tibble: 3 × 3
#   partie     M     ET
#   <fct>  <dbl>  <dbl>
# 1 1      10.4  0.123
# 2 2      10.1  0.0979
# 3 3       8.86 0.169
# A: La troisième partie a la diversité la plus basse,
# mais c'est aussi celle avec la diversité la plus variable.
# Cela montre qu'il y a des sous-parties dans la 3ème partie qui sont
# beaucoup plus riches et diverses que d'autres.

# Q: 5. Développez une figure ggplot2 pour les résultats
ggplot(data = entropies, aes(x = sous_partie, y = H, color = partie)) +
  geom_point() +
  geom_line(aes(group = partie)) +
  theme_classic() +
  theme(
    legend.position = "top"
  ) +
  labs(
    x = "Sous-partie",
    y = "Entropie (Shannon)",
    color = "Partie"
  ) +
  scale_color_manual(
    values = c("black", "darkorange2", "steelblue2")
  )
