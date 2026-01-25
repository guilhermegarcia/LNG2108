# Introduction à GitHub

## C'est quoi, GitHub?

Imaginez une bibliothèque où vous pouvez :

- Télécharger des documents
- Recevoir automatiquement les nouvelles versions quand l'auteur les met à jour
- Voir exactement ce qui a changé entre deux versions

C'est essentiellement ce que fait **GitHub** : un service en ligne qui permet de stocker, partager et gérer des fichiers (surtout du code, mais aussi des données et des documents).

GitHub utilise un système appelé **Git**, qui garde un historique complet de toutes les modifications. C'est comme la fonction « Historique des versions » dans Google Docs, mais beaucoup plus puissante.

## Pourquoi on utilise GitHub dans ce cours?

1. **Centralisation** : Tous les fichiers du cours (scripts, données, exercices) sont au même endroit
2. **Mises à jour faciles** : Quand on ajoute du nouveau contenu, vous pouvez le récupérer en une seule commande
3. **Transparence** : Vous pouvez voir exactement ce qui a changé d'une semaine à l'autre
4. **Compétence transférable** : GitHub est utilisé partout en science des données et en linguistique computationnelle

## Le vocabulaire essentiel

| Terme | Signification |
|-------|---------------|
| **Dépôt** (*repository* ou *repo*) | Un dossier de projet sur GitHub |
| **Cloner** (*clone*) | Télécharger une copie complète d'un dépôt sur votre ordinateur |
| **Tirer** (*pull* / *fetch*) | Récupérer les dernières mises à jour du dépôt |
| **Branche** (*branch*) | Une version parallèle du projet (nous utilisons `main`) |
| **Origin** | Le nom par défaut du dépôt distant (sur GitHub) |

## Comment ça fonctionne avec Posit Cloud?

### Étape 1 : Créer votre projet (une seule fois)

Quand vous créez un nouveau projet sur Posit Cloud à partir de notre dépôt Git, vous faites ce qu'on appelle un **clone**. Cela copie tous les fichiers du cours dans votre espace de travail personnel.

### Étape 2 : Mettre à jour le dépôt (régulièrement)

Au fil du semestre, nous ajouterons du contenu (nouveaux scripts, nouvelles données, etc.). Pour synchroniser votre projet avec ces mises à jour :

1. Ouvrez l'onglet **Terminal** dans Posit Cloud (pas la Console R!)
2. Tapez ou collez cette commande :

```bash
git fetch origin && git reset --hard origin/main
```

1. Appuyez sur Entrée

C'est tout! Vos fichiers seront maintenant à jour.

## Qu'est-ce que cette commande fait exactement?

Décomposons-la :

- `git fetch origin` : Vérifie s'il y a des nouveautés sur GitHub
- `&&` : Si la première commande réussit, exécute la suivante
- `git reset --hard origin/main` : Remplace vos fichiers par la version officielle sur GitHub

### Avertissement important

Cette commande **écrase** les modifications que vous avez faites aux fichiers du cours. Par exemple, si vous avez modifié un script `.R` fourni par nous, vos modifications seront perdues.

**Solution** : Créez vos propres fichiers et dossiers pour vos notes et expérimentations. Ces fichiers ne seront jamais affectés par la mise à jour.

```
mon_projet/
├── diapos/          ← fichiers du cours (ne pas modifier)
├── donnees/         ← fichiers du cours (ne pas modifier)
├── scripts/         ← fichiers du cours (ne pas modifier)
├── exercices/       ← fichiers du cours (ne pas modifier)
├── mes_notes/       ← votre dossier personnel (protégé)
└── mes_scripts/     ← votre dossier personnel (protégé)
```

## Poser des questions sur GitHub

Notre dépôt a une section **Discussions** où vous pouvez poser des questions sur le code, les exercices ou les concepts du cours. C'est comme un forum intégré au dépôt.

### Comment y accéder

1. Allez sur la page du dépôt sur GitHub
2. Cliquez sur l'onglet **Discussions**
3. Cliquez sur **New discussion** pour poser une question

### Conseils pour poser une bonne question

- **Donnez un titre clair** : « Erreur avec read_csv() » plutôt que « Ça marche pas »
- **Montrez votre code** : Copiez-collez le code qui pose problème
- **Montrez l'erreur** : Incluez le message d'erreur complet
- **Expliquez ce que vous avez essayé** : Ça aide à comprendre le problème

### Exemple de question bien formulée

> **Titre** : Erreur "object not found" avec filter()
>
> Bonjour, j'essaie de filtrer mon corpus mais j'obtiens cette erreur :
>
> ```r
> corpus |> filter(langue == "français")
> # Error: object 'langue' not found
> ```
>
> J'ai vérifié et la colonne `langue` existe dans mon tableau. J'ai essayé de recharger le fichier mais l'erreur persiste.

## Ressources supplémentaires

- [GitHub Docs (en français)](https://docs.github.com/fr) — Documentation officielle
- [Posit Cloud Guide](https://posit.cloud/learn/guide) — Guide de Posit Cloud (en anglais)

---

*Vous n'avez pas besoin de maîtriser Git pour réussir ce cours. Les commandes ci-dessus sont tout ce dont vous aurez besoin.*
