# Contribuer

## Environnement

- Ruby 3.4.2, Rails 8.1.x
- Cloner le repo, `bundle install`, `rails db:seed`
- Vérifier que les tests et le linter passent avant de pousser

## Workflow

1. Créer une branche depuis `main` (ex. `feature/ma-fonctionnalite`, `fix/description`)
2. Commits clairs et atomiques
3. Ouvrir une Pull Request vers `main`
4. Mettre à jour `CHANGELOG.md` dans une section adaptée (Ajoute / Modifie / Corrige) pour la version cible

## Code

- Respecter le style Ruby/Rails du projet
- Pas de code commenté inutile ; pas de `puts` / `console.log` laissés pour le debug
- Nouvelles dépendances : les justifier brièvement en PR

## Changelog

Les changements notables doivent être documentés dans `CHANGELOG.md`. Voir `.cursor/rules/changelog.mdc` pour le format.
