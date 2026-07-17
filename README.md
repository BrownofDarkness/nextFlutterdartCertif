# nextFlutterDartCertif

Repository pour la complétion du parcours Dart de NextFlutter.

## Description

Application CLI (ligne de commande) de gestion de tâches, écrite en Dart pur (sans Flutter). Elle permet d'ajouter, lister, trier, mettre à jour, marquer comme terminée et supprimer des tâches, avec persistance des données dans un fichier JSON local.

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

Un menu interactif s'affiche dans le terminal, permettant de choisir une action parmi :

1. Ajouter une tâche
2. Supprimer une tâche
3. Mettre à jour une tâche
4. Lister toutes les tâches
5. Trier les tâches par priorité
6. Trier les tâches par date d'échéance
7. Marquer une tâche comme terminée
0. Quitter

## Fonctionnalités

- **Ajouter une tâche** : titre, priorité (`low`, `medium`, `high`), date limite optionnelle
- **Lister toutes les tâches**, avec leur statut (terminée ou non)
- **Trier les tâches** par priorité ou par date limite, sans perdre aucune tâche de la liste
- **Mettre à jour** le titre ou la date limite d'une tâche existante
- **Marquer une tâche comme terminée**
- **Supprimer** une tâche
- **Persistance automatique** dans un fichier `tasks.json` local à chaque modification (ajout, mise à jour, suppression, complétion)

## Architecture

- **Classes abstraites et héritage** : `Task` est une classe abstraite dont héritent `UrgentTask`, `MediumTask` et `LowTask`. Chaque sous-classe a un comportement d'affichage distinct via `toString()`, en plus de partager les champs communs (`id`, `title`, `priority`, `dueDate`, `isCompleted`).
- **Interface** : `Repository<T>` définit un contrat générique (`saveElt`, `listElts`, `updateElt`, `deleteElt`), implémenté par `TaskRepository` avec `T = Task`. La classe est déclarée abstraite sans aucune implémentation de méthode, pour jouer le rôle d'un contrat pur.
- **Génériques** : `Repository<T>` permet de définir la mécanique de persistance indépendamment du type concret manipulé — `T` est fixé à `Task` dans `TaskRepository implements Repository<Task>`.
- **Gestion des erreurs** : exceptions personnalisées (`InvalidPriorityException`, `TaskNotFoundException`) signalent les cas d'usage invalides (priorité incorrecte, tâche introuvable), levées par `addTask`, `removeTask`, `updateTask` et `completeTask`.
- **Persistance JSON** : chaque tâche est sérialisée/désérialisée via `toJson()` / `Task.fromJson()`, avec reconstruction automatique de la bonne sous-classe selon le champ `priority`. Une priorité invalide dans le JSON lève `InvalidPriorityException` plutôt que d'être ignorée silencieusement.
- **Identifiants uniques** : chaque tâche reçoit un `id` généré à la création (horodatage + nombre aléatoire), préservé lors des mises à jour via `copyWith`.

## Tests

```bash
dart test
```

Le dossier `test/` contient des tests unitaires répartis par responsabilité :

- `model_test.dart` — création des tâches, génération d'identifiants uniques
- `task_repository_add_test.dart` — validation de la priorité à l'ajout
- `task_repository_remove_test.dart` — suppression d'une tâche existante, gestion d'un id inexistant
- `task_repository_update_test.dart` — mise à jour d'une tâche
- `task_repository_sort_test.dart` — tri des tâches par priorité
- `task_repository_complete_test.dart` — marquage d'une tâche comme terminée

## Qualité de code

```bash
dart analyze
```

Un fichier `analysis_options.yaml` est configuré avec les règles recommandées (`package:lints/recommended.yaml`).

## Structure du projet

```
.
├── main.dart                 # Point d'entrée, menu interactif CLI
├── model.dart                 # Classe abstraite Task et ses sous-classes
├── repository.dart             # Interface générique Repository<T>
├── task_repository.dart        # Implémentation concrète, persistance JSON
├── exceptions.dart              # Exceptions personnalisées
├── analysis_options.yaml        # Configuration du linter
├── tasks.json                    # Fichier de persistance (généré à l'exécution)
└── test/                          # Tests unitaires (voir section Tests)
```