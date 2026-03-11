# LNG-2108 : Linguistique de corpus
# Séance 8 — Expressions régulières -> Théorie de l'information
# Script accompagnant les diapos

library(tidyverse)

# NOTE: Révision : chargez monte_cristo.RData
load("donnees/monte_cristo.RData")
mc |> head(n = 100)

# Q: Q1 — Extraire les titres de chapitres
# Le roman est divisé en chapitres numérotés en chiffres romains (ex. : XXIII  L'île de Monte-Cristo.). Utilisez str_subset() pour extraire toutes les lignes qui commencent par un numéro de chapitre en chiffres romains.
# A: Regex à construire : une ligne qui commence (^) par une séquence de chiffres romains (I, V, X, L, C) suivie d'un point.
chapitres <- str_subset(mc, "^[IVXLC]+$")

# Extra : comment extraire les titres des chapitres?
# Ils viennent deux lignes *après* le chiffre romain. Cela nous aide
# à définir une logique prévisible :
# 1. Prenez la position de chaque chiffre romain (c'est-à-dire l'indice de la ligne)
# 2. Extrayez la ligne deux positions après cette position

position <- mc |> str_which("^[IVXLC]+$") # la position de chaque chapitre
ch <- tibble(
  chapitre = mc[position],
  titre = mc[position + 2]
)

ch
# # A tibble: 117 × 2
#    chapitre titre
#    <chr>    <chr>
#  1 I        Marseille.--L'arrivée.
#  2 II       Le père et le fils.
#  3 III      Les Catalans.
#  4 IV       Complot.
#  5 V        Le repas des fiançailles.
#  6 VI       Le substitut du procureur du roi.
#  7 VII      L'interrogatoire.
#  8 VIII     Le château d'If.
#  9 IX       Le soir des fiançailles.
# 10 X        Le petit cabinet des Tuileries.
# # ℹ 107 more rows
# # ℹ Use `print(n = ...)` to see more rows

# HACK: Le saviez-vous? R nous donne des fonctions intégrées
# pour convertir les chiffres romains
chapitres |>
  as.roman() |>
  as.numeric()

# Donc :
"XV" |>
  as.roman() |>
  as.numeric()
# [1] 15

15 |> as.roman()
# [1] XV

# Q: Q2 — Repérer les lignes de dialogue
# Le texte utilise deux conventions pour les dialogues : -- en début de ligne (répliques directes) et « (guillemets français). Utilisez str_subset() et une alternance (|) pour capturer les deux à la fois.

# A: Regex à construire : ligne commençant par -- ou contenant «.

dialogue <- str_subset(mc, "^--|«")

# Q: Variante bonus : compter combien de lignes correspondent à chaque convention séparément avec str_detect().
dialogue |>
  str_detect("^--") |>
  sum()

dialogue |>
  str_detect("«") |>
  sum()


# Q: Q3 — Extraire les dates historiques
# Dumas ancre son récit dans l'Histoire (ex. : Le 24 février 1815…). Utilisez str_extract() pour extraire les dates au format [jour] [mois écrit] [année].

# A: Regex à construire : un ou plusieurs chiffres, un espace, un nom de mois, un espace, quatre chiffres.

mois <- "janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre"

dates <- mc |>
  str_extract(str_c("[0-9]+\\s+(", mois, ")\\s+[0-9]{4}"))
dates <- dates[!is.na(dates)]

# NOTE: Théorie de l'information

entropie <- function(freq) {
  p <- freq / sum(freq)
  p <- p[p > 0]
  -sum(p * log2(p))
}

exemple1 <- c(10, 5, 3, 2) # Fréquences observées
exemple2 <- c(5, 5, 5, 5) # Fréquences observées

entropie(exemple1)
# [1] 1.742738
entropie(exemple2)
# [1] 2


texte_simple <- c(le = 50, chat = 30, dort = 20)
texte_divers <- c(
  le = 10, chat = 10, dort = 10,
  mange = 10, joue = 10
)

texte_simple |> entropie()
# [1] 1.485475
texte_divers |> entropie()
# [1] 2.321928
log2(5)
# [1] 2.321928

# NOTE: n-grammes (révision)
library(tidytext)

texte <- "Le chat mange la souris. Le chat dort. Le chien court."
df <- tibble(texte = texte)

# Extraire les bigrammes
bigrammes <- df |>
  unnest_tokens(bigramme, texte, token = "ngrams", n = 2) |>
  count(bigramme, sort = TRUE)

bigrammes

# NOTE: Calculer les probabilités
bigrammes <- df |>
  unnest_tokens(bigramme, texte, token = "ngrams", n = 2) |>
  count(bigramme, sort = TRUE) |>
  separate(bigramme, into = c("mot1", "mot2"), sep = " ")
# # A tibble: 9 × 3
#   mot1   mot2       n
#   <chr>  <chr>  <int>
# 1 le     chat       2
# 2 chat   dort       1
# 3 chat   mange      1
# 4 chien  court      1
# 5 dort   le         1
# 6 la     souris     1
# 7 le     chien      1
# 8 mange  la         1
# 9 souris le         1


# Calculer P(mot2 | mot1)
bigrammes |>
  group_by(mot1) |>
  mutate(prob = n / sum(n))
# # A tibble: 9 × 4
# # Groups:   mot1 [7]
#   mot1   mot2       n  prob
#   <chr>  <chr>  <int> <dbl>
# 1 le     chat       2 0.667
# 2 chat   dort       1 0.5
# 3 chat   mange      1 0.5
# 4 chien  court      1 1
# 5 dort   le         1 1
# 6 la     souris     1 1
# 7 le     chien      1 0.333
# 8 mange  la         1 1
# 9 souris le         1 1

# NOTE: Pratique
corpus <- c(
  "le chat noir dort", "le chien noir court",
  "le chat blanc mange", "le petit chat dort"
)

df <- tibble(texte = corpus) |> unnest_tokens(mot, texte)
freq <- df |> count(mot)
# 1. Entropie
entropie(freq$n)
# [1] 2.95282

# 2. Bigrammes
bi <- tibble(texte = corpus) |>
  unnest_tokens(bg, texte, token = "ngrams", n = 2) |>
  count(bg, sort = TRUE)
# # A tibble: 11 × 2
#    bg              n
#    <chr>       <int>
#  1 le chat         2
#  2 blanc mange     1
#  3 chat blanc      1
#  4 chat dort       1
#  5 chat noir       1
#  6 chien noir      1
#  7 le chien        1
#  8 le petit        1
#  9 noir court      1
# 10 noir dort       1
# 11 petit chat      1

# 3. P(dort|chat)
bi |>
  separate(bg, c("mot1", "mot2"), sep = " ") |>
  filter(mot1 == "chat") |>
  mutate(prob = n / sum(n))
# # A tibble: 3 × 4
#   mot1  mot2      n  prob
#   <chr> <chr> <int> <dbl>
# 1 chat  blanc     1 0.333
# 2 chat  dort      1 0.333 <<<<
# 3 chat  noir      1 0.333
