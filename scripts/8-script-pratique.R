# LNG-2108 : Linguistique de corpus
# Séance 8 — Expressions régulières -> Théorie de l'information
# Script accompagnant les diapos

library(tidyverse)

# NOTE: Révision : chargez monte_cristo.RData

# NOTE: Q1 — Extraire les titres de chapitres
# Le roman est divisé en chapitres numérotés en chiffres romains (ex. : XXIII  L'île de Monte-Cristo.). Utilisez str_subset() pour extraire toutes les lignes qui commencent par un numéro de chapitre en chiffres romains.

# NOTE: Question 2 — Repérer les lignes de dialogue
# Le texte utilise deux conventions pour les dialogues : -- en début de ligne (répliques directes) et « (guillemets français). Utilisez str_subset() et une alternance (|) pour capturer les deux à la fois.

# NOTE: Variante bonus : compter combien de lignes correspondent à chaque convention séparément avec str_detect().
