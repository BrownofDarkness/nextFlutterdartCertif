# nextFlutterDartCertif

Repository pour la complétion du parcours Dart de NextFlutter.

## Description

Application CLI (ligne de commande) de gestion de tâches, écrite en Dart pur (sans Flutter). Elle permet d'ajouter, lister, trier, mettre à jour et supprimer des tâches, avec persistance des données dans un fichier JSON local.

## Prérequis

- Dart SDK ^3.9.0

## Installation

```bash
dart pub get
```

## Lancement

```bash
dart run main.dart
```

Un menu interactif s'affiche dans le terminal, permettant de choisir une action.

## Fonctionnalités

- **Ajouter une tâche** : titre, priorité (`low`, `medium`, `high`), date limite optionnelle
- **Lister toutes les tâches**
- **Trier les tâches** par priorité ou par date limite
- **Mettre à jour** le titre ou la date limite d'une tâche existante
- **Supprimer** une tâche
- **Persistance automatique** dans un fichier `tasks.json` local à chaque modification

## Architecture

- **Classes abstraites et héritage** : `Task` est une classe abstraite dont héritent `UrgentTask`, `MediumTask` et `LowTask`, chacune avec un comportement d'affichage (`toString()`) qui lui est propre.
- **Interface** : `Repository<T>` définit un contrat générique (`saveElt`, `listElts`, `updateElt`, `deleteElt`), implémenté par `TaskRepository` avec `T = Task`.
- **Génériques** : `Repository<T>` permet de définir la mécanique de persistance indépendamment du type concret manipulé.
- **Gestion des erreurs** : exceptions personnalisées (`InvalidPriorityException`, `TaskNotFoundException`) pour signaler les cas d'usage invalides (priorité incorrecte, tâche introuvable).
- **Persistance JSON** : chaque tâche est sérialisée/désérialisée via `toJson()` / `Task.fromJson()`, avec reconstruction automatique de la bonne sous-classe selon le champ `priority`.

## Tests

```bash
dart test
```

Le dossier `test/` contient des tests unitaires couvrant :
- la création des tâches et la génération d'identifiants uniques
- la levée des exceptions personnalisées (priorité invalide, tâche introuvable)
- la suppression d'une tâche
- la mise à jour d'une tâche
- le tri des tâches par priorité

## Structure du projet

```
.
├── main.dart              # Point d'entrée, menu interactif CLI
├── model.dart              # Classe abstraite Task et ses sous-classes
├── repository.dart          # Interface générique Repository<T>
├── taskRepository.dart      # Implémentation concrète, persistance JSON
├── exceptions.dart          # Exceptions personnalisées
├── tasks.json                # Fichier de persistance (généré à l'exécution)
└── test/                     # Tests unitaires
```