# Mettre en ligne avec Heroku et PostgreSQL

Ce guide décrit comment déployer The Gossip Project sur Heroku avec PostgreSQL, puis comment restreindre l’accès aux utilisateurs connectés (login et cookies).

---

## Partie 1 — Déploiement sur Heroku avec PostgreSQL

### Prérequis

- Compte [Heroku](https://signup.heroku.com/)
- [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) installé (`heroku --version`)
- Git (le code doit être versionné)

### 1.1 Adapter le projet pour PostgreSQL

Heroku ne conserve pas les fichiers entre déploiements ; SQLite ne convient pas. Il faut utiliser PostgreSQL en production.

**Gemfile** — ajouter la gem `pg` en production et garder SQLite en dev/test :

```ruby
# En haut du Gemfile, remplacer ou compléter la section des gems de BDD :
# Use sqlite3 as the database for development and test
gem "sqlite3", ">= 2.1", group: %i[ development test ]

# Use PostgreSQL in production (Heroku)
gem "pg", "~> 1.5", group: :production
```

Puis exécuter :

```bash
bundle install
```

**config/database.yml** — configurer la production pour PostgreSQL via la variable d’environnement que Heroku fournit :

En production, Heroku définit `DATABASE_URL`. Rails peut l’utiliser automatiquement. Adapter la section `production` :

```yaml
production:
  url: <%= ENV["DATABASE_URL"] %>
  # Si tu utilises des bases secondaires (cache, queue, cable), les définir aussi
  # ou garder une config simple avec une seule base :
  # primary, cache, queue, cable peuvent pointer vers DATABASE_URL ou des variantes
```

Exemple minimal (une seule base en prod) :

```yaml
production:
  primary: &production_primary
    url: <%= ENV["DATABASE_URL"] %>
    migrations_paths: db/migrate
  cache: *production_primary
  queue: *production_primary
  cable: *production_primary
```

(À adapter selon ta structure actuelle : si tu as déjà `primary`, `cache`, `queue`, `cable` avec des chemins différents, garde la même structure en pointant chaque base vers la bonne URL ou une seule URL partagée.)

### 1.2 Secrets et variables d’environnement

Devise utilise une clé secrète (secret_key_base) et souvent une clé pour Devise.

- **secret_key_base** : Rails le génère en prod à partir de `SECRET_KEY_BASE` si la variable est définie. Heroku peut le générer ; sinon exécuter `rails secret` et définir la config var.
- **Devise** : en production, définir une clé dédiée (optionnel mais recommandé) :

```bash
# À faire après avoir créé l’app Heroku (voir plus bas)
heroku config:set SECRET_KEY_BASE=$(rails secret)
```

### 1.3 Fichiers nécessaires pour Heroku

- **Procfile** à la racine du projet :

```
web: bin/rails server -p ${PORT:-5000} -e ${RAILS_ENV:-production}
```

- **runtime.txt** (optionnel) pour fixer la version de Ruby :

```
ruby-3.4.2
```

- Vérifier que **Gemfile.lock** est commité (pour que Heroku utilise les bonnes versions).

### 1.4 Déployer sur Heroku

1. Se connecter :

```bash
heroku login
```

2. Créer l’application (depuis la racine du dépôt Git) :

```bash
heroku create
# ou avec un nom : heroku create the-gossip-project
```

3. Ajouter l’add-on PostgreSQL :

```bash
heroku addons:create heroku-postgresql:essential-0
```

Heroku définit automatiquement `DATABASE_URL`. Tu peux vérifier avec `heroku config`.

4. Pousser le code et exécuter les migrations :

```bash
git push heroku main
# ou : git push heroku master
```

Puis :

```bash
heroku run rails db:migrate
heroku run rails db:seed   # optionnel, pour des données de démo
```

5. Ouvrir l’app :

```bash
heroku open
```

En cas d’erreur, consulter les logs : `heroku logs --tail`.

### 1.5 Résumé des commandes utiles

| Action              | Commande                          |
|---------------------|-----------------------------------|
| Voir les config vars| `heroku config`                   |
| Lancer la console   | `heroku run rails console`       |
| Migrations          | `heroku run rails db:migrate`     |
| Logs en direct      | `heroku logs --tail`              |
| Redémarrer les dynos| `heroku restart`                 |

---

## Partie 2 — Accès réservé aux utilisateurs connectés (login et cookies)

L’app utilise déjà **Devise** pour l’authentification (inscription, connexion, déconnexion). Les cookies de session permettent de garder l’utilisateur connecté.

Pour rendre **tout le site** accessible uniquement aux utilisateurs connectés :

### 2.1 Exiger la connexion sur toutes les pages

Dans **ApplicationController**, ajouter un `before_action` qui redirige les visiteurs non connectés vers la page de connexion :

```ruby
class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :authenticate_user!

  private

  def record_not_found
    render file: Rails.public_path.join("404.html"), layout: false, status: :not_found
  end
end
```

Sans exception, **tous** les contrôleurs exigeront un utilisateur connecté. Les pages Devise (connexion, inscription, mot de passe) doivent rester accessibles sans être connecté. Il faut donc **exclure** le contrôleur Devise :

```ruby
before_action :authenticate_user!, unless: :devise_controller?
```

Si la méthode `devise_controller?` n’est pas définie (erreur au chargement), l’ajouter dans **ApplicationController** :

```ruby
def devise_controller?
  controller_path.start_with?("devise")
end
```

Ainsi :

- Les visiteurs non connectés sont redirigés vers la page de connexion (ou d’inscription selon la config Devise).
- Les actions Devise (sessions, registrations, passwords) restent accessibles.

### 2.2 (Optionnel) Exclure d’autres contrôleurs

Si tu veux laisser certaines actions publiques (par exemple une page d’accueil ou une page statique), tu peux :

- Soit ne pas mettre `authenticate_user!` dans `ApplicationController` et le garder uniquement dans les contrôleurs qui en ont besoin (comme actuellement).
- Soit utiliser `skip_before_action :authenticate_user!` dans les contrôleurs ou actions à laisser publiques.

Exemple pour tout un contrôleur :

```ruby
class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :team, :contact ]
  # ...
end
```

### 2.3 Rappel : cookies et session

- Devise utilise la **session Rails** (cookie chiffré) pour savoir qui est connecté.
- En production sur Heroku, vérifier que :
  - `SECRET_KEY_BASE` est défini (pour le chiffrement des cookies).
  - Tu n’as pas désactivé les cookies dans l’app.
  - En HTTPS (Heroku le fournit), les cookies de session sont plus sûrs si la config de session le prévoit (Rails le gère en production avec `config.force_ssl` si activé).

### 2.4 Résumé

| Objectif                         | Action |
|----------------------------------|--------|
| Site entièrement protégé        | `before_action :authenticate_user!, unless: :devise_controller?` dans `ApplicationController` |
| Garder quelques pages publiques  | `skip_before_action :authenticate_user!` dans les contrôleurs ou actions concernés |
| Comportement actuel (partiel)    | Garder `authenticate_user!` uniquement dans GossipsController, CommentsController, LikesController sur les actions d’écriture |

---

## Checklist déploiement

- [ ] Gemfile : `pg` en production, SQLite en dev/test
- [ ] `config/database.yml` : production avec `ENV["DATABASE_URL"]`
- [ ] `bundle install` et commit du Gemfile.lock
- [ ] Procfile (et éventuellement runtime.txt) présent et commité
- [ ] `heroku create`, add-on PostgreSQL, `git push heroku main`
- [ ] `heroku run rails db:migrate` (et `db:seed` si besoin)
- [ ] Config vars : `SECRET_KEY_BASE` (et toute variable utilisée en prod)
- [ ] (Optionnel) Accès réservé aux connectés : `before_action :authenticate_user!, unless: :devise_controller?` dans `ApplicationController`

---

## Références

- [Heroku – Deploying Rails](https://devcenter.heroku.com/articles/getting-started-with-rails8)
- [Heroku PostgreSQL](https://devcenter.heroku.com/articles/heroku-postgresql)
- [Devise – Controllers](https://github.com/heartcombo/devise#controller-filters)
