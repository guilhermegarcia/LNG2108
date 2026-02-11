library(tidyverse)
library(janitor)

# INFO: LNG-2108 : Linguistique de corpus
# Séance 5 : R et Tidyverse — Code accompagnant les diapositives
# Guilherme D. Garcia
# =============================================================================

## NOTE: Vous vous souvenez? ----
# Questions sur la lecture d'aujourd'hui

# Q: 1. Comment exécutez-vous une commande en R?
# A: Cmd+Enter (Mac) ou Ctrl+Enter (Windows/Linux)

# Q: 2. On importe une extension en utilisant la fonction...?
# A: library(tidyverse)

# Q: 3. Quelle est la différence entre =, <-, et == ?
x <- "corpus"
x <- "corpus"
x == "corpus" # TRUE (évaluation : est-ce que x est égal à "corpus"?)

# Q: 4. Fonctions tidyverse et leurs objectifs
# mutate()    : créer ou modifier des colonnes
# filter()    : filtrer des lignes selon une condition
# arrange()   : trier les lignes
# select()    : sélectionner des colonnes
# summarize() : résumer des données (moyenne, somme, etc.)
# sample_n()  : échantillonner n lignes aléatoirement


## NOTE: Vrai ou faux? ----

# Q: 1. Il faut importer une extension chaque fois qu'on visite notre projet sur posit.cloud
# A: Faux : dans le site web, les sessions sont persistantes entre les connexions

# Q: 2. On utilise # pour ajouter des commentaires
# A: Vrai

# Q: 3. On installe une extension chaque fois qu'on l'utilise
# A: Faux : on installe une extension une seule fois

# Q: 4. Le pipe |> nous permet d'enchaîner plusieurs opérations en même temps
# A: Vrai

# Q: 5. Si j'ajoute mes notes dans un fichier du cours, elles seront effacées par la synchronisation Git
# A: Vrai


## NOTE: Les bases de R ----
# Questions sur le chapitre 2 de la lecture

# Q: 1. Créer un vecteur avec c()
nombres <- c(1, 2, 3, 4, 5)
mots <- c("linguistique", "corpus", "analyse")
logiques <- c(TRUE, FALSE, TRUE)

# Q: 2. L'opérateur [] pour sélectionner des éléments
nombres[1] # Premier élément
nombres[2:4] # Éléments 2, 3, et 4
nombres[c(1, 5)] # Premier et cinquième éléments
mots[2] # "corpus"

# Q: 3. install.packages() vs library()
# install.packages("tidyverse")  # Une seule fois (télécharge le package)
# library(tidyverse)             # À chaque session (charge en mémoire)

# Q: 4. Générer une séquence de nombres
1:10 # Séquence de 1 à 10
5:15 # Séquence de 5 à 15
seq(0, 100, 10) # Séquence de 0 à 100, par pas de 10

# Q: 5. NA (valeurs manquantes) et na.rm
donnees <- c(10, 20, NA, 40, 50)
mean(donnees) # NA (résultat contaminé)
mean(donnees, na.rm = TRUE) # 30 (ignore les NA)
sum(donnees, na.rm = TRUE) # 120


## NOTE: Organisation et tidyverse ----
# Questions sur les chapitres 5 et 6 de la lecture

# Q: 1. Tibble vs data frame
# A: Un tibble est une version moderne du data frame
df_classique <- data.frame(
  mot = c("le", "la", "les"),
  freq = c(100, 80, 60)
)

tibble_moderne <- tibble(
  mot = c("le", "la", "les"),
  freq = c(100, 80, 60)
)

# Différences visibles :
df_classique # Affichage classique
tibble_moderne # Affichage avec types de colonnes, dimensions

# Q: 2. Les trois principes des données "tidy"
# A: a. Chaque variable = une colonne
# A: b. Chaque observation = une ligne
# A: c. Chaque type d'observation = un tableau séparé

# Exemple de données tidy :
corpus_tidy <- tibble(
  document = c("doc1", "doc1", "doc2", "doc2"),
  mot = c("chat", "chien", "chat", "oiseau"),
  frequence = c(5, 3, 2, 7)
)

# Q: 3. La fonction source()
# source("mon_autre_script.R")  # Exécute un script externe

## NOTE: Importer et exporter des données ----
# Questions sur le chapitre 7 de la lecture

# Q: 1. Importer un fichier CSV standard
# A: donnees <- read_csv("chemin/vers/fichier.csv")

# Q: 2. read_csv() vs read_csv2()
# A: read_csv()  : séparateur = virgule (,)     — format anglophone
# A: read_csv2() : séparateur = point-virgule (;) — format européen/français

# Exemple :
# donnees_us <- read_csv("fichier_americain.csv")
# donnees_fr <- read_csv2("fichier_francais.csv")
# HACK: Voir diapos sur l'encodage (UTF-8), séance 5

# Q: 3. Importer des fichiers Excel
# A:
library(readxl)
total_excel <- read_excel("donnees/seance_3_total.xlsx")
# donnees_excel <- read_excel("fichier.xlsx", sheet = "Feuille2")

# Q: 4. Exporter un tibble vers CSV
# A:
# write_csv(mon_tibble, "nouveau_fichier.csv")

# Exemple concret :
exemple <- tibble(
  mot = c("bonjour", "merci", "au revoir"),
  categorie = c("salutation", "politesse", "salutation")
)
# write_csv(exemple, "exemple_export.csv")

# Q: 5. Chemins relatifs vs absolus
# A:
# Chemin absolu (à éviter) :
# "/Users/etudiant/Documents/projet/donnees/corpus.csv"
# A:
# Chemin relatif (recommandé) :
# "donnees/corpus.csv"

# Les chemins relatifs rendent le code portable et reproductible

## NOTE: Pratique sur Posit

# Q: 1. Importer le fichier
p1 <- read_csv("donnees/pratique_1.csv")

# Q: 2. Ajouter une colonne pour le nombre de caractères de chaque token
p1 <- p1 |>
  mutate(
    longueur = str_length(token)
  )

# Q: 3. Enlever les DET
p1 <- p1 |>
  filter(pos != "DET")

# Q: 4. Compter le nombre d'observations par catégorie grammaticale
p1 |>
  count(pos)

# Q: 5. Quelle est la longueur moyenne des tokens?
p1 |>
  summarize(
    long_m = mean(longueur)
  )

# Q: 6. Et la longueur par catégorie grammaticale?
# Ordonnez le résultat par ordre décroissant
p1_ord <- p1 |>
  summarize(
    long_m = mean(longueur),
    .by = pos
  ) |>
  arrange(desc(long_m))

# Q: 7. Exporter le tableau ordonné
# write_csv("pratique_1_ord.csv")

# NOTE: Pratique avec un échantillon

p2 <- read_table("donnees/pratique_2.txt")

p2_tibble <- tibble(mot = p2)

p2_tibble |>
  count(mot) |>
  mutate(
    prop = n / sum(n),
    mpm = prop * 1000000
  ) |>
  arrange(desc(n))

# NOTE: Pratique avec le csv de la séance 3 (Frantext)

# Q: 1. Importez et nettoyez les données.
# Ajoutez une colonne pour les intervalles/périodes
p3 <- read_csv("donnees/pratique_seance_3.csv")
p3 <- p3 |> clean_names()

p3 <- p3 |>
  mutate(
    periode = annee - annee %% 25,
    intervalle = str_c(periode, "-", periode + 24)
  )

# Q: 2. Qui sont les trois auteurs les plus représentatifs?
p3 |>
  count(auteur_trice) |>
  slice_max(n, n = 3)


# Q: 3. Quel est le domaine le plus commun dans le corpus?
p3 |>
  count(domaine) |>
  slice_max(n, n = 3)

# Q: 4. Visualiser le nombre d’occurrences par période de 25 ans dans le corpus (champ "Année").
occ <- p3 |>
  count(intervalle) |>
  arrange(desc(n))
occ

# Q: 5. Calculer la fréquence relative (par 1 000 000 mots) pour chaque période de 25 ans
# A: Importer les totaux
total <- read_table("donnees/seance_3_total.txt") |>
  rename(
    intervalle = période
  )

occ |>
  left_join(total) |>
  mutate(
    freq_rel = n / nb_mots * 1000000
  ) |>
  arrange(intervalle) # A: Ordonner par période/intervalle
