# Changelog

Toutes les modifications notables du projet sont documentees dans ce fichier.

## [0.2.1] - 2026-02-16

### Ajoute

- **Analyse du projet** : fichier `docs/SUGGESTIONS.md` avec toutes les pistes d'amelioration identifiees
  - 6 fonctionnalites manquantes prioritaires (auth, CRUD, commentaires, likes, tags, messagerie)
  - 4 ameliorations techniques (validations, tests, gestion erreurs, pagination)
  - 5 ameliorations UX/UI (formulaires, flash messages, avatars, recherche)
  - 7 fonctionnalites avancees (Turbo/Stimulus, API JSON, notifications, follow, admin, mailers, images)
  - Tableau de priorite avec niveaux de complexite

## [0.2.0] - 2026-02-16

### Ajoute

- **Pages statiques** : page Team (`/team`) et page Contact (`/contact`)
- **Bootstrap 5.3.3** via CDN (CSS + JS) avec theme dark (`data-bs-theme="dark"`)
- **Navbar** responsive dans le layout avec liens Accueil, Team, Contact
- **Landing page personnalisee** : `/welcome/:first_name` affiche un message de bienvenue dynamique
- **Page d'accueil** (`/`) : liste de tous les potins en cards Bootstrap (titre + auteur + lien "Voir plus")
- **Page detail potin** (`/gossips/:id`) : titre, contenu, auteur cliquable, date de creation
- **Page profil utilisateur** (`/users/:id`) : infos personnelles + liste de ses potins
- **Controllers** : `GossipsController` (index, show), `UsersController` (show), `StaticPagesController` (team, contact, welcome)
- **Documentation** dans `docs/`

## [0.1.0] - 2026-02-16

### Ajoute

- Initialisation du projet Rails 8.1.2 (Ruby 3.4.2, SQLite3)
- Import des migrations depuis le projet backend original (9 tables)
- Import des models avec associations :
  - 1-N : City -> Users, User -> Gossips, User -> Comments, User -> Likes
  - N-N : Gossip <-> Tag (via JoinTableGossipTag), PrivateMessage <-> User (via PrivateMessageRecipient)
  - Polymorphique : Comment (commentable: Gossip/Comment), Like (likeable: Gossip/Comment)
- Import du fichier seeds avec donnees Faker
- Gem `faker` ajoutee au Gemfile
