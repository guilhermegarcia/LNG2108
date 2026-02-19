library(tidyverse)
library(tidytext)
library(udpipe)

# INFO: LNG-2108 : Linguistique de corpus
# Séance 6 : R et Tidyverse — Code accompagnant les diapositives
# Guilherme D. Garcia
# =============================================================================

# NOTE: Texte exemple
texte <- "Le chat mange la souris."

str_split(texte, pattern = " ")
# [[1]]
# [1] "Le"      "chat"    "mange"   "la"      "souris."
# Le résultat est une *liste* (~dictionnaire en Python)


# NOTE: Tokenisation avec RegEx
texte |>
  str_extract_all("\\w+") |>
  unlist()
# [1] "Le"     "chat"   "mange"  "la"     "souris"

texte |>
  str_extract_all("\\w") |>
  unlist()
#  [1] "L" "e" "c" "h" "a" "t" "m" "a" "n" "g" "e" "l" "a" "s" "o" "u" "r" "i" "s"

# NOTE: Tokenisation automatisée
df <- tibble(
  texte = "Le chat mange la souris."
)

df |>
  unnest_tokens(
    output = mot,
    input = texte
  )
# # A tibble: 5 × 1
#   mot
#   <chr>
# 1 le
# 2 chat
# 3 mange
# 4 la
# 5 souris

# NOTE: Options dans la tokenisation
# Tokenisation par défaut (mots, minuscules)
df |> unnest_tokens(mot, texte)
# # A tibble: 5 × 1
#   mot
#   <chr>
# 1 le
# 2 chat
# 3 mange
# 4 la
# 5 souris

# Conserver la casse originale
df |> unnest_tokens(mot, texte, to_lower = FALSE)
# # A tibble: 5 × 1
#   mot
#   <chr>
# 1 Le
# 2 chat
# 3 mange
# 4 la
# 5 souris

# Tokeniser par caractères
df |> unnest_tokens(caractere, texte, token = "characters")
# # A tibble: 19 × 1
#    caractere
#    <chr>
#  1 l
#  2 e
#  3 c
#  4 h
#  5 a
#  6 t
#  7 m
#  8 a
#  9 n
# 10 g
# 11 e
# 12 l
# 13 a
# 14 s
# 15 o
# 16 u
# 17 r
# 18 i
# 19 s

# Tokeniser par phrases
df |> unnest_tokens(phrase, texte, token = "sentences")
# # A tibble: 1 × 1
#   phrase
#   <chr>
# 1 le chat mange la souris.

# Tokeniser par n-grammes (bigrammes)
df |> unnest_tokens(bigramme, texte, token = "ngrams", n = 2)
# # A tibble: 4 × 1
#   bigramme
#   <chr>
# 1 le chat
# 2 chat mange
# 3 mange la
# 4 la souris

# NOTE: Étiquetage
# Télécharger le modèle français (une seule fois)
udpipe_download_model(language = "french")
modele <- udpipe_load_model("french-gsd-ud-2.5-191206.udpipe")
# Créer un texte simple

texte <- "L'enfant n'aime pas les épinards."
annotation <- udpipe_annotate(modele, texte)
annotation |>
  as.data.frame() |>
  as_tibble() |>
  select(sentence, token, lemma, upos)


# NOTE: Pratique 1
# Q: Combien de tokens y a-t-il?
texte <- "La linguistique de corpus analyse des textes réels pour comprendre le fonctionnement du langage."
df <- tibble(texte = texte)

tokens <- df |> unnest_tokens(mot, texte) # 1. Nombre de tokens
nrow(tokens) # 14 tokens

# Q: Quel est le token le plus long?
tokens |> mutate(longueur = nchar(mot)) |> # 2. Token le plus long
  slice_max(longueur) # "fonctionnement" (14 caractères)

# Q: Tokenisez en bigrammes.
bigrammes <- df |>
  unnest_tokens(bigramme, texte, token = "ngrams", n = 2)

nrow(bigrammes) # 3. Il y en a 13

# NOTE: Pratique finale

# Q: Importer les données
mc <- read_lines("donnees/monte_cristo.txt")

# Q: Créer un tibble pour le texte
mc_tibble <- tibble(
  texte = mc
)

# Q: Tokeniser le texte et compter + trier les mots
tokens <- mc_tibble |>
  unnest_tokens(
    output = mot,
    input = texte,
  ) |>
  count(mot, sort = TRUE) |>
  mutate(rang = row_number())

tokens
nrow(tokens)

# Q: Enlever les mots fonctionnels?
library(tm) # A: Option pratique (mais pas complète!)
mots <- stopwords(kind = "fr")

tokens_lex <- tokens |>
  filter(!mot %in% mots)

tokens
tokens_lex
