# LNG-2108 : Linguistique de corpus
# Séance 7 — Expressions régulières
# Script accompagnant les diapos

library(tidyverse)

# NOTE: Premier exemple ──────────────────────────────────────────────

texte <- "Le chat mange. Le chien dort. Le chat joue."

# Détecter si "chat" est présent
str_detect(texte, "chat") # ou texte |> str_detect("chat")
# [1] TRUE

# Extraire toutes les occurrences de "chat"
str_extract_all(texte, "chat")
# [[1]]
# [1] "chat" "chat"

# Compter les occurrences
str_count(texte, "chat")
# [1] 2

# NOTE: Métacaractères — le point ────────────────────────────────────

texte <- c("chat", "chut", "chât", "ch1t", "cht")

str_detect(texte, "ch.t")
# [1]  TRUE  TRUE  TRUE  TRUE FALSE

str_extract(texte, "ch.t")
# [1] "chat" "chut" "chât" "ch1t" NA

# NOTE: Classes de caractères ────────────────────────────────────────

str_extract_all("Le chat a 4 pattes.", "[0-9]")
# [[1]]
# [1] "4"

# NOTE: Quantificateurs — exemples ──────────────────────────────────

textes <- c("color", "colour", "colouur", "clor")

# ? : 0 ou 1 "u"
str_detect(textes, "colou?r")
# [1]  TRUE  TRUE FALSE FALSE

# + : 1 ou plusieurs "u"
str_detect(textes, "colou+r")
# [1] FALSE  TRUE  TRUE FALSE

# * : 0 ou plusieurs "u"
str_detect(textes, "colou*r")
# [1]  TRUE  TRUE  TRUE FALSE

# {1,2} : entre 1 et 2 "u"
str_detect(textes, "colou{1,2}r")
# [1] FALSE  TRUE  TRUE FALSE

# NOTE: Ancres ───────────────────────────────────────────────────────

textes <- c("Le chat dort", "Voici le chat", "rachat")

str_detect(textes, "^Le")
# [1]  TRUE FALSE FALSE

str_detect(textes, "\\bchat\\b")
# [1]  TRUE  TRUE FALSE  # "rachat" ne correspond pas

# NOTE: Alternation et groupes ───────────────────────────────────────

textes <- c("chat", "chien", "chouette", "chiennerie")

str_detect(textes, "chat|chien")
# [1]  TRUE  TRUE FALSE TRUE

# Avec groupe : "ch" suivi de "at" OU "ien"; plus économique
str_detect(textes, "ch(at|ien)")
# [1]  TRUE  TRUE FALSE TRUE

# Comparez avec :
str_detect(textes, "^ch") # trop général

# NOTE: Extraction avec str_extract() ────────────────────────────────

texte <- "Mon email est jean@ulaval.ca et le tien est marie@gmail.com"

# Extraire les emails (patron simplifié)
str_extract_all(texte, "[a-z]+@[a-z]+\\.[a-z]+")
# [[1]]
# [1] "jean@ulaval.ca"  "marie@gmail.com"

# Extraire tous les mots
str_extract_all(texte, "\\w+")
# [[1]]
# [1] "Mon"   "email" "est"   "jean"  "ulaval" "ca"    "et"
# [8] "le"    "tien"  "est"   "marie" "gmail" "com"

# NOTE: Remplacement avec str_replace() ──────────────────────────────

texte <- "Le chat mange le poisson."

# Remplacer la première occurrence
str_replace(texte, "le", "un")
# [1] "Le chat mange un poisson."  # Note: "Le" != "le"

# Remplacer toutes les occurrences (insensible à la casse)
str_replace_all(texte, regex("le", ignore_case = TRUE), "un")
str_replace_all(texte |> str_to_lower(), "le", "un")
# [1] "un chat mange un poisson."

# Supprimer la ponctuation
str_replace_all(texte, "[.,!?]", "")
str_remove_all(texte, "[.,!?]")
# [1] "Le chat mange le poisson"

# NOTE: Regex dans le Tidyverse ──────────────────────────────────────

df <- tibble(
  phrase = c("J'ai 3 chats.", "Elle a 12 ans.", "Il fait 25 degrés.")
)

df |>
  mutate(
    nombres = str_extract(phrase, "\\d+"),
    sans_chiffres = str_replace_all(phrase, "\\d+", "X")
  )

# NOTE: Filtrer avec str_detect() ────────────────────────────────────

mots <- tibble(
  mot = c("chat", "chien", "maison", "château", "chocolat", "voiture")
)

# Filtrer les mots qui commencent par "ch"
mots |>
  filter(str_detect(mot, "^ch")) # ou  filter(mot |> str_detect("^ch"))

# NOTE: Cas pratique — nettoyer un texte ─────────────────────────────

texte_brut <- "  Le   chat    mange...   la   souris!!!  "

texte_propre <- texte_brut |>
  str_trim() |> # Supprimer espaces début/fin
  str_replace_all("\\s+", " ") |> # Normaliser les espaces
  str_replace_all("[.!?]+", ".") |> # Normaliser la ponctuation
  str_to_lower() # Minuscules

texte_propre
# [1] "le chat mange. la souris."

# NOTE: Pratique 1 ───────────────────────────────────────────────────

texte <- "Marie a 25 ans. Pierre a 30 ans. Sophie a 22 ans."

# 1. Prénoms (mots commençant par majuscule)
str_extract_all(texte, "\\b[A-Z][a-z]+\\b")

# 2. Nombres
str_extract_all(texte, "\\d+")

# 3. Remplacer les nombres
str_replace_all(texte, "\\d+", "XX")

# 4. Compter "ans"
str_count(texte, "\\bans\\b")

# NOTE: Pratique 2 ───────────────────────────────────────────────────

corpus <- tibble(
  doc = 1:4,
  texte = c(
    "Le château est magnifique.",
    "J'aime le chocolat noir.",
    "La maison rouge est grande.",
    "Le chien dort tranquillement."
  )
)

# 1. Filtrer les documents avec mots en "ch"
corpus |>
  filter(str_detect(texte, "\\bch\\w+"))
# docs 1, 2, 4 (château, chocolat, chien)

# 2. Nombre de mots par document
corpus |>
  mutate(n_mots = str_count(texte, "\\w+"))

# 3. Adverbes en -ment
corpus |>
  mutate(adverbe = str_extract(texte, "\\w+ment\\b"))
# Seul doc 4 a un adverbe : "tranquillement"

# NOTE: Pratique finale ──────────────────────────────────────────────

texte <- "L'éducation natIOnale a publié 3 résolutions    en 2024.
    La communication et   l'infoRmation sont essenTIelles!
    François, 45 ans, habite à MonTréal dEPuis 12 ans."

# 1. Nettoyer
texte_propre <- texte |>
  str_to_lower() |>
  str_replace_all("\\s+", " ") |>
  str_trim()

# 2. Mots en -tion
str_extract_all(texte_propre, "\\b\\w+tion\\b") |> unlist()
# "éducation" "communication" "information"

# 3. Mots de plus de 6 lettres
str_count(texte_propre, "\\b\\w{7,}\\b")

# 4. Remplacer les voyelles accentuées
texte_propre |>
  str_replace_all("é", "e") |>
  str_replace_all("à", "a")

# 5. Mots avec voyelle accentuée
texte_propre |>
  str_extract_all(
    "\\b\\w*[éà]\\w*\\b"
  ) |>
  unlist() |>
  unique()
